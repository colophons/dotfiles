local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local lazy_module = lazypath .. "/lua/lazy/init.lua"

local function setup_plugins()
  vim.opt.rtp:prepend(lazypath)

  require("lazy").setup({
    spec = {
      require("plugin.telescope"),
      require("plugin.harpoon"),
    },
    defaults = {
      lazy = true,
      version = false,
    },
    install = {
      colorscheme = { "habamax", "default" },
    },
    checker = {
      enabled = false,
    },
    change_detection = {
      notify = false,
    },
    ui = {
      border = "rounded",
    },
  })
end

if vim.uv.fs_stat(lazy_module) then
  setup_plugins()
  return
end

vim.api.nvim_create_user_command("PluginBootstrap", function()
  if vim.uv.fs_stat(lazypath) then
    vim.notify(
      "lazy.nvim is incomplete at " .. lazypath .. "; move it aside and retry",
      vim.log.levels.ERROR
    )
    return
  end

  vim.notify("Installing lazy.nvim; this may take a while on a slow connection")
  local result = vim.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  }, { text = true }):wait()

  if result.code ~= 0 or not vim.uv.fs_stat(lazy_module) then
    local detail = result.stderr or result.stdout or "clone left an incomplete checkout"
    vim.notify("Could not install lazy.nvim:\n" .. detail, vim.log.levels.ERROR)
    return
  end

  setup_plugins()
  vim.cmd("Lazy sync")
end, {
  desc = "Install the optional Neovim plugin layer",
})

vim.schedule(function()
  vim.notify("Plugin layer unavailable; run :PluginBootstrap when connected")
end)
