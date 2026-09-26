local M = {}

M.want = function(name)
  local out; if xpcall(
      function()  out = require(name) end,
      function(e) out = e end)
  then return out          -- success
  else return nil, out end -- error
end

  -- two ways to get buffer filename:
  -- vim.fn.expand('%')
  -- vim.api.nvim_buf_get_name(0) -- buffer 0 is always current buffer

M.current_buffer_dir = function()
  filename = vim.api.nvim_buf_get_name(0)
  dirname = filename:match("(.*[/\\])")
  return dirname
end

-- :lua helpers = helpers.reload("bespoke.helpers")
M.reload = function(packagename)
  package.loaded[packagename] = nil
  return require(packagename)    -- read and execute the module again from disk
end

string.split = function(str, sep)
end

-- [bufnum, lnum, col, off]
M.get_text_between = function(start_line, start_col, end_line, end_col)
-- vim.fn.getline is inclusive
  local lines = vim.fn.getline(start_line, end_line)
  if start_line == end_line then
    return lines[1]:sub(start_col, end_col)
  elseif  start_line < end_line then
    lines[1] = lines[1]:sub(start_col)
    lines[#lines] = lines[#lines]:sub(0, end_col)
    return table.concat(lines, '\n')
  end
end

M.get_selection_points = function()
  -- getpos returns the following table:
  -- [bufnum, lnum, col, off]
  local startpos = vim.fn.getpos("'<")
  local endpos = vim.fn.getpos("'>")

  -- TODO: handle not-visual mode/visual mode intelligently
  return {startpos[2], startpos[3], endpos[2], endpos[3]}
end

M.get_selection_text = function()
  local points = M.get_selection_points()
  return M.get_text_between(points[1], points[2], points[3], points[4])
end

M.call_subprocess_on_range = function(cmd, start_line, start_col, end_line, end_col)
  -- Invokes a subprocess on text given by a range
  local result_stdout = ""
  local buffer_text = M.get_text_between(start_line, start_col, end_line, end_col)
  local program = vim.system(cmd, { 
    text = true,
    stdin = true,
  }
  , function(obj) result_stdout = obj.stdout end)
  program:write(buffer_text) -- pass selection via stdin
  program:write(nil)         -- close stream
  program:wait()             -- block
  result_stripped = string.gsub(string.gsub(result_stdout, "^%s*", ""), "%s*$", "")
  return result_stripped
end

M.call_subprocess_on_selection = function(cmd)
  local start_line, start_col, end_line, end_col = unpack(M.get_selection_points())
  return M.call_subprocess_on_range(cmd, start_line, start_col, end_line, end_col)
end

M.run = function(cmd, s)
  -- invokes a subprocess.
  -- is `s` is not nil, then attempt to write it to `cmd` stdin
  local result_stdout = ""
  local opts = { text = true, stdin = s ~= nil }
  local program = vim.system(cmd, opts, function(obj) result_stdout = obj.stdout end)
  if s ~= nil then
    program:write(s)
    program:write(nil)
  end
  program:wait()
  return result_stdout
end

M.overwrite_range = function(s, start_line, start_col, end_line, end_col)
  -- overwrites the lines in a file with s
  -- handles cases where s is a multiline string
  s_lines = vim.split(s, "\n")
  if start_line == end_line and #s_lines == 1 then
    local line = vim.fn.getline(start_line)
    local tfed = line:sub(1, start_col - 1) .. s .. line:sub(math.max(end_col, end_col + 1))
    vim.fn.setline(start_line, tfed)
  elseif start_line == end_line and #s_lines >= 1 then
    local line = vim.fn.getline(start_line)
    s_lines[1] = line:sub(1, start_col - 1) .. s_lines[1]
    s_lines[#s_lines] = s_lines[#s_lines] .. line:sub(math.max(end_col, end_col + 1))
    vim.api.nvim_buf_set_lines(0, start_line-1, end_line, true, s_lines)
  elseif start_line ~= end_line then
    local first_line = vim.fn.getline(start_line)
    local last_line = vim.fn.getline(end_line)
    s_lines[1] = first_line:sub(1, start_col - 1) .. s_lines[1]
    s_lines[#s_lines] = s_lines[#s_lines] .. last_line:sub(math.max(end_col, end_col + 1))
    vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, true, s_lines)
  end
end

M.transform_selection = function(cmd)
  local selection = M.get_selection_points()
  local s1,c1,s2,c2 = unpack(selection)
  local result = M.call_subprocess_on_range(cmd
    , s1
    , c1
    , s2
    , c2
  )
  M.overwrite_range(result, s1, c1, s2, c2)
  return result
end

M.execute_selection = function()
  M.transform_selection({"sh", "-c"})
end

M.insert_at_point = function(s)
  local col = vim.api.nvim_win_get_cursor(0)[2] -- row, col
  local line_text = vim.api.nvim_get_current_line()
  local joined = line_text:sub(0, col) .. s .. line_text:sub(col + 1)
  vim.api.nvim_set_current_line(joined)
end

return M
