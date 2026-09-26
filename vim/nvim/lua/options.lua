vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showfulltag = true

vim.opt.foldcolumn = '1'
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldtext = ''
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

vim.opt.mouse = 'a'
vim.opt.splitright = true
vim.opt.showtabline = 2
vim.opt.termguicolors = true

-- The default backupdir starts with '.', which writes backups next to the file
local backupdir = vim.fn.stdpath('state') .. '/backup//'
vim.fn.mkdir(backupdir, 'p')
vim.opt.backup = true
vim.opt.backupdir = backupdir
vim.opt.undofile = true
vim.opt.swapfile = false

vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.breakindentopt = 'shift:2,sbr'
vim.opt.linebreak = true
vim.opt.showbreak = '↪ '
vim.opt.listchars = { tab = '» ', eol = '↲', nbsp = '␣', trail = '•', extends = '⟩', precedes = '⟨' }
vim.opt.fillchars:append({ eob = ' ' })

vim.opt.scrolloff = 5
vim.opt.updatetime = 700
vim.opt.signcolumn = 'yes'

vim.opt.wildignore:append('*/node_modules/*,*.swp,*.zip,*.exe')

-- Colorscheme is set in plugins.lua after lazy.setup() so plugin themes
-- (catppuccin/tokyonight) are loaded first.
