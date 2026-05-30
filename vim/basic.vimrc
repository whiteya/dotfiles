
set encoding=utf-8

filetype plugin indent on
syntax enable
set number
set showcmd
set wildmenu
set foldenable
set foldcolumn=2

set backspace=2
set mouse=a
set backup
set backupdir=~/vimfiles/backup/
set noerrorbells

set directory=~/vimfiles/backup/
set undofile
set undodir=~/vimfiles/undo/

colorscheme default

set hidden

set relativenumber
set nohlsearch
set incsearch
set ignorecase
set smartcase
set smarttab

set wrap
set breakindent
set breakindentopt=shift:2,sbr
set linebreak
set showbreak=↪\ 
set listchars=tab:»\ ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨

set noswapfile
set scrolloff=5

inoremap kj <esc>
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>
noremap <space> i_<esc>r
noremap <up> g<up>
noremap <down> g<down>
noremap g= gg=G``
vnoremap <up> g<up>
vnoremap <down> g<down>

augroup vimrc
  autocmd!
  set updatetime=700
  autocmd CursorHold,CursorHoldI * silent! update
augroup end

set wildignore+=*/node_modules/*,*.swp,*.zip,*.exe
