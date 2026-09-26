local function toggle_menu()
  local harpoon = require("harpoon")
  harpoon.ui:toggle_quick_menu(harpoon:list())
end

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    -- Harpoon 2 uses method calls; lazy's default setup(opts) isn't sufficient.
    require("harpoon"):setup()
  end,
  keys = {
    {
      "M",
      function()
        require("harpoon"):list():add()
        vim.notify("Marked file", vim.log.levels.INFO, { title = "Harpoon" })
      end,
      desc = "Harpoon: mark file",
    },
    {
      "<Tab>",
      toggle_menu,
      desc = "Harpoon: quick menu",
    },
    {
      "<leader>m",
      toggle_menu,
      desc = "Harpoon: quick menu",
    },
  },
}
