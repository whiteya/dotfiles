#!/bin/sh
cd $(dirname $0)

if ! command -v tmux >/dev/null 2>&1; then
  echo '!! TMUX NOT FOUND' >&2
  echo '!! CONTINUING ANYWAY' >&2
fi

cp tmux.conf ~/.tmux.conf
echo 'tmux config installed to ~/.tmux.conf'
