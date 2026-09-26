local M = {
  "nvim-tree/nvim-tree.lua",
  event = "VeryLazy",
}

function M.config()
  local wk = require "which-key"
  wk.register {
    ["<leader>e"] = { "<cmd>NvimTreeToggle<CR>", "Explorer" },
  }

  local icons = require "user.icons"

  require("nvim-tree").setup {
    hijack_netrw = false,
    sync_root_with_cwd = true,
    view = {
      relativenumber = true,
    },
    renderer = {
      add_trailing = false,
      group_empty = false,
      highlight_git = false,
      full_name = false,
      highlight_opened_files = "none",
      root_folder_label = ":t",
      indent_width = 2,
      indent_markers = {
        enable = false,
        inline_arrows = true,
        icons = {
          corner = "└",
          edge = "│",
          item = "│",
          none = " ",
        },
      },
      icons = {
        git_placement = "before",
        padding = " ",
        symlink_arrow = " ➛ ",
        glyphs = {
          default = icons.ui.Text,
          symlink = icons.ui.FileSymlink,
          bookmark = icons.ui.BookMark,
          folder = {
            arrow_closed = icons.ui.ChevronRight,
            arrow_open = icons.ui.ChevronShortDown,
            default = icons.ui.Folder,
            open = icons.ui.FolderOpen,
            empty = icons.ui.EmptyFolder,
            empty_open = icons.ui.EmptyFolderOpen,
            symlink = icons.ui.FolderSymlink,
            symlink_open = icons.ui.FolderOpen,
          },
          git = {
            unstaged = icons.git.FileUnstaged,
            staged = icons.git.FileStaged,
            unmerged = icons.git.FileUnmerged,
            renamed = icons.git.FileRenamed,
            untracked = icons.git.FileUntracked,
            deleted = icons.git.FileDeleted,
            ignored = icons.git.FileIgnored,
          },
        },
      },
      special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
      symlink_destination = true,
    },
    update_focused_file = {
      enable = true,
      debounce_delay = 15,
      update_root = true,
      ignore_list = {},
    },

    diagnostics = {
      enable = true,
      show_on_dirs = false,
      show_on_open_dirs = true,
      debounce_delay = 50,
      severity = {
        min = vim.diagnostic.severity.HINT,
        max = vim.diagnostic.severity.ERROR,
      },
      icons = {
        hint = icons.diagnostics.BoldHint,
        info = icons.diagnostics.BoldInformation,
        warning = icons.diagnostics.BoldWarning,
        error = icons.diagnostics.BoldError,
      },
    },
  }
end

return M
--   log_level = 'info',
--   auto_session_enable_last_session = false,
--   auto_session_root_dir = vim.fn.stdpath('data').."/sessions/",
--   auto_session_enabled = true,
--   auto_save_enabled = nil,
--   auto_restore_enabled = nil,
--   auto_session_suppress_dirs = nil,
--   auto_session_use_git_branch = nil,
--   -- the configs below are lua only
--   bypass_session_save_file_types = nil

-- :SessionSave " saves or creates a session in the currently set `auto_session_root_dir`.
-- :SessionSave ~/my/custom/path " saves or creates a session in the specified directory path.
-- :SessionRestore " restores a previously saved session based on the `cwd`.
-- :SessionRestore ~/my/custom/path " restores a previously saved session based on the provided path.
-- :SessionRestoreFromFile ~/session/path " restores any currently saved session
-- :SessionDelete " deletes a session in the currently set `auto_session_root_dir`.
-- :SessionDelete ~/my/custom/path " deleetes a session based on the provided path.
-- :SessionPurgeOrphaned " removes all orphaned sessions with no working directory left.
-- :Autosession search
-- :Autosession delete
