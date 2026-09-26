local M = {}

local STOPPED = 0
local RUNNING = 1

M.data = {
  notifier = "notify-send",
  status = STOPPED,
  seconds_left = 0,
  timer = nil,
  timer_type = "MAIN" -- or "BREAK"
}

M.finish = function()
  M.notify("timer finished")
  M.data.status = STOPPED
  M.data.seconds_left = 0
  M.data.timer:stop()
  vim.system({"aplay", os.getenv("HOME") .. "/dotfiles/stowage/break01.wav"})
end

M.start = function(seconds)
  if M.data.status == RUNNING then
    vim.notify("timer already running")
  else
    vim.system({"aplay", os.getenv("HOME") .. "/dotfiles/stowage/effect01.wav"})
    M.data.status = RUNNING
    M.data.seconds_left = seconds
    M.data.timer = vim.uv.new_timer()
    M.notify("timer started")
    M.data.timer:start(1000, 0, function()
      if M.data.seconds_left < 0 then
        M.finish()
      elseif M.data.status == RUNNING then
        M.data.seconds_left = M.data.seconds_left - 1
      end
    end)
    M.data.timer:set_repeat(1000)
  end
end

M.notify = function(msg)
  vim.system({M.data.notifier, msg})
  -- vim.system({"aplay", os.getenv("HOME") .. "/dotfiles/stowage/break01.wav"})
  -- vim.system({"aplay", os.getenv("HOME") .. "/dotfiles/stowage/effect01.wav"})
end

M.pause = function()
  M.data.status = STOPPED
  M.notify("timer paused")
end

M.string = function() 
  local sec = M.data.seconds_left
  local stat = ""
  if M.data.status == RUNNING then
    stat = "running: "
  else
    stat = "stopped: "
  end
  return stat .. string.format("%02.0f:%02.0f", sec / 60, sec % 60)
end

M.toggle = function()
  if M.data.status == RUNNING then
    M.data.status = STOPPED
  else
    M.start(25 * 60)
  end
end

M.configure = function()
  local statusline = helpers.want("bespoke.statusline")
  if statusline then
    vim.notify("registering statusline callback")
    statusline.add_callback(M.string)
  end

  local wk = helpers.want("which-key") 
  if wk then
    wk.add({
      {"<leader>p", group = "pomo" },
      {"<leader>ps", function() M.start(25 * 60) end, desc = "start main timer"},
      {"<leader>pb", function() M.start(5 * 60) end, desc = "start break timer"},
      {"<leader>pt", function() M.pause() end, desc = "pause timer"},
      {"<leader>pk", function() M.finish() end, desc = "kill timer"},
    })
  end
end

return M
