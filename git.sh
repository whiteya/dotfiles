#!/bin/sh

touch ~/.gitignore
git config --global core.excludesfile ~/.gitignore
git config --global diff.tool nvim_difftool
git config --global difftool.nvim_difftool.cmd 'nvim -c "packadd nvim.difftool" -c "DiffTool $LOCAL $REMOTE"'
