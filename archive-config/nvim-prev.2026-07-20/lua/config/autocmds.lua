local group = vim.api.nvim_create_augroup("rosin_core", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  desc = "Briefly highlight yanked text",
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 150 })
  end,
})

vim.api.nvim_create_autocmd("VimResized", {
  group = group,
  desc = "Rebalance windows after a terminal resize",
  command = "tabdo wincmd =",
})

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "TermClose" }, {
  group = group,
  desc = "Notice files changed by tools and agents",
  command = "checktime",
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = group,
  desc = "Return to the last position in a file",
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)

    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = group,
  desc = "Do not continue comments with o or O",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  group = group,
  desc = "Treat terminal buffers like terminals",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.cmd.startinsert()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "gitcommit", "markdown", "org" },
  desc = "Use prose-friendly display settings",
  callback = function()
    vim.opt_local.linebreak = true
    vim.opt_local.spell = true
    vim.opt_local.wrap = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "checkhealth", "help", "lspinfo", "man", "netrw", "qf" },
  desc = "Close utility windows with q",
  callback = function(args)
    vim.bo[args.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", {
      buffer = args.buf,
      silent = true,
      desc = "Close window",
    })
  end,
})
