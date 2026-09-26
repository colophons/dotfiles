local M = {
  "rmagatti/auto-session",
}



function M.config()
  require("auto-session").setup {
    log_level = "error",

    cwd_change_handling = {
      restore_upcoming_session = true, -- already the default, no need to specify like this, only here as an example
      pre_cwd_changed_hook = nil, -- already the default, no need to specify like this, only here as an example
      auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
      post_cwd_changed_hook = function() -- example refreshing the lualine status line _after_ the cwd changes
        require("lualine").refresh() -- refresh lualine so the new session name is displayed in the status bar
      end,
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
