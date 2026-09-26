-- Welcome to your magic kit!
-- This is the first file Neovim will load.
-- We'll ensure we have a plugin manager and Aniseed.
-- This will allow us to load more Fennel based code and download more plugins.

-- Make some modules easier to access.
local execute = vim.api.nvim_command
local fn = vim.fn
local fmt = string.format

-- Work out where our plugins will be stored.
local pack_path = fn.stdpath("data") .. "/site/pack"

function ensure (user, repo)
  -- Ensures a given github.com/USER/REPO is cloned in the pack/packer/start directory.
  local install_path = fmt("%s/packer/start/%s", pack_path, repo, repo)
  if fn.empty(fn.glob(install_path)) > 0 then
    execute(fmt("!git clone https://github.com/%s/%s %s", user, repo, install_path))
    execute(fmt("packadd %s", repo))
  end
end

-- Packer is our plugin manager.
ensure("wbthomason", "packer.nvim")
ensure("rktjmp", "hotpot.nvim")

require("hotpot").setup({
  provide_require_fennel = true,
  compiler = {
    modules = {
      correlate = true
    }
  },
  macros = {
    env = "_COMPILER"
  }
})

require("rosinit")
