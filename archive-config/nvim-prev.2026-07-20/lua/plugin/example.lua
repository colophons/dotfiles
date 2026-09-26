-- structuring your plugins: --
-- https://lazy.folke.io/usage/structuring --

-- require("lazy").setup("plugins")
-- -- Same as:
-- require("lazy").setup({{import = "plugins"}})

-- To import multiple modules from a plugin, add additional specs for each import. For example, to import LazyVim core plugins and an optional plugin:
-- 
-- require("lazy").setup({
--   spec = {
--     { "LazyVim/LazyVim", import = "lazyvim.plugins" },
--     { import = "lazyvim.plugins.extras.coding.copilot" },
--   }
-- })
-- 
-- When you import specs, you can override them by simply adding a spec for the same plugin to your local specs, adding any keys you want to override / merge.
-- 
-- opts, dependencies, cmd, event, ft and keys are always merged with the parent spec. Any other property will override the property from the parent spec.
