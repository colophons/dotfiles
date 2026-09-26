return {
  "folke/which-key.nvim"
  -- , event = "VeryLazy" -- for things that can be loaded later, not UI essential
  , opts = {
    -- ...
  }
  , keys = {
      { "<leader>fm"
        , function() require("which-key").show({ global = false }) end
        , desc = "Buffer-Local Keymaps"
    }
  }
}
