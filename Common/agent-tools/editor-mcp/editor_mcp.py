#!/usr/bin/env python3
"""editor-mcp: expose live Emacs and Neovim instances to CLI agents over MCP.

Speaks MCP (newline-delimited JSON-RPC 2.0) on stdio, standard library only.

Emacs is reached with `emacsclient --eval`; Neovim with
`nvim --server ADDR --remote-expr`. Each request is written to a JSON file and
evaluated by a small runtime (editor-mcp.el / editor-mcp.lua) inside the editor,
which writes its reply to another JSON file. No editor-side setup is required.

Environment:
  EDITOR_MCP_EMACS_SOCKET   emacsclient -s value (name or path); default server otherwise
  EDITOR_MCP_NVIM_SERVER    Neovim RPC address; falls back to $NVIM, then discovery
  EDITOR_MCP_EMACSCLIENT    emacsclient binary (default: emacsclient)
  EDITOR_MCP_EMACS          emacs binary used to start a fallback daemon (default: emacs)
  EDITOR_MCP_NVIM           nvim binary (default: nvim)
  EDITOR_MCP_NO_SPAWN       if set, never start a fallback editor
"""

import atexit
import glob
import json
import os
import shutil
import subprocess
import sys
import tempfile
import time
import traceback

HERE = os.path.dirname(os.path.realpath(__file__))
EL_RUNTIME = os.path.join(HERE, "editor-mcp.el")
LUA_RUNTIME = os.path.join(HERE, "editor-mcp.lua")
SERVER_NAME = "editor-mcp"
SERVER_VERSION = "0.1.0"
DEFAULT_TIMEOUT = 60

EMACSCLIENT = os.environ.get("EDITOR_MCP_EMACSCLIENT", "emacsclient")
EMACS = os.environ.get("EDITOR_MCP_EMACS", "emacs")
NVIM = os.environ.get("EDITOR_MCP_NVIM", "nvim")
NO_SPAWN = bool(os.environ.get("EDITOR_MCP_NO_SPAWN"))

WORKDIR = tempfile.mkdtemp(prefix="editor-mcp-")
atexit.register(shutil.rmtree, WORKDIR, True)


class EditorError(Exception):
    pass


def _exchange(request, invoke):
    """Write REQUEST to a file, let INVOKE run the editor, read the reply."""
    fd, req_path = tempfile.mkstemp(suffix=".json", dir=WORKDIR)
    resp_path = req_path[:-5] + ".out.json"
    try:
        with os.fdopen(fd, "w", encoding="utf-8") as f:
            json.dump(request, f)
        invoke(req_path, resp_path)
        try:
            with open(resp_path, encoding="utf-8") as f:
                return json.load(f)
        except FileNotFoundError:
            raise EditorError("Editor produced no response (did the runtime fail to load?)")
    finally:
        for p in (req_path, resp_path):
            try:
                os.unlink(p)
            except FileNotFoundError:
                pass


def _run(cmd, timeout):
    try:
        return subprocess.run(
            cmd, capture_output=True, text=True, timeout=timeout, stdin=subprocess.DEVNULL
        )
    except FileNotFoundError:
        raise EditorError(f"Executable not found: {cmd[0]}")
    except subprocess.TimeoutExpired:
        raise EditorError(
            f"Timed out after {timeout}s. The editor may be blocked on a prompt, "
            "or the code may still be running inside it."
        )


def _lisp_str(s):
    return '"' + s.replace("\\", "\\\\").replace('"', '\\"') + '"'


def _vim_str(s):
    return "'" + s.replace("'", "''") + "'"


