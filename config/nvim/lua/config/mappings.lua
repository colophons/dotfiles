local M = {}
local api = vim.api
local name = "mappings://all"
local modes = {
  { "n", "Normal" }, { "x", "Visual" }, { "s", "Select" },
  { "o", "Operator-pending" }, { "i", "Insert" },
  { "c", "Command-line" }, { "t", "Terminal" }, { "l", "Language" },
}
local buffer
local sources = {}

local function text(value)
  return vim.fn.strtrans(value or "")
end

-- Lua exposes the callback's definition, which may differ from where it was
-- bound. In particular, lazy.nvim's pending keys point to its loading wrapper.
local function source(map, scripts)
  local info = type(map.callback) == "function" and debug.getinfo(map.callback, "S") or nil
  local lazy = info and info.source:match("/lazy/core/handler/keys%.lua$")
  if scripts[map.sid] then
    return {
      path = scripts[map.sid], line = math.max(map.lnum or 1, 1),
      kind = lazy and "Lazy trigger set by" or "Set by",
    }
  end
  if info and info.source:sub(1, 1) == "@" then
    return {
      path = info.source:sub(2), line = math.max(info.linedefined, 1),
      kind = lazy and "Lazy trigger" or "Callback",
    }
  end
end

local function refresh()
  if not buffer or not api.nvim_buf_is_valid(buffer) then
    return
  end
  local lines = {
    "# All mappings",
    "",
    "gR: refresh    Enter: visit source    q: close view",
    "",
    "Registered mappings in every mode, global and local to existing buffers.",
    "Local mappings take precedence over global mappings in their buffer.",
    "LSP and plugin-window mappings appear after those contexts create them.",
    "Includes <Plug> mappings and lazy loading triggers; excludes abbreviations",
    "and intrinsic commands such as j or dw. Refreshes when revisited.",
    "Callback locations are function definitions, not necessarily binding sites.",
    "",
  }
  sources = {}
  local scripts = {}
  for _, script in ipairs(vim.fn.getscriptinfo()) do
    scripts[script.sid] = script.name
  end

  local function section(title, buf)
    local started = false
    for _, mode in ipairs(modes) do
      local maps = buf and api.nvim_buf_get_keymap(buf, mode[1]) or api.nvim_get_keymap(mode[1])
      table.sort(maps, function(a, b) return a.lhs < b.lhs end)
      if #maps > 0 then
        if not started then
          vim.list_extend(lines, { "## " .. title, "" })
          started = true
        end
        vim.list_extend(lines, { "### " .. mode[2] .. " (" .. mode[1] .. ")", "" })
        for _, map in ipairs(maps) do
          local location = source(map, scripts)
          local first = #lines + 1
          local keys = text(map.lhs):gsub(" ", "<Space>")
          lines[#lines + 1] = keys .. "  —  " .. text(map.desc or "(no description)")
          local action = map.callback and "<Lua callback>" or (map.rhs == "" and "<Nop>" or map.rhs)
          local flags = {}
          if map.expr == 1 then flags[#flags + 1] = "expr" end
          if map.noremap == 0 then flags[#flags + 1] = "remap" end
          if map.nowait == 1 then flags[#flags + 1] = "nowait" end
          lines[#lines + 1] = "  Action: " .. text(action)
            .. (#flags > 0 and " [" .. table.concat(flags, ", ") .. "]" or "")
          if location then
            lines[#lines + 1] = "  " .. location.kind .. ": "
              .. text(vim.fn.fnamemodify(location.path, ":~")) .. ":" .. location.line
            for row = first, #lines do sources[row] = location end
          else
            lines[#lines + 1] = "  Source: unavailable"
          end
          lines[#lines + 1] = ""
        end
      end
    end
  end

  section("Global")
  local buffers = api.nvim_list_bufs()
  table.sort(buffers)
  for _, buf in ipairs(buffers) do
    local label = api.nvim_buf_get_name(buf)
    section("Buffer " .. buf .. ": " .. (label == "" and "[No Name]" or text(label)), buf)
  end
  local view = api.nvim_get_current_buf() == buffer and vim.fn.winsaveview()
  vim.bo[buffer].modifiable = true
  api.nvim_buf_set_lines(buffer, 0, -1, false, lines)
  vim.bo[buffer].modifiable = false
  if view then vim.fn.winrestview(view) end
end

local function visit_source()
  local location = sources[api.nvim_win_get_cursor(0)[1]]
  if not location or vim.fn.filereadable(location.path) == 0 then
    vim.notify("No source file available for this line", vim.log.levels.INFO)
    return
  end
  vim.cmd.edit(vim.fn.fnameescape(location.path))
  api.nvim_win_set_cursor(0, { math.min(location.line, api.nvim_buf_line_count(0)), 0 })
end

function M.open()
  if not buffer or not api.nvim_buf_is_valid(buffer) then
    buffer = api.nvim_create_buf(true, true)
    api.nvim_buf_set_name(buffer, name)
    vim.bo[buffer].bufhidden = "hide"
    vim.bo[buffer].swapfile = false
    vim.bo[buffer].filetype = "markdown"
    vim.bo[buffer].modifiable = false
    vim.keymap.set("n", "gR", refresh, { buffer = buffer, desc = "Refresh all mappings" })
    vim.keymap.set("n", "<CR>", visit_source, { buffer = buffer, desc = "Visit mapping source" })
    vim.keymap.set("n", "q", function()
      if #api.nvim_tabpage_list_wins(0) == 1 then
        vim.cmd.enew()
      else
        vim.cmd.close()
      end
    end, { buffer = buffer, desc = "Close mappings view" })
    api.nvim_create_autocmd("BufEnter", { buffer = buffer, callback = refresh })
  end
  local win = vim.fn.bufwinid(buffer)
  if win ~= -1 then
    api.nvim_set_current_win(win)
  else
    vim.cmd("botright sbuffer " .. buffer)
  end
  refresh()
end

function M.setup()
  api.nvim_create_user_command("Mappings", M.open, { desc = "Show all registered mappings" })
end

return M
