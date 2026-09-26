local M = {}

M.data = {
  left = "%<%f %h%w%m%r",
  right = "%-14.(%l,%c%V%) %P",
  callbacks = {}, -- callbacks which evaluate to strings. Appends to right-side.
  timer = nil,
  computed = nil
}

M.eval = function()
  local result = ""
  for _, v in ipairs(M.data.callbacks) do
    result = result .. " " .. v()
  end
  return result
end

M.configure = function()
  M.data.computed = table.concat({
    M.data.left,
    "%=",
    "%{%v:lua.statusline.eval()%} :: ",
    M.data.right
  },'')
  M.data.timer = vim.uv.new_timer()
  M.data.timer:start(1000, 0, function()
    vim.schedule(function() vim.cmd("redrawstatus") end)
  end)
  M.data.timer:set_repeat(1000)
  vim.o.statusline = M.data.computed
end

M.add_callback = function(cb)
  table.insert(M.data.callbacks, cb)
end

return M
