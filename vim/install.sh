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

if ! command -v stow >/dev/null 2>&1; then
  echo '!! stow not found (debian: sudo apt-get install stow, arch: sudo pacman -S stow)' >&2
  exit 1
fi

NVIM_DIR=~/.config/nvim

# Must be a real directory: if stow folds it into a symlink, lazy-lock.json,
# colors/ and copilot.enabled get written into this repo.
mkdir -p "$NVIM_DIR"
rm -f "$NVIM_DIR/init.vim"

# Move aside plain copies left by the old cp-based install so stow can link over them
backup="$HOME/.config/nvim.pre-stow.$(date +%Y%m%d%H%M%S)"
moved=
for f in $(cd nvim && find . -type f); do
  t="$NVIM_DIR/$f"
  if [ -f "$t" ] && [ ! -L "$t" ] && [ "$(readlink -f "$t")" != "$(readlink -f "nvim/$f")" ]; then
    mkdir -p "$backup/$(dirname "$f")"
    mv "$t" "$backup/$f"
    moved=1
  fi
done
for d in $(cd nvim && find . -mindepth 1 -type d | sort -r); do
  [ -L "$NVIM_DIR/$d" ] || rmdir "$NVIM_DIR/$d" 2>/dev/null
done
[ -n "$moved" ] && echo "Old copied config moved to $backup"

stow --restow -d "$(pwd)" -t "$NVIM_DIR" nvim || exit 1

# Copilot is optional and disabled by default; enable with: ./install.sh copilot
if [ "$1" = "copilot" ]; then
  touch ~/.config/nvim/copilot.enabled
  echo 'Copilot enabled'
else
  rm -f ~/.config/nvim/copilot.enabled
  echo 'Copilot disabled (enable with: ./install.sh copilot)'
fi

GIT_IGNORE="${XDG_CONFIG_HOME:-$HOME/.config}/git/ignore"
mkdir -p "$(dirname "$GIT_IGNORE")"
if ! grep -qx 'Session.vim' "$GIT_IGNORE" 2>/dev/null; then
  echo 'Session.vim' >> "$GIT_IGNORE"
fi

echo 'Neovim config linked into ~/.config/nvim/'
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

# pyright (Python)
if command -v npm >/dev/null 2>&1; then
  npm install -g pyright
else
  echo '!! npm not found — skipping pyright'
  echo '!! install npm then: npm install -g pyright'
fi
