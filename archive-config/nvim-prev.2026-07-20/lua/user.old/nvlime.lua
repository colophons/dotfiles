local M = {
  "monkoose/nvlime",
  dependencies = {
    "monkoose/parsley"
  }
}

function M.config()
  local plugins_dir = vim.fn.stdpath("data") .. "/lazy"
  vim.fn.jobstart("sbcl --load " .. plugins_dir .. "/nvlime/lisp/start-nvlime.lisp")
  vim.g.nvlime_config = {
    cmp = { enabled = true },
    leader = "<C- >"
  }

    -- q - to close the current window (except for lisp filetypes).
    -- <leader>ww - closes all plugin windows except main windows.
    -- <Esc> - closes last opened floating window except current one.
    -- <C-n> and <C-p> to scroll last opened floating window. If this keys are messing up with your 
      -- config change them with g:nvlime_mappings directory: global.normal.scroll_up and global.normal.scroll_down.
      -- You can adjust scroll step with g:nvlime_config.floating_window.scroll_step variable. It is set to 3 lines by default.
end

return M
