local M = {
  "mfussenegger/nvim-dap",
  dependencies = {
    --"theHamsta/nvim-dap-virtual-text",
    "rcarriga/nvim-dap-ui",
    --"Pocco81/DAPInstall.nvim",
  },
}

function M.config()
  -- local dap = require "dap" -- this doesn't actually exist lol
  -- dap.setup()

  local dapui = require "dapui"
  dapui.setup()

  -- TODO set up keybindings

end

return M
-- Configuration

-- nvim-dap-ui is built on the idea of "elements". These elements are windows which provide different features.

-- Elements are grouped into layouts which can be placed on any side of the screen. There can be any number of layouts, containing whichever elements desired.

-- Elements can also be displayed temporarily in a floating window.

-- Each element has a set of mappings for element-specific possible actions, detailed below for each element. The total set of actions/mappings and their default shortcuts are:

--     edit: e
--     expand: <CR> or left click
--     open: o
--     remove: d
--     repl: r
--     toggle: t

-- See :h dapui.setup() for configuration options and defaults.
