#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Ensure target directories exist
mkdir -p "$HOME/.config/nvim"

# Link tmux.conf
rm -f "$HOME/.tmux.conf"
ln -sf "$SCRIPT_DIR/tmux.conf" "$HOME/.tmux.conf"

# Link .commitlintrc.js
rm -f "$HOME/.commitlintrc.js"
ln -sf "$SCRIPT_DIR/.commitlintrc.js" "$HOME/.commitlintrc.js"

# Global npm packages for commitlint
if command -v npm >/dev/null 2>&1; then
  if ! command -v commitlint >/dev/null 2>&1; then
    echo "Installing global npm packages..."
    npm install -g @commitlint/cli @commitlint/config-conventional
  fi
fi

# Set up git hooks via templates
mkdir -p "$HOME/.git/templates/hooks"
git config --global init.templatedir "$HOME/.git/templates"

# Link hooks from repo to templates
for hook in "$SCRIPT_DIR"/git-hooks/*; do
  hook_name=$(basename "$hook")
  # Skip shared helper files
  [[ "$hook_name" == _* ]] && continue
  ln -sf "$SCRIPT_DIR/git-hooks/$hook_name" "$HOME/.git/templates/hooks/$hook_name"

  # Also link into the current repo if we are in one
  if [ -d "$SCRIPT_DIR/.git/hooks" ]; then
    ln -sf "$SCRIPT_DIR/git-hooks/$hook_name" "$SCRIPT_DIR/.git/hooks/$hook_name"
  fi
done

# Link init.lua
rm -f "$HOME/.config/nvim/init.lua"
ln -sf "$SCRIPT_DIR/init.lua" "$HOME/.config/nvim/init.lua"

mkdir -p "$HOME/.cache/nvim/swap"

mkdir -p "$HOME/repo"

git config --global diff.tool vimdiff
git config --global merge.tool vimdiff

git config --global core.editor "nvim"
git config --global user.name "wikitopian"
git config --global user.email "wikitopian@pm.me"
