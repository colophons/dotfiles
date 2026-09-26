local M = {
  "ggandor/leap.nvim"
}

M.config = function()
  -- need to unmap 'S'
  -- vim.cmd('unmap S')
  require('leap').create_default_mappings()
end

return M

-- Below is a list of all configurable values in the opts table, with their defaults. Set them like: require('leap').opts.<key> = <value>. For details on the particular fields, see :h leap-config.
-- 
-- case_sensitive = false
-- equivalence_classes = { ' \t\r\n', }
-- max_phase_one_targets = nil
-- highlight_unlabeled_phase_one_targets = false
-- max_highlighted_traversal_targets = 10
-- substitute_chars = {}
-- safe_labels = 'sfnut/SFNLHMUGTZ?'
-- labels = 'sfnjklhodweimbuyvrgtaqpcxz/SFNJKLHODWEIMBUYVRGTAQPCXZ?'
-- special_keys = {
--   next_target = '<enter>',
--   prev_target = '<tab>',
--   next_group = '<space>',
--   prev_group = '<tab>',
-- }

-- Installation
-- 
-- Use your preferred method or plugin manager. No extra steps needed besides defining keybindings - to use the default ones, put the following into your config (overrides s, S, and gs in all modes):
-- 
-- require('leap').create_default_mappings() (init.lua)
-- 
-- lua require('leap').create_default_mappings() (init.vim)
-- 
-- To set custom mappings instead, see :h leap-custom-mappings.
-- Workaround for the duplicate cursor bug when autojumping
-- 
-- Until neovim/neovim#20793 is fixed:
-- 
-- -- Hide the (real) cursor when leaping, and restore it afterwards.
-- vim.api.nvim_create_autocmd('User', { pattern = 'LeapEnter',
--     callback = function()
--       vim.cmd.hi('Cursor', 'blend=100')
--       vim.opt.guicursor:append { 'a:Cursor/lCursor' }
--     end,
--   }
-- )
-- vim.api.nvim_create_autocmd('User', { pattern = 'LeapLeave',
--     callback = function()
--       vim.cmd.hi('Cursor', 'blend=0')
--       vim.opt.guicursor:remove { 'a:Cursor/lCursor' }
--     end,
--   }
-- )
-- 
-- Caveat: If you experience any problems after using the above snippet, check #70 and #143 to tweak it.
-- Lazy loading
-- 
-- ...is all the rage now, but doing it manually or via some plugin manager is completely redundant, as Leap takes care of it itself. Nothing unnecessary is loaded until you actually trigger a motion.
