return {
  "nvim-telescope/telescope.nvim",
  version = "*",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
  },
  keys = {
    {
      "<leader>ff",
      function()
        require("telescope.builtin").find_files({ hidden = true })
      end,
      desc = "Find files",
    },
    {
      "<leader>fg",
      function()
        require("telescope.builtin").live_grep()
      end,
      desc = "Live grep",
    },
    {
      "<leader>f<space>",
      function()
        require("telescope.builtin").live_grep()
      end,
      desc = "Live grep",
    },
    {
      "<leader>f*",
      function()
        require("telescope.builtin").grep_string()
      end,
      desc = "Grep word",
    },
    {
      "<leader>fb",
      function()
        require("telescope.builtin").buffers({ sort_mru = true, ignore_current_buffer = true })
      end,
      desc = "Buffers",
    },
    {
      "<leader>fr",
      function()
        require("telescope.builtin").oldfiles({ only_cwd = true })
      end,
      desc = "Recent files",
    },
    {
      "<leader>f/",
      function()
        require("telescope.builtin").current_buffer_fuzzy_find()
      end,
      desc = "Search current buffer",
    },
    {
      "<leader>fa",
      function()
        require("telescope.builtin").marks()
      end,
      desc = "Marks",
    },
    {
      "<leader>fj",
      function()
        require("telescope.builtin").jumplist()
      end,
      desc = "Jumplist",
    },
    {
      "<leader>fh",
      function()
        require("telescope.builtin").help_tags()
      end,
      desc = "Help",
    },
    {
      "<leader>fk",
      function()
        require("telescope.builtin").keymaps()
      end,
      desc = "Keymaps",
    },
    {
      "<leader>fl",
      function()
        require("telescope.builtin").resume()
      end,
      desc = "Resume last picker",
    },
  },
  opts = {
    defaults = {
      dynamic_preview_title = true,
      layout_config = {
        horizontal = {
          preview_width = 0.55,
        },
        width = 0.9,
        height = 0.85,
      },
      layout_strategy = "horizontal",
      path_display = { "smart" },
      prompt_prefix = "find> ",
      selection_caret = "> ",
      sorting_strategy = "ascending",
      winblend = 0,
    },
  },
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    pcall(telescope.load_extension, "fzf")
  end,
}
