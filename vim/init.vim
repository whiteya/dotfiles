
source ~/.vimrc

colorscheme industry
highlight LineNr ctermfg=darkgrey

set number
set relativenumber
set mouse=a

set nohlsearch
set showtabline=2
set ruler
set showfulltag

set splitright

set foldmethod=syntax
set foldlevel=99
set foldcolumn=1

" Neovim terminal settings
autocmd TermOpen * setlocal listchars= nonumber norelativenumber
tnoremap kj <C-\><C-n>
tmap <C-W> <C-\><C-n><C-W>

