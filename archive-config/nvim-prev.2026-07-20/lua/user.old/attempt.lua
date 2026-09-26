local M = {
    'm-demare/attempt.nvim', -- No need to specify plenary as dependency
}

function M.config()
    local attempt = require('attempt')
    attempt.setup
    {
    -- dir = (unix and '/tmp/' or vim.fn.expand '$TEMP\\') .. 'attempt.nvim' .. path_separator,
    -- autosave = false,
    -- list_buffers = false,     -- This will make them show on other pickers (like :Telescope buffers)
    -- initial_content = {
    --   py = initial_content_fn, -- Either string or function that returns the initial content
    --   c = initial_content_fn,
    --   cpp = initial_content_fn,
    --   java = initial_content_fn,
    --   rs = initial_content_fn,
    --   go = initial_content_fn,
    --   sh = initial_content_fn
    -- },
    ext_options = { 'lua', 'js', 'py', 'cpp', 'c', '', 'json', 'sh' },  -- Options to choose from
    -- format_opts = { [''] = '[None]' },                    -- How they'll look
    -- run = {
    --   py = { 'w !python' },      -- Either table of strings or lua functions
    --   js = { 'w !node' },
    --   ts = { 'w !deno run -' },
    --   lua = { 'w' , 'luafile %' },
    --   sh = { 'w !sh' },
    --   pl = { 'w !perl' },
    --   cpp = { 'w' , '!'.. cpp_compiler ..' %:p -o %:p:r.out && echo "" && %:p:r.out && rm %:p:r.out '},
    --   c = { 'w' , '!'.. c_compiler ..' %:p -o %:p:r.out && echo "" && %:p:r.out && rm %:p:r.out'},
    -- }
  }

  -- we need to make sure to load after telescope.
  require('telescope').load_extension('attempt')

  local wk = require "which-key"
  wk.add {
    { "<leader>an", attempt.new_select, desc = "New [Select]" },
    { "<leader>ai", attempt.new_select, desc = "New [Input]" },
    { "<leader>ar", attempt.new_select, desc = "Run" },
    { "<leader>ad", attempt.new_select, desc = "Delete" },
    { "<leader>ac", attempt.new_select, desc = "Rename" },
    { "<leader>ac", attempt.new_select, desc = "Rename" },
  }
end

return M
