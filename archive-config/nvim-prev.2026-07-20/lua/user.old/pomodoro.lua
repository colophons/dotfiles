local M = {
  "epwalsh/pomo.nvim",
  -- event = "VimEnter",
  dependencies = {
    {
      "rcarriga/nvim-notify",
    },
    {
      "nvim-lualine/lualine.nvim",
    }
  },
  version = "*",  -- Recommended, use latest release instead of latest commit
  lazy = true,
  cmd = { "TimerStart", "TimerRepeat" },
}

local DunstNotifier = {
  
}


DunstNotifier.new = function(timer, opts)
  local self = setmetatable({}, { __index = DunstNotifier })
  self.timer = timer
  self.hidden = false
  self.opts = opts -- not used
  return self
end

DunstNotifier.start = function(self)
  local notify = require("notify")
  local formatted = string.format("Starting timer #%d, %s, for %dm", self.timer.id, self.timer.name, self.timer.time_limit/60)
  -- print(string.format("Starting timer #%d, %s, for %ds", self.timer.id, self.timer.name, self.timer.time_limit))
  -- local command = string.format("notify-send 'Pomodoro' '%s'", formatted)
  -- vim.fn.jobstart(command, { detach = true })
  vim.fn.jobstart("pw-play ~/.config/sounds/DISGAEA.wav", { detach = true })
  notify(formatted)

end

DunstNotifier.tick = function(self, time_left)
  -- if not self.hidden then
  --   print(string.format("Timer #%d, %s, %ds remaining...", self.timer.id, self.timer.name, time_left))
  -- end
end

DunstNotifier.done = function(self)
  -- print(string.format("Timer #%d, %s, complete", self.timer.id, self.timer.name))
  local notify = require("notify")
  local formatted = string.format("Timer #%d, %s, complete", self.timer.id, self.timer.name)
  local command = string.format("notify-send 'Pomodoro' '%s'", formatted)
  vim.fn.jobstart(command, { detach = true })
  vim.fn.jobstart("pw-play ~/.config/sounds/AMENECHO.wav", { detach = true })
  -- if the timer was named `Work`, then start one named `Break` and then pause it
  if self.timer.name == "Work" then
    vim.cmd("TimerStart 5m Break")
    vim.cmd("TimerPause")
  else
    vim.cmd("TimerStart 25m Work")
    vim.cmd("TimerPause")
  end
  notify(formatted)
end

DunstNotifier.stop = function(self) end

DunstNotifier.show = function(self)
  self.hidden = false
end

DunstNotifier.hide = function(self)
  self.hidden = true
end

local function toggle_timer()
  local pomo = require("pomo")
  local timer = pomo.get_latest()
  if timer then
    if timer.paused then
      vim.fn.jobstart("pw-play ~/.config/sounds/ZIP.wav", { detach = true })
      timer:resume()
    else
      vim.fn.jobstart("pw-play ~/.config/sounds/ZOOP.wav", { detach = true })
      timer:pause()
    end
  else
    vim.cmd("TimerStart 25m Work")
  end
end

M.toggle_timer = toggle_timer

M.config = function()
  local wk = require("which-key")
  wk.register({
    ["<leader>p"] = {
      name = "Pomodoro",
      w = { "<cmd>TimerStart 25m Work<cr>", "Start a [w]ork timer" },
      b = { "<cmd>TimerStart 5m Break<cr>", "Start a new [b]reak timer" },
      p = { "<cmd>TimerPause<cr>", "[P]ause the current timer" },
      r = { "<cmd>TimerResume<cr>", "[R]esume the current timer" },
      ["<space>"] = { 
        "<cmd>lua require('user.pomodoro').toggle_timer()<cr>",
        "Punch It!"
      },
      k = { "<cmd>TimerStop<cr>", "[K]ill the current timer" },
    },
  })
  require("pomo").setup({
  -- How often the notifiers are updated.
    update_interval = 1000,

    -- Configure the default notifiers to use for each timer.
    -- You can also configure different notifiers for timers given specific names, see
    -- the 'timers' field below.
    notifiers = {
      -- The "Default" notifier uses 'vim.notify' and works best when you have 'nvim-notify' installed.
      -- {
      --   name = "Default",
      --   opts = {
      --     -- With 'nvim-notify', when 'sticky = true' you'll have a live timer pop-up
      --     -- continuously displayed. If you only want a pop-up notification when the timer starts
      --     -- and finishes, set this to false.
      --     sticky = false,

      --     -- Configure the display icons:
      --     title_icon = "󱎫",
      --     text_icon = "󰄉",
      --     -- Replace the above with these if you don't have a patched font:
      --     -- title_icon = "⏳",
      --     -- text_icon = "⏱️",
      --   },
      -- },

    --  -- The "System" notifier sends a system notification when the timer is finished.
    --  -- Currently this is only available on MacOS.
    --  -- Tracking: https://github.com/epwalsh/pomo.nvim/issues/3
    --  { name = "System" },

      -- You can also define custom notifiers by providing an "init" function instead of a name.
      -- See "Defining custom notifiers" below for an example 👇
      -- { init = function(timer) ... end }
      -- use DunstNotifier
      {
        init = DunstNotifier.new, ops = {}
      },
    },

    -- Override the notifiers for specific timer names.
    timers = {
    --   -- For example, use only the "System" notifier when you create a timer called "Break",
    --   -- e.g. ':TimerStart 2m Break'.
      -- Break = {
      --   { name = "DunstNotifier" },
      -- },
      -- Work = {
      --   { name = "DunstNotifier" },
      -- },
    },
  })
end

return M
