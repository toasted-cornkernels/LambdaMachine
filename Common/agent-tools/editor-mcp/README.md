# editor-mcp

An MCP server that gives CLI agents access to your live Emacs and Neovim.
Agents can read context the editor already has: unsaved buffers, LSP, tree-sitter, project and VC state, and compilation output.
They can also use buffers as a programmable string-manipulation workspace, and compose editor commands or write their own Elisp or Lua.

It uses only the Python standard library.
The editor side needs no setup: each call loads `editor-mcp.el` through `emacsclient --eval`, or `editor-mcp.lua` through `nvim --remote-expr`.

## Tools

| Emacs                | Neovim              | Purpose                                             |
|----------------------|---------------------|-----------------------------------------------------|
| `emacs_eval`         | `nvim_lua`          | Run arbitrary code, optionally in a given buffer    |
| —                    | `nvim_ex`           | Run Ex commands and capture their output            |
| `emacs_transform`    | `nvim_transform`    | Rewrite text in a scratch buffer, return the result |
| `emacs_list_buffers` | `nvim_list_buffers` | List open buffers                                   |
| `emacs_read_buffer`  | `nvim_read_buffer`  | Read lines from a buffer, including unsaved edits   |
| `emacs_describe`     | `nvim_help`         | Documentation                                       |
| `emacs_apropos`      | `nvim_complete`     | Discover available commands, functions and options  |

## Which editor it connects to

- **Emacs:** the server at `$EDITOR_MCP_EMACS_SOCKET`, otherwise the default server socket (`M-x server-start`).
- **Neovim:** `$EDITOR_MCP_NVIM_SERVER`, otherwise `$NVIM` (set when the agent runs inside a `:terminal`), otherwise the most recently active socket under `stdpath('run')`.
- **No editor found:** it starts a private Emacs daemon or headless Neovim with your config, and stops it when the server exits. Set `EDITOR_MCP_NO_SPAWN=1` to turn this off.

## Registration

`Common/modules/editor-mcp.nix` installs `editor-mcp` on `PATH` and registers it in `~/.copilot/mcp-config.json`.
For other agents, for example Claude Code:

```sh
claude mcp add editor -- editor-mcp
```

Code runs with your full privileges inside your editor, so approve tool calls with care.
