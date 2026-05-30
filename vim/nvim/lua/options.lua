vim.opt.encoding = 'utf-8'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showcmd = true
vim.opt.wildmenu = true
vim.opt.ruler = true
vim.opt.showfulltag = true

vim.opt.foldenable = true
vim.opt.foldcolumn = '1'
vim.opt.foldmethod = 'syntax'
vim.opt.foldlevel = 99

vim.opt.backspace = '2'
vim.opt.mouse = 'a'
vim.opt.hidden = true
vim.opt.splitright = true
vim.opt.showtabline = 2

vim.opt.backup = true
vim.opt.backupdir = vim.fn.expand('~/vimfiles/backup/')
vim.opt.directory = vim.fn.expand('~/vimfiles/backup/')
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand('~/vimfiles/undo/')
vim.opt.swapfile = false

vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smarttab = true

vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.breakindentopt = 'shift:2,sbr'
vim.opt.linebreak = true
vim.opt.showbreak = '↪ '
vim.opt.listchars = { tab = '» ', eol = '↲', nbsp = '␣', trail = '•', extends = '⟩', precedes = '⟨' }

vim.opt.scrolloff = 5
vim.opt.updatetime = 700
vim.opt.errorbells = false
vim.opt.signcolumn = 'yes'

vim.opt.wildignore:append('*/node_modules/*,*.swp,*.zip,*.exe')

vim.cmd('colorscheme unokai')
vim.api.nvim_set_hl(0, 'LineNr', { ctermfg = 'darkgrey', fg = '#606060' })