class Emacs:
    def __init__(self):
        self.socket = os.environ.get("EDITOR_MCP_EMACS_SOCKET")
        self.resolved = False
        self.spawned = None

    def _client(self, socket):
        return [EMACSCLIENT] + (["-s", socket] if socket else [])

    def _alive(self, socket):
        try:
            r = _run(self._client(socket) + ["--eval", "t"], 10)
        except EditorError:
            return False
        return r.returncode == 0

    def _resolve(self):
        if self.resolved:
            return
        if self._alive(self.socket):
            self.resolved = True
            return
        if self.socket or NO_SPAWN:
            raise EditorError(
                "No Emacs server reachable"
                + (f" at socket {self.socket!r}" if self.socket else "")
                + ". Run M-x server-start in Emacs."
            )
        name = f"editor-mcp-{os.getpid()}"
        r = _run([EMACS, f"--daemon={name}"], 120)
        if r.returncode != 0 or not self._alive(name):
            raise EditorError(f"Could not start an Emacs daemon:\n{r.stderr[-2000:]}")
        self.socket = self.spawned = name
        atexit.register(self._shutdown)
        self.resolved = True

    def _shutdown(self):
        if self.spawned:
            subprocess.run(
                self._client(self.spawned) + ["--eval", "(kill-emacs)"],
                capture_output=True, timeout=10,
            )

    def describe_target(self):
        self._resolve()
        if self.spawned:
            return f"background Emacs daemon {self.spawned!r} started by editor-mcp"
        return f"Emacs server {self.socket or '(default socket)'}"

    def call(self, request, timeout=DEFAULT_TIMEOUT):
        self._resolve()

        def invoke(req_path, resp_path):
            form = (
                f"(progn (load {_lisp_str(EL_RUNTIME)} nil t t) "
                f"(editor-mcp-run {_lisp_str(req_path)} {_lisp_str(resp_path)}))"
            )
            r = _run(self._client(self.socket) + ["--eval", form], timeout)
            if r.returncode != 0:
                self.resolved = False
                raise EditorError(f"emacsclient failed:\n{(r.stderr or r.stdout)[-2000:]}")

        return _exchange(request, invoke)


class Neovim:
    def __init__(self):
        self.addr = os.environ.get("EDITOR_MCP_NVIM_SERVER") or os.environ.get("NVIM")
        self.pinned = bool(self.addr)
        self.resolved = False
        self.proc = None

    def _remote(self, addr, expr, timeout):
        return _run([NVIM, "--headless", "--clean", "--server", addr, "--remote-expr", expr], timeout)

    def _alive(self, addr):
        try:
            r = self._remote(addr, "1", 5)
        except EditorError:
            return False
        return r.returncode == 0 and r.stdout.strip() == "1"

    @staticmethod
    def _candidates():
        user = os.environ.get("USER", "")
        patterns = [
            os.path.join(tempfile.gettempdir(), f"nvim.{user}", "*", "nvim.*.0"),
            os.path.join("/tmp", f"nvim.{user}", "*", "nvim.*.0"),
        ]
        if os.environ.get("XDG_RUNTIME_DIR"):
            patterns.append(os.path.join(os.environ["XDG_RUNTIME_DIR"], "nvim.*.0"))
        found = {p for pat in patterns for p in glob.glob(pat)}
        return sorted(found, key=lambda p: os.path.getmtime(p), reverse=True)

    def _resolve(self):
        if self.resolved:
            return
        if self.addr and self._alive(self.addr):
            self.resolved = True
            return
        if self.pinned:
            raise EditorError(f"No Neovim server reachable at {self.addr!r}")
        for cand in self._candidates():
            if self._alive(cand):
                self.addr = cand
                self.resolved = True
                return
        if NO_SPAWN:
            raise EditorError("No running Neovim found. Start one, or set EDITOR_MCP_NVIM_SERVER.")
        addr = os.path.join(WORKDIR, "nvim.sock")
        try:
            self.proc = subprocess.Popen(
                [NVIM, "--headless", "--listen", addr],
                stdin=subprocess.DEVNULL, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
                start_new_session=True,
            )
        except FileNotFoundError:
            raise EditorError(f"Executable not found: {NVIM}")
        atexit.register(self.proc.terminate)
        deadline = time.time() + 30
        while time.time() < deadline:
            if os.path.exists(addr) and self._alive(addr):
                self.addr = addr
                self.resolved = True
                return
            time.sleep(0.1)
        raise EditorError("Started a headless Neovim but could not connect to it")

    def describe_target(self):
        self._resolve()
        if self.proc:
            return f"headless Neovim started by editor-mcp at {self.addr}"
        return f"Neovim server {self.addr}"

    def call(self, request, timeout=DEFAULT_TIMEOUT):
        self._resolve()

        def invoke(req_path, resp_path):
            expr = (
                "luaeval('dofile(_A[1])(_A[2], _A[3])', ["
                + ", ".join(_vim_str(p) for p in (LUA_RUNTIME, req_path, resp_path))
                + "])"
            )
            r = self._remote(self.addr, expr, timeout)
            if r.returncode != 0:
                self.resolved = False
                raise EditorError(f"nvim --remote-expr failed:\n{(r.stderr or r.stdout)[-2000:]}")

        return _exchange(request, invoke)


