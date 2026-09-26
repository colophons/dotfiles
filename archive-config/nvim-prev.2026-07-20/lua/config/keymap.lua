local map = vim.keymap.set
local silent = { silent = true }

-- Preserve Vim's native jump language: <C-o> goes back and <C-i>/<Tab>
-- goes forward. Do not map <Tab> in normal mode.
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
map("n", "<M-Tab>", "<C-^>", { desc = "Alternate file" })

-- Windows
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- Files and the system clipboard
map("n", "-", "<cmd>Explore<cr>", { desc = "Browse files" })
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Write buffer" })
map({ "v", "x" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
map({ "n", "v", "x" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })

-- Keep the selection after indenting and preserve the unnamed register when
-- pasting over a visual selection.
map("v", "<", "<gv", silent)
map("v", ">", ">gv", silent)
map("x", "p", [["_dP]], silent)

-- Quickfix is a useful interchange format for searches, compilers, and agents.
map("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix item" })
map("n", "[q", "<cmd>cprevious<cr>", { desc = "Previous quickfix item" })
map("n", "<leader>qo", "<cmd>copen<cr>", { desc = "Open quickfix" })
map("n", "<leader>qc", "<cmd>cclose<cr>", { desc = "Close quickfix" })

local function open_terminal()
  local cwd = vim.uv.cwd()
  local filename = vim.api.nvim_buf_get_name(0)

  if filename ~= "" then
    local buffer_directory = vim.fs.dirname(filename)
    if buffer_directory and vim.fn.isdirectory(buffer_directory) == 1 then
      cwd = buffer_directory
    end
  end

  vim.cmd("botright 12new")
  vim.fn.jobstart(vim.o.shell, { cwd = cwd, term = true })
  vim.cmd.startinsert()
end

map("n", "<leader><CR>", open_terminal, { desc = "Terminal at buffer directory" })
map("n", "<leader>tt", open_terminal, { desc = "Terminal at buffer directory" })

map("t", ";;", [[<C-\><C-n>]], { desc = "Terminal normal mode" })
map("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Terminal normal mode" })
map("t", "<C-h>", [[<C-\><C-n><C-w>h]], silent)
map("t", "<C-j>", [[<C-\><C-n><C-w>j]], silent)
map("t", "<C-k>", [[<C-\><C-n><C-w>k]], silent)
map("t", "<C-l>", [[<C-\><C-n><C-w>l]], silent)
