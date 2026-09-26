local M = {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "AndreM222/copilot-lualine",
  },
}

local function pomodoro()
  local ok, pomo = pcall(require, "pomo")
    if not ok then
      return ""
    end

    local timer = pomo.get_first_to_finish()
    if timer == nil then
      return ""
    end

    return "󰄉 " .. tostring(timer)
end

local function project_path()
  return vim.fn.expand('%:h')
end

function M.config()
  require("lualine").setup {
    options = {
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      ignore_focus = { "NvimTree" },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_c = { { "filename", file_status=true, path = 1 } },
      -- lualine_c = { project_path },
      lualine_x = { pomodoro, "copilot", "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
    extensions = { "quickfix", "man", "fugitive" },
  }
end

return M

--- 
--- Available components
--- 
---     branch (git branch)
---     buffers (shows currently available buffers)
---     diagnostics (diagnostics count from your preferred source)
---     diff (git diff status)
---     encoding (file encoding)
---     fileformat (file format)
---     filename
---     filesize
---     filetype
---     hostname
---     location (location in file in line:column format)
---     mode (vim mode)
---     progress (%progress in file)
---     searchcount (number of search matches when hlsearch is active)
---     selectioncount (number of selected characters or lines)
---     tabs (shows currently available tabs)
---     windows (shows currently available windows)

