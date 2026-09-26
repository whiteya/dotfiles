#!/bin/sh

# Use git's default global ignore file instead of core.excludesfile
GIT_IGNORE="${XDG_CONFIG_HOME:-$HOME/.config}/git/ignore"
mkdir -p "$(dirname "$GIT_IGNORE")"
touch "$GIT_IGNORE"

if [ "$(git config --global --get core.excludesfile)" = "$HOME/.gitignore" ]; then
  git config --global --unset core.excludesfile
  if [ -f ~/.gitignore ]; then
    grep -vxFf "$GIT_IGNORE" ~/.gitignore >> "$GIT_IGNORE"
    rm ~/.gitignore
    echo "Moved ~/.gitignore to $GIT_IGNORE"
  fi
fi

git config --global diff.tool nvim_difftool
git config --global difftool.nvim_difftool.cmd 'nvim -c "packadd nvim.difftool" -c "DiffTool $LOCAL $REMOTE"'
git config --global difftool.prompt false
git config --global merge.tool nvimdiff
