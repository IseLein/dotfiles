-- vim.opt.guicursor = ""

vim.opt.cul = true
vim.opt.culopt = "number"

vim.opt.nu = true
-- vim.opt.rnu = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.cmd('filetype on')
vim.cmd('filetype plugin on')
vim.cmd('filetype indent on')

vim.opt.list = true
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣', eol = '↴' }
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- plugins
vim.g.tex_flavor = "latex"
vim.g.livepreview_previewer = "zathura"

-- vim.api.nvim_set_hl(0, "LspReferenceText", {})
