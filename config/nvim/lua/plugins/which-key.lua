return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "classic",
    win = { border = "rounded", padding = { 2, 2 } },
    show_help = false,
    show_keys = false,
    icons = { mappings = false }, -- No icon plugin or Nerd Font required.
    disable = { ft = { "TelescopePrompt" } },
    plugins = {
      marks = true,
      registers = true,
      spelling = { enabled = true, suggestions = 20 },
      presets = {
        operators = false,
        motions = false,
        text_objects = false,
        windows = false,
        nav = false,
        z = false,
        g = false,
      },
    },
    -- v3 spec replaces the old register()/name format.
    -- Descriptions for real mappings are picked up automatically.
    spec = {
      { "<leader>f", group = "Find" },
      { "<leader>fs", group = "Lists" },
      { "<leader>g", group = "Git" },
      { "<leader>h", group = "Help" },
      { "<leader>l", group = "LSP", mode = { "n", "x" } },
      { "<leader>ld", group = "Document" },
      { "<leader>lw", group = "Workspace" },
      { "<leader>p", group = "Plugins" },
    },
  },
  keys = {
    { "<leader>q", "<cmd>confirm q<CR>", desc = "Quit" },
    { "<leader>/", "<cmd>nohlsearch<CR>", desc = "Clear search highlight" },
    { "<leader>hh", "<cmd>Telescope help_tags<CR>", desc = "Search help" },
    { "<leader>hm", "<cmd>Mappings<CR>", desc = "All mappings" },
    { "<leader>v", "<cmd>vsplit<CR>", desc = "Vertical split" },
    { "<leader>f-", "<cmd>Explore<CR>", desc = "File browser (netrw)" },
    { "<leader>pl", "<cmd>Lazy<CR>", desc = "Lazy plugins" },
    { "<leader>pm", "<cmd>Mason<CR>", desc = "Mason tools" },
  },
}