EMACS_EDITOR = Emacs()
NVIM_EDITOR = Neovim()

TIMEOUT_PROP = {
    "type": "integer",
    "description": f"Seconds to wait for the editor (default {DEFAULT_TIMEOUT}).",
}


def _tool(name, description, properties, required, editor, build):
    props = dict(properties)
    props["timeout"] = TIMEOUT_PROP
    return {
        "name": name,
        "description": description,
        "inputSchema": {"type": "object", "properties": props, "required": required},
        "_editor": editor,
        "_build": build,
    }


def _pick(args, *keys):
    return {k: args[k] for k in keys if args.get(k) is not None}


TOOLS = [
    # ---------------------------------------------------------------- Emacs
    _tool(
        "emacs_eval",
        "Evaluate Emacs Lisp in the user's running Emacs (lexical binding) and return the value "
        "of the last form. Strings come back raw; other values are prin1'd. Anything printed to "
        "standard-output (princ, print) is returned as 'output'. Use this to compose any Emacs "
        "command or library (xref, project, imenu, treesit, eglot, vc, org, calc, ...) into "
        "bespoke solutions. Code runs with the user's full privileges and live state.",
        {
            "code": {"type": "string", "description": "One or more Emacs Lisp forms."},
            "buffer": {"type": "string", "description": "Evaluate with this buffer current (with-current-buffer)."},
        },
        ["code"],
        EMACS_EDITOR,
        lambda a: {"op": "eval", **_pick(a, "code", "buffer")},
    ),
    _tool(
        "emacs_transform",
        "Use an Emacs buffer as a programmable string-manipulation workspace. TEXT is inserted "
        "into a fresh temporary buffer (optionally in a major mode, with mode hooks suppressed), "
        "point is placed at the start, then CODE runs there. Returns the final buffer contents "
        "as 'buffer' plus CODE's value as 'result'. Ideal for regexp search/replace loops, "
        "sort-lines, align-regexp, fill-paragraph, rectangle ops, keyboard macros "
        "(execute-kbd-macro), sexp/treesit-aware motion, indent-region, etc. Nothing in the "
        "user's buffers is touched.",
        {
            "text": {"type": "string", "description": "Initial buffer contents."},
            "code": {"type": "string", "description": "Emacs Lisp forms to run in the scratch buffer."},
            "mode": {"type": "string", "description": "Major mode function, e.g. 'python-ts-mode', 'org-mode'."},
        },
        ["text", "code"],
        EMACS_EDITOR,
        lambda a: {"op": "transform", **_pick(a, "text", "code", "mode")},
    ),
    _tool(
        "emacs_list_buffers",
        "List the user's Emacs buffers: name, major mode, file, size, modified flag.",
        {},
        [],
        EMACS_EDITOR,
        lambda a: {"op": "buffers"},
    ),
    _tool(
        "emacs_read_buffer",
        "Read lines from a live Emacs buffer (including unsaved edits and non-file buffers like "
        "*compilation*, *xref*, *Messages*, magit), with line numbers and point location.",
        {
            "buffer": {"type": "string", "description": "Buffer name."},
            "start_line": {"type": "integer"},
            "end_line": {"type": "integer"},
        },
        ["buffer"],
        EMACS_EDITOR,
        lambda a: {"op": "read", **_pick(a, "buffer", "start_line", "end_line")},
    ),
    _tool(
        "emacs_describe",
        "Show the signature, key binding and documentation of an Emacs function/command and/or "
        "the value and documentation of a variable.",
        {"symbol": {"type": "string"}},
        ["symbol"],
        EMACS_EDITOR,
        lambda a: {"op": "describe", **_pick(a, "symbol")},
    ),
    _tool(
        "emacs_apropos",
        "Discover Emacs functions/variables whose names match a regexp, with one-line docs. "
        "Use it to find out which commands exist before composing them.",
        {
            "pattern": {"type": "string", "description": "Regexp matched against symbol names."},
            "commands_only": {"type": "boolean", "description": "Only interactive commands."},
            "limit": {"type": "integer", "description": "Max results (default 200)."},
        },
        ["pattern"],
        EMACS_EDITOR,
        lambda a: {"op": "apropos", **_pick(a, "pattern", "commands_only", "limit")},
    ),
    # --------------------------------------------------------------- Neovim
    _tool(
        "nvim_lua",
        "Run Lua in the user's running Neovim and return the result (strings raw, other values "
        "via vim.inspect; print() output is returned as 'output'). Accepts an expression or a "
        "statement block with 'return'. Full access to vim.api, vim.fn, vim.lsp, vim.treesitter, "
        "vim.diagnostic and installed plugins. If BUFFER is given, code runs with that buffer "
        "current and receives its handle as '...'. Code runs with the user's full privileges.",
        {
            "code": {"type": "string"},
            "buffer": {"type": "string", "description": "Buffer number or name."},
        },
        ["code"],
        NVIM_EDITOR,
        lambda a: {"op": "lua", **_pick(a, "code", "buffer")},
    ),
    _tool(
        "nvim_ex",
        "Run Ex command(s) in the user's running Neovim and return their output "
        "(nvim_exec2 with output capture). Multiple lines are run as a script. E.g. ':ls', "
        "':marks', ':jumps', ':registers', ':scriptnames', ':verbose map <leader>f', "
        "':vimgrep /pat/ **/*.lua | copen', ':filter /pat/ oldfiles'.",
        {
            "command": {"type": "string"},
            "buffer": {"type": "string", "description": "Run with this buffer current."},
        },
        ["command"],
        NVIM_EDITOR,
        lambda a: {"op": "ex", **_pick(a, "command", "buffer")},
    ),
    _tool(
        "nvim_transform",
        "Use a Neovim buffer as a programmable string-manipulation workspace. TEXT is loaded into "
        "a hidden scratch buffer, then each Ex command in COMMANDS runs in order (:s, :g/pat/cmd, "
        ":v, :sort, :normal! with any motions/text objects/macros, :norm on ranges, ...), then "
        "optional Lua CODE runs with the buffer handle as '...'. Returns the final contents as "
        "'buffer'. Autocmds are skipped when setting FILETYPE unless AUTOCMDS is true; call "
        "vim.treesitter.get_parser(...) yourself for syntax-aware edits. User buffers are untouched.",
        {
            "text": {"type": "string"},
            "commands": {"type": "array", "items": {"type": "string"}},
            "code": {"type": "string", "description": "Lua run after COMMANDS."},
            "filetype": {"type": "string"},
            "autocmds": {"type": "boolean"},
        },
        ["text"],
        NVIM_EDITOR,
        lambda a: {"op": "transform", **_pick(a, "text", "commands", "code", "filetype", "autocmds")},
    ),
    _tool(
        "nvim_list_buffers",
        "List the user's listed Neovim buffers: number, name, filetype, line count, modified flag.",
        {},
        [],
        NVIM_EDITOR,
        lambda a: {"op": "buffers"},
    ),
    _tool(
        "nvim_read_buffer",
        "Read lines from a live Neovim buffer (including unsaved edits, terminal and quickfix "
        "buffers) with line numbers and cursor position. Defaults to the current buffer.",
        {
            "buffer": {"type": "string", "description": "Buffer number or name."},
            "start_line": {"type": "integer"},
            "end_line": {"type": "integer"},
        },
        [],
        NVIM_EDITOR,
        lambda a: {"op": "read", **_pick(a, "buffer", "start_line", "end_line")},
    ),
    _tool(
        "nvim_complete",
        "Discover Neovim names via getcompletion(): KIND is 'command', 'function', 'option', "
        "'help', 'lua', 'highlight', 'event', 'filetype', 'mapping', 'file', ... Use it to find "
        "what exists before composing commands.",
        {
            "pattern": {"type": "string"},
            "kind": {"type": "string", "description": "getcompletion() type (default 'command')."},
            "limit": {"type": "integer"},
        },
        ["pattern"],
        NVIM_EDITOR,
        lambda a: {"op": "complete", **_pick(a, "pattern", "kind", "limit")},
    ),
    _tool(
        "nvim_help",
        "Read Neovim (and plugin) :help for an exact tag such as ':substitute', 'nvim_buf_set_text()', "
        "'vim.treesitter.get_parser()', \"'textwidth'\". Without opening any window.",
        {
            "topic": {"type": "string"},
            "lines": {"type": "integer", "description": "Lines to return (default 80)."},
        },
        ["topic"],
        NVIM_EDITOR,
        lambda a: {"op": "help", **_pick(a, "topic", "lines")},
    ),
]
TOOLS_BY_NAME = {t["name"]: t for t in TOOLS}

