-- Neovim-side runtime for editor-mcp.
-- Executed in a running Neovim through `nvim --server ... --remote-expr`.
-- Requests and responses travel through JSON files so that arbitrary text
-- never has to survive shell or Vimscript string quoting.

local function slurp(path)
  local f = assert(io.open(path, 'rb'))
  local s = f:read('*a')
  f:close()
  return s
end

local function format(v)
  if type(v) == 'string' then
    return v
  elseif v == nil then
    return 'nil'
  end
  return vim.inspect(v)
end

-- Accept both expressions ("vim.bo.filetype") and statement blocks.
local function compile(code)
  local chunk = load('return ' .. code, '=agent')
  if chunk then
    return chunk
  end
  local err
  chunk, err = load(code, '=agent')
  if not chunk then
    error(err, 0)
  end
  return chunk
end

local function resolve_buf(spec)
  if spec == nil or spec == '' then
    return vim.api.nvim_get_current_buf()
  end
  local n = tonumber(spec) or vim.fn.bufnr(spec)
  if n == nil or n < 0 or not vim.api.nvim_buf_is_valid(n) then
    error('No buffer matching ' .. tostring(spec), 0)
  end
  return n
end

local function split_text(text)
  local trailing = text:sub(-1) == '\n'
  if trailing then
    text = text:sub(1, -2)
  end
  return vim.split(text, '\n', { plain = true }), trailing
end

-- Errors crossing nvim_buf_call arrive pre-wrapped with a traceback, so catch
-- them inside and re-raise only the message outside.
local function in_buf(buf, fn)
  local ok, res
  vim.api.nvim_buf_call(buf, function()
    ok, res = pcall(fn)
  end)
  if not ok then
    error(res, 0)
  end
  return res
end

local function run_ex(cmd, label)
  local ok, err = pcall(vim.cmd, cmd)
  if not ok then
    err = tostring(err)
    error((label or '') .. (err:match('(Vim%b():.*)') or err), 0)
  end
end

local ops = {}

function ops.lua(req)
  local buf = req.buffer and resolve_buf(req.buffer)
  local chunk = compile(req.code or '')
  local result
  if buf then
    result = in_buf(buf, function()
      return chunk(buf)
    end)
  else
    result = chunk()
  end
  return { result = format(result) }
end

function ops.ex(req)
  local run = function()
    return vim.api.nvim_exec2(req.command, { output = true }).output
  end
  if req.buffer then
    return { result = in_buf(resolve_buf(req.buffer), run) }
  end
  return { result = run() }
end

function ops.transform(req)
  local buf = vim.api.nvim_create_buf(false, true)
  local ok, res = pcall(function()
    local lines, trailing = split_text(req.text or '')
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    local result = in_buf(buf, function()
      if req.filetype and req.filetype ~= '' then
        -- noautocmd keeps LSP clients and heavy plugins out of the scratch buffer.
        run_ex((req.autocmds and '' or 'noautocmd ') .. 'setlocal filetype=' .. req.filetype)
      end
      for i, cmd in ipairs(req.commands or {}) do
        run_ex(cmd, string.format('commands[%d] %q failed: ', i, cmd))
      end
      if req.code and req.code ~= '' then
        return compile(req.code)(buf)
      end
    end)
    local out = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), '\n')
    if trailing then
      out = out .. '\n'
    end
    return { result = format(result), buffer = out }
  end)
  if vim.api.nvim_buf_is_valid(buf) then
    vim.api.nvim_buf_delete(buf, { force = true })
  end
  if not ok then
    error(res, 0)
  end
  return res
end

function ops.buffers()
  local rows = {}
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[b].buflisted then
      rows[#rows + 1] = string.format(
        '%d\t%s\t%s\t%d lines%s',
        b,
        vim.api.nvim_buf_get_name(b),
        vim.bo[b].filetype,
        vim.api.nvim_buf_line_count(b),
        vim.bo[b].modified and '\tmodified' or ''
      )
    end
  end
  return { result = table.concat(rows, '\n') }
