local M = {
  "folke/tokyonight.nvim"
}

function M.config()
  require("tokyonight").setup({ style = "moon" })
end

return M
