return {
  "nvim-telescope/telescope.nvim",
  version = "*",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  keys = {
    { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
    { "<leader>fc", "<cmd>Telescope colorscheme<CR>", desc = "Colorscheme" },
    { "<leader>ff", function() require("config.search").files() end, desc = "Find files from file directory" },
    { "<leader>f<Space>", function() require("config.search").grep() end, desc = "Ripgrep from file directory" },
    { "<leader>fg", "<cmd>Telescope grep_string<CR>", desc = "Grep word under cursor" },
    { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help" },
    { "<leader>fl", "<cmd>Telescope resume<CR>", desc = "Last search" },
    { "<leader>fm", "<cmd>Telescope keymaps<CR>", desc = "Keymaps" },
    { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
    { "<leader>fsq", "<cmd>Telescope quickfix theme=ivy<CR>", desc = "Quickfix" },
    { "<leader>lD", "<cmd>Telescope diagnostics theme=ivy<CR>", desc = "Workspace diagnostics" },
    { "<leader>lq", "<cmd>Telescope quickfix theme=ivy<CR>", desc = "Quickfix" },
    { "<leader>lds", "<cmd>Telescope lsp_document_symbols<CR>", desc = "Document symbols" },
    { "<leader>lws", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", desc = "Workspace symbols" },
  },
  opts = {
    defaults = {
      path_display = { "smart" },
      -- Your old picker controls, expressed as action names.
      mappings = {
        i = {
          ["<C-n>"] = "cycle_history_next",
          ["<C-p>"] = "cycle_history_prev",
          ["<C-j>"] = "move_selection_next",
          ["<C-k>"] = "move_selection_previous",
        },
        n = { ["<Esc>"] = "close", q = "close" },
      },
      -- Search dotfiles, but not Git internals. Keep respecting ignore files.
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",
        "--glob=!.git",
      },
    },
    pickers = {
      buffers = {
        initial_mode = "normal",
        mappings = { i = { ["<C-d>"] = "delete_buffer" }, n = { dd = "delete_buffer" } },
      },
      colorscheme = { enable_preview = true },
      lsp_references = { initial_mode = "normal", theme = "ivy" },
      lsp_implementations = { initial_mode = "normal" },
      find_files = {
        hidden = true,
        find_command = function()
          for _, fd in ipairs({ "fd", "fdfind" }) do
            if vim.fn.executable(fd) == 1 then
              return { fd, "--type", "f", "--color", "never", "--exclude", ".git" }
            end
          end
          return { "rg", "--files", "--glob=!.git" }
        end,
      },
    },
  },
  config = function(_, opts)
    require("telescope").setup(opts)
    require("telescope").load_extension("fzf")
  end,
  -- Projects and Attempts intentionally not restored.
  -- File browsing uses netrw + vinegar, avoiding another Telescope extension.
}
