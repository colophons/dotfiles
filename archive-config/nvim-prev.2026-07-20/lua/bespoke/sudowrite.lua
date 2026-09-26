local M = {}

local uv = vim.loop
local fn = vim.fn
local api = vim.api

local function password()
  fn.inputsave()
  local user = fn.expand("$USER")
  local pw = fn.inputsecret(string.format("password for %s: ", user))
  fn.inputrestore()
  return pw
end

local function testPassword(pw, k)
  local stdin = uv.new_pipe()
  -- -S, --stdin
  --  write to stderr, read from stdin (instead of usihng terminal IO)
  -- -k, --reset-timestamp
  --  ignore cached credentials
  uv.spawn("sudo", {
    args = {"-S", "-k", "true"},
    stdio = {stdin, nil, nil}
  }, k)
  stdin:write(pw)
  stdin:write("\n")
  stdin:shutdown()
end

local function write(pw, bufname, lines, k)
  local stdin = uv.new_pipe()
  uv.spawn("sudo", {
    args = {"-S", "-k", "tee", bufname},
    stdio = {stdin, nil, nil}
  }, k)

  stdin:write(pw)
  stdin:write("\n")

  -- When called without a position, it removes the last element of the array.
  local last = table.remove(lines)

  for _, line in ipairs(lines) do
    stdin:write(line)
    stdin:write("\n")
  end
  stdin:write(last)
  stdin:shutdown()
end

function M.sudowrite()
  local pw = password()
  -- `0` for current buffer
  local bufname = api.nvim_buf_get_name(0)
  local lines = api.nvim_buf_get_lines(0, 0, -1, false)
  -- fires off after writing successfully
  local function exitWrite(code, _)
    if code == 0 then
      vim.schedule(function()
        api.nvim_echo({{string.format('"%s" written', bufname), "Normal"}}, true, {})
        api.nvim_set_option_value("modified", false, {buf = 0})
        -- api.nvim_buf_set_option(0, "modified", false)
      end)
    end
  end
  local function exitTest(code, _)
    if code == 0 then
      write(pw, bufname, lines, exitWrite)
    else
      vim.schedule(function()
        api.nvim_echo({{"incorrect password", "ErrorMsg"}}, true, {})
      end)
    end
  end
  testPassword(pw, exitTest)
end

return M
