#!/bin/sh
cd $(dirname $0)

if ! command -v vim >/dev/null 2>&1; then
	echo '!! VIM NOT FOUND' >&2
	echo '!! CONTINUING ANYWAY' >&2
fi

cp .vimrc ~/.vimrc
# install plug
plug_dir=~/.vim/autoload
mkdir -p $plug_dir
curl -fLo $plug_dir/plug.vim \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

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
