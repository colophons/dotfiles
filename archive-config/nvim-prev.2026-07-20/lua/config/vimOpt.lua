local opt = vim.opt

-- Files and persistence
opt.autoread = true
opt.backup = false
opt.confirm = true
opt.swapfile = true
opt.undofile = true

-- Search and completion
opt.completeopt = { "menuone", "noselect" }
opt.hlsearch = true
opt.ignorecase = true
opt.inccommand = "split"
opt.smartcase = true

-- Layout
opt.cursorline = true
opt.laststatus = 3
opt.number = true
opt.relativenumber = true
opt.scrolloff = 4
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.wrap = false

-- Editing
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.softtabstop = 2
opt.tabstop = 2
opt.virtualedit = "block"

-- Interaction
opt.mouse = "a"
opt.pumheight = 12
opt.timeoutlen = 500
opt.updatetime = 250

-- Keep these visible while the preferred line length settles.
opt.colorcolumn = "80,120"
opt.fillchars:append({ eob = " ", stl = " " })
opt.shortmess:append("I")

if vim.fn.exists("+winborder") == 1 then
  opt.winborder = "rounded"
end

vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3

vim.o.statusline = " %<%f %h%w%m%r%=%y  %l:%c  %P "

vim.cmd.colorscheme("habamax")