INSTRUCTIONS = (
    "editor-mcp connects you to the user's live Emacs and Neovim. Buffers are a powerful "
    "string-manipulation interface: prefer emacs_transform / nvim_transform for multi-step text "
    "rewriting, and emacs_eval / nvim_lua / nvim_ex to pull context the editor already has "
    "(open and unsaved buffers, LSP diagnostics and references, tree-sitter trees, project "
    "files, git state, compilation output). Discover capabilities with emacs_apropos, "
    "emacs_describe, nvim_complete and nvim_help, then compose them, or write bespoke Elisp/Lua. "
    "Avoid changing the user's visible editor state (windows, point, unsaved buffers) unless asked."
)


def call_tool(name, args):
    tool = TOOLS_BY_NAME.get(name)
    if not tool:
        raise EditorError(f"Unknown tool {name}")
    timeout = int(args.get("timeout") or DEFAULT_TIMEOUT)
    resp = tool["_editor"].call(tool["_build"](args), timeout)
    parts = []
    if "error" in resp:
        parts.append("ERROR: " + resp["error"])
    if resp.get("output"):
        parts.append("--- output ---\n" + resp["output"])
    if "buffer" in resp:
        parts.append("--- buffer ---\n" + resp["buffer"])
        if resp.get("result") not in (None, "nil"):
            parts.append("--- result ---\n" + resp["result"])
    elif "result" in resp:
        parts.append(resp["result"])
    return "\n".join(parts) if parts else "(no output)", "error" in resp


