#!/bin/sh
cd $(dirname $0)

mkdir -p ~/vimfiles/backup
mkdir -p ~/vimfiles/undo

if ! grep 'EDITOR=vim' ~/.bash_aliases >/dev/null 2>&1; then
  echo 'export EDITOR=vim' >> ~/.bash_aliases
fi

if [ "$1" = "basic" ]; then
  # Minimal vim-compatible install — no plugins
  cp basic.vimrc ~/.vimrc
  echo 'Basic vim config installed to ~/.vimrc'
  exit 0
fi

# Full neovim Lua install
if ! command -v nvim >/dev/null 2>&1; then
  echo '!! NVIM NOT FOUND' >&2
  echo '!! CONTINUING ANYWAY' >&2
fi

mkdir -p ~/.config/nvim
rm -f ~/.config/nvim/init.vim
cp -r nvim/. ~/.config/nvim/

# Copilot is optional and disabled by default; enable with: ./install.sh copilot
if [ "$1" = "copilot" ]; then
  touch ~/.config/nvim/copilot.enabled
  echo 'Copilot enabled'
else
  rm -f ~/.config/nvim/copilot.enabled
  echo 'Copilot disabled (enable with: ./install.sh copilot)'
fi

if ! grep 'Session.vim' ~/.gitignore >/dev/null 2>&1; then
  echo 'Session.vim' >> ~/.gitignore
fi

echo 'Neovim config installed to ~/.config/nvim/'
echo 'Open nvim — lazy.nvim will auto-install plugins on first launch'

# LSP servers
echo ''
echo 'Installing LSP servers...'

# typescript-language-server
if command -v npm >/dev/null 2>&1; then
  npm install -g typescript-language-server typescript
else
  echo '!! npm not found — skipping typescript-language-server'
  echo '!! install npm then: npm install -g typescript-language-server typescript'
fi

# clangd (C/C++)
if ! command -v clangd >/dev/null 2>&1; then
  if command -v apt-get >/dev/null 2>&1; then
    sudo apt-get install -y clangd
  elif command -v brew >/dev/null 2>&1; then
    brew install llvm
  else
    echo '!! no package manager found — install clangd manually'
  fi
else
  echo 'clangd already installed'
fi

# rust-analyzer
if command -v rustup >/dev/null 2>&1; then
  rustup component add rust-analyzer
elif command -v cargo >/dev/null 2>&1; then
  cargo install rust-analyzer
else
  echo '!! rustup not found — skipping rust-analyzer'
  echo '!! install rustup then: rustup component add rust-analyzer'
fi
