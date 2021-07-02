
filetype plugin indent on
syntax enable
set number 		" line numbers
set showcmd		" command in bottom bar
set wildmenu
set foldenable
set incsearch		" incremental search
set hlsearch		" search hilight
set foldcolumn=2	" extra margin

" Misc.
set backspace=2
set mouse=a
set backup
set backupdir=~/vimfiles/backup/
set noerrorbells

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" My stuff
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set directory=~/vimfiles/backup/
set undofile
set undodir=~/vimfiles/undo/

"colorscheme desert
colorscheme industry
highlight LineNr guifg=#606060
highlight LineNr ctermfg=darkgrey

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
let &showbreak='-  '

" Autosave removes the need for swap files
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
	autocmd CursorHold,CursorHoldI * update
augroup end

" Filetype specific settings
autocmd Filetype typescript setlocal expandtab shiftwidth=2 tabstop=2
autocmd Filetype javascript setlocal expandtab shiftwidth=2 tabstop=2

autocmd Filetype elm setlocal expandtab shiftwidth=2 tabstop=2


call plug#begin('~/vimfiles/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'kien/ctrlp.vim'

Plug 'leafgarland/typescript-vim'

call plug#end()

set wildignore+=*/node_modules/*,*.swp,*.zip,*.exe

" Airline config
let g:airline_theme='distinguished'

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
" Fixes problems with /* ... * ... */ comments
let g:airline#extensions#whitespace#mixed_indent_algo = 1

" CTRL P config
let g:ctrlp_working_path_mode = ''
let g:ctrlp_max_files=0

