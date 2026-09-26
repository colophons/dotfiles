local sudowrite = require("bespoke.sudowrite")
-- vim.keymap.set({"c"}, "w!!", function() sudowrite.sudowrite() end)
-- vim.keymap.set({"c"}, "w!!", function() sudowrite.sudowrite() end)
vim.api.nvim_create_user_command('SudoWrite', function(_) sudowrite.sudowrite() end, {})
