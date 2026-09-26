local M = {
  "nvim-telescope/telescope.nvim",
  dependencies = { { "nvim-telescope/telescope-fzf-native.nvim", build = "make", lazy = true } },
}


-- ["<leader>ff"] = { "<cmd>Telescope find_files hidden=true<cr>" },
-- ["<leader>f-"] = { "<cmd>Telescope file_browser<cr>" },
-- ["<leader>fg"] = { "<cmd>Telescope live_grep<cr>" },
-- ["<leader>fb"] = { "<cmd>Telescope buffers<cr>" },
-- ["<leader>*"] = { "<cmd>Telescope grep_string<cr>" },
-- ["<leader>fH"] = { "<cmd>Telescope help_tags<cr>" },
-- ["<leader>fm"] = { "<cmd>Telescope keymaps<cr>" },
-- ["<leader>fM"] = { "<cmd>Telescope marks<cr>" },
-- ["<leader>fh"] = { "<cmd>Telescope oldfiles<cr>" },
-- ["<leader>ft"] = { "<cmd>Telescope filetypes<cr>" },
-- ["<leader>fc"] = { "<cmd>Telescope commands<cr>" },
-- ["<leader>fC"] = { "<cmd>Telescope command_history<cr>" },
-- ["<leader>fq"] = { "<cmd>Telescope quickfix<cr>" },
-- ["<leader>fl"] = { "<cmd>Telescope loclist<cr>" },

function M.config()
  local wk = require "which-key"
  wk.register {
    ["<leader>fb"] = { "<cmd>Telescope buffers<cr>", "Find" },
    ["<leader>f-"] = { "<cmd>Telescope file_browser<cr>", "File Browser" },
    ["<leader>fc"] = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
    ["<leader>ff"] = { "<cmd>Telescope find_files hidden=true<cr>", "Find files" },
    ["<leader>fp"] = { "<cmd>lua require('telescope').extensions.projects.projects()<cr>", "Projects" },
    -- ["<leader>ft"] = { "<cmd>Telescope live_grep<cr>", "Find Text" },
    ["<leader>f<space>"] = { "<cmd>Telescope live_grep<cr>", "Rip Grep" },
    ["<leader>fg"] = { "<cmd>Telescope grep_string<cr>", "Grep String" },
    ["<leader>fh"] = { "<cmd>Telescope help_tags<cr>", "Help" },
    ["<leader>fl"] = { "<cmd>Telescope resume<cr>", "Last Search" },
    ["<leader>fm"] = { "<cmd>Telescope keymaps<cr>", "Keymaps"},
    ["<leader>fr"] = { "<cmd>Telescope oldfiles<cr>", "Recent File" },
    ["<leader>fa"] = { "<cmd>Telescope attempt<cr>", "Attempts" },
    -- ["<leader>fgb"] = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
    -- ["<leader>fsa"] = { "<cmd>Telescope lsp_code_actions<cr>", "Code Actions"},
    ["<leader>fsq"] = { "<cmd>Telescope quickfix theme=ivy<cr>", "Quickfix" },
    ["gI"] = { "<cmd>Telescope lsp_implementations<cr>", "LSP Find Implementation" },
    ["gr"] = { "<cmd>Telescope lsp_references theme=ivy<cr>", "[G]et [R]eferences"},
    ["gd"] = { "<cmd>lua vim.lsp.buf.definition()<cr>", "[G]o [D]efinition" },
    ["gD"] = { "<cmd>Telescope lsp_declarations<cr>", "[G]et [D]eclarations"},
    ["<leader>lD"] = { "<cmd> Telescope diagnostics<cr> theme=ivy", "[L]SP [D]iagnostics"},
    ["<leader>lq"] = { "<cmd>Telescope quickfix theme=ivy<cr>", "Quickfix" },
    ["<leader>lds"] = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
    ["<leader>lws"] = { "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace Symbols" },
  }

  local icons = require "user.icons"
  local actions = require "telescope.actions"


  require("telescope").setup {
    defaults = {
      prompt_prefix = icons.ui.Telescope .. " ",
      selection_caret = icons.ui.Forward .. " ",
      entry_prefix = "   ",
      initial_mode = "insert",
      selection_strategy = "reset",
      path_display = { "smart" },
      color_devicons = true,
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",
        "--glob=!.git/",
      },

      mappings = {
        i = {
          ["<C-n>"] = actions.cycle_history_next,
          ["<C-p>"] = actions.cycle_history_prev,

          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
        },
        n = {
          ["<esc>"] = actions.close,
          ["j"] = actions.move_selection_next,
          ["k"] = actions.move_selection_previous,
          ["q"] = actions.close,
        },
      },
    },
    pickers = {
      live_grep = {
        -- theme = "dropdown",
      },

      grep_string = {
        -- theme = "dropdown",
      },

      find_files = {
        -- theme = "dropdown",
        -- previewer = false,
      },

      buffers = {
        -- theme = "dropdown",
        -- previewer = false,
        initial_mode = "normal",
        mappings = {
          i = {
            ["<C-d>"] = actions.delete_buffer,
          },
          n = {
            ["dd"] = actions.delete_buffer,
          },
        },
      },

      planets = {
        show_pluto = true,
        show_moon = true,
      },

      colorscheme = {
        enable_preview = true,
      },

      lsp_references = {
        -- theme = "ivy",
        initial_mode = "normal",
      },

      lsp_definitions = {
        -- theme = "ivy",
        initial_mode = "normal",
      },

      lsp_declarations = {
        -- theme = "ivy",
        initial_mode = "normal",
      },

      lsp_implementations = {
        -- theme = "ivy",
        initial_mode = "normal",
      },
    },
    extensions = {
      fzf = {
        fuzzy = true, -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
        case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      },
      harpoon = {}
    },
  }
end

return M
