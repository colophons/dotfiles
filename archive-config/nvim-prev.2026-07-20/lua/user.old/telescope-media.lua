local M = {
  "dharmx/telescope-media.nvim",
  config = function()
    require("telescope").load_extension("media")
  end,
}

return M
