#!/bin/sh
cd $(dirname $0)

if ! command -v vim >/dev/null 2>&1; then
	echo '!! VIM NOT FOUND' >&2
	echo '!! CONTINUING ANYWAY' >&2
fi

# Create .vimrc file
true > ~/.vimrc
true > ~/.plugins.vim
cat heavy.vimrc >> ~/.vimrc
cat plugins.vim >> ~/.plugins.vim

mkdir -p ~/vimfiles/backup
mkdir -p ~/vimfiles/undo

# Powerline symbols for zsh only
if [ -f ~/.zshrc ]; then
	echo 'let g:airline_powerline_fonts = 1' >> ~/.vimrc
fi

# Languages
# TODO would be nice to be able to toggle these
cat lang/typescript.vim >> ~/.vimrc
cat lang/typescript.plugins.vim >> ~/.plugins.vim

# install plug
plug_dir=~/.vim/autoload
if ! [ -f $plug_dir/plug.vim ]; then
	mkdir -p $plug_dir
	curl -fLo $plug_dir/plug.vim \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

if command -v nvim >/dev/null 2>&1; then
	mkdir -p ~/.config/nvim
	cp init.vim ~/.config/nvim/
	nvim_plug_dir=~/.local/share/nvim/site/autoload
	mkdir -p $nvim_plug_dir
	cp $plug_dir/plug.vim $nvim_plug_dir
fi

if ! grep 'EDITOR=vim' ~/.bash_aliases >/dev/null 2>&1; then
	echo 'export EDITOR=vim' >> ~/.bash_aliases
fi

if ! grep 'Session.vim' ~/.gitignore >/dev/null 2>&1; then
	echo 'Session.vim' >> ~/.gitignore
fi
