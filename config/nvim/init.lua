-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Small, native-LSP setup for Neovim 0.12+. See README.md for usage.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.completeopt = { "menu", "menuone", "noselect", "popup" }
vim.opt.winborder = "rounded"

require("config.lsp")
require("config.mappings").setup()

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    { import = "plugins" }, -- Small, independent specs live in lua/plugins/.
    {
      "phha/zenburn.nvim",
      lazy = true, -- Still available via :colorscheme zenburn or Telescope.
    },
    {
      "srcery-colors/srcery-vim",
      lazy = false,
      priority = 1000,
      config = function()
        vim.cmd.colorscheme("srcery")
      end,
    },
  },
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "srcery", "zenburn" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
