local M = {}

local function directories()
  local cwd = vim.uv.fs_realpath(vim.fn.getcwd()) or vim.fn.getcwd()
  local name = vim.api.nvim_buf_get_name(0)
  local directory = cwd
  if vim.bo.buftype == "" and name ~= "" then
    directory = vim.fs.dirname(name)
    -- A new file may have parents that have not been created yet.
    while directory and vim.fn.isdirectory(directory) == 0 do
      directory = vim.fs.dirname(directory)
    end
    directory = vim.uv.fs_realpath(directory or cwd) or cwd
  end

  -- .git may be a directory or a file (worktrees and submodules).
  local git_root = vim.fs.root(directory, ".git")
  local root = git_root
  if not root then
    root = directory
    for parent in vim.fs.parents(directory) do
      if parent == cwd then
        root = cwd
        break
      end
    end
  end

  local paths = { directory }
  while directory ~= root do
    directory = vim.fs.dirname(directory)
    paths[#paths + 1] = directory
  end
  return paths, git_root
end

local function open(kind, label)
  local paths, git_root = directories()
  local builtin = require("telescope.builtin")
  local actions = require("telescope.actions")
  local state = require("telescope.actions.state")

  local function show(index, query, mode, ignore, hidden)
    local opts = {
      cwd = paths[index],
      prompt_title = ("%s: %s [ignore:%s hidden:%s]"):format(
        label, vim.fn.fnamemodify(paths[index], ":~"), ignore and "on" or "off", hidden and "on" or "off"
      ),
      default_text = query,
      initial_mode = mode,
      attach_mappings = function(prompt, map)
        local function reopen(next_index, next_mode, next_ignore, next_hidden)
          local text = state.get_current_line()
          actions.close(prompt)
          show(next_index, text, next_mode, next_ignore, next_hidden)
        end
        local function move(delta, next_mode)
          return function()
            local next_index = index + delta
            if not paths[next_index] then
              return
            end
            reopen(next_index, next_mode, ignore, hidden)
          end
        end
        for _, binding in ipairs({
          { "n", "<Left>", 1, "normal" }, { "n", "<lt>", 1, "normal" },
          { "n", "<Right>", -1, "normal" }, { "n", ">", -1, "normal" },
          { "i", "<C-Left>", 1, "insert" }, { "i", "<M-lt>", 1, "insert" },
          { "i", "<C-Right>", -1, "insert" }, { "i", "<M->>", -1, "insert" },
        }) do
          local description = binding[3] == 1 and "widen to parent directory" or "narrow toward original directory"
          map(binding[1], binding[2], move(binding[3], binding[4]), { desc = label .. ": " .. description })
        end
        map("n", "ti", function()
          reopen(index, "normal", not ignore, hidden)
        end, { desc = label .. ": toggle ignore rules" })
        map("n", "th", function()
          reopen(index, "normal", ignore, not hidden)
        end, { desc = label .. ": toggle hidden files" })
        map("n", "t.", function()
          if not git_root then
            vim.notify("No Git root for this search", vim.log.levels.INFO)
          elseif index ~= #paths then
            reopen(#paths, "normal", ignore, hidden)
          end
        end, { desc = label .. ": search from Git root" })
        return true
      end,
    }
    if kind == "live_grep" then
      opts.additional_args = {
        ignore and "--ignore" or "--no-ignore",
        hidden and "--hidden" or "--no-hidden",
      }
    else
      opts.hidden = hidden
      opts.no_ignore = not ignore
    end
    builtin[kind](opts)
  end

  show(1, "", "insert", true, true)
end

function M.grep()
  open("live_grep", "Grep")
end

function M.files()
  open("find_files", "Files")
end

return M