end

function ops.read(req)
  local buf = resolve_buf(req.buffer)
  local total = vim.api.nvim_buf_line_count(buf)
  local s = math.max(1, req.start_line or 1)
  local e = math.min(total, req.end_line or total)
  local lines = vim.api.nvim_buf_get_lines(buf, s - 1, e, false)
  for i, l in ipairs(lines) do
    lines[i] = (s + i - 1) .. ': ' .. l
  end
  local cursor = '?'
  for _, w in ipairs(vim.fn.win_findbuf(buf)) do
    cursor = tostring(vim.api.nvim_win_get_cursor(w)[1])
    break
  end
  return {
    result = string.format(
      '[%d %s: lines %d-%d of %d, cursor at line %s, filetype %s]\n%s',
      buf,
      vim.api.nvim_buf_get_name(buf),
      s,
      e,
      total,
      cursor,
      vim.bo[buf].filetype,
      table.concat(lines, '\n')
    ),
  }
end

function ops.complete(req)
  local items = vim.fn.getcompletion(req.pattern or '', req.kind or 'command')
  local limit = req.limit or 200
  local extra = #items - limit
  items = vim.list_slice(items, 1, limit)
  local out = table.concat(items, '\n')
  if extra > 0 then
    out = out .. string.format('\n... %d more; narrow the pattern', extra)
  end
  return { result = out }
end

-- Reads help straight from doc/tags so no window ever opens in the user's UI.
function ops.help(req)
  local topic = req.topic
  for _, tagfile in ipairs(vim.api.nvim_get_runtime_file('doc/tags', true)) do
    for line in io.lines(tagfile) do
      local tag, file = line:match('^([^\t]+)\t([^\t]+)\t')
      if tag == topic then
        local path = vim.fs.joinpath(vim.fs.dirname(tagfile), file)
        local doc = vim.split(slurp(path), '\n', { plain = true })
        local needle = '*' .. topic .. '*'
        for i, l in ipairs(doc) do
          if l:find(needle, 1, true) then
            local last = math.min(#doc, i + (req.lines or 80) - 1)
            return {
              result = string.format('[%s:%d]\n', path, i)
                .. table.concat(vim.list_slice(doc, i, last), '\n'),
            }
          end
        end
      end
    end
  end
  local near = vim.list_slice(vim.fn.getcompletion(topic, 'help'), 1, 30)
  error('No help tag ' .. topic .. (#near > 0 and ('. Close matches: ' .. table.concat(near, ', ')) or ''), 0)
end

return function(request_file, response_file)
  local req = vim.json.decode(slurp(request_file))
  local printed = {}
  local orig_print = _G.print
  _G.print = function(...)
    local parts = {}
    for i = 1, select('#', ...) do
      parts[i] = tostring((select(i, ...)))
    end
    printed[#printed + 1] = table.concat(parts, '\t')
  end
  local ok, res = xpcall(function()
    local op = ops[req.op]
    if not op then
      error('Unknown op ' .. tostring(req.op), 0)
    end
    return op(req)
  end, function(err)
    -- Keep only the agent's own frames; runtime plumbing is noise to the caller.
    local frames = {}
    for l in debug.traceback('', 2):gmatch('[^\n]+') do
      if l:find('^%s') and not (l:find('editor%-mcp%.lua') or l:find('^%s*%[C%]') or l:find('luaeval()', 1, true)) then
        frames[#frames + 1] = l
      end
    end
    local msg = tostring(err):gsub('^[^\n]-editor%-mcp%.lua:%d+: ', '')
    if #frames > 0 then
      msg = msg .. '\nstack traceback:\n' .. table.concat(frames, '\n')
    end
    return msg
  end)
  _G.print = orig_print
  if not ok then
    res = { error = tostring(res) }
  end
  if #printed > 0 then
    res.output = table.concat(printed, '\n')
  end
  local f = assert(io.open(response_file, 'wb'))
  f:write(vim.json.encode(res))
  f:close()
  return 0
end