def handle(msg):
    method = msg.get("method")
    params = msg.get("params") or {}
    if method == "initialize":
        return {
            "protocolVersion": params.get("protocolVersion", "2025-06-18"),
            "capabilities": {"tools": {}},
            "serverInfo": {"name": SERVER_NAME, "version": SERVER_VERSION},
            "instructions": INSTRUCTIONS,
        }
    if method == "ping":
        return {}
    if method == "tools/list":
        return {
            "tools": [{k: v for k, v in t.items() if not k.startswith("_")} for t in TOOLS]
        }
    if method == "tools/call":
        try:
            text, is_error = call_tool(params.get("name"), params.get("arguments") or {})
        except EditorError as e:
            text, is_error = f"ERROR: {e}", True
        return {"content": [{"type": "text", "text": text}], "isError": is_error}
    raise LookupError(method)


def main():
    for line in sys.stdin:
        line = line.strip()
        if not line:
            continue
        try:
            msg = json.loads(line)
        except json.JSONDecodeError:
            continue
        if "id" not in msg:
            continue  # notifications need no reply
        try:
            reply = {"jsonrpc": "2.0", "id": msg["id"], "result": handle(msg)}
        except LookupError as e:
            reply = {"jsonrpc": "2.0", "id": msg["id"],
                     "error": {"code": -32601, "message": f"Method not found: {e}"}}
        except Exception:
            reply = {"jsonrpc": "2.0", "id": msg["id"],
                     "error": {"code": -32603, "message": traceback.format_exc()[-2000:]}}
        sys.stdout.write(json.dumps(reply) + "\n")
        sys.stdout.flush()


if __name__ == "__main__":
    main()
