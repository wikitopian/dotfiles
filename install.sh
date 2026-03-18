#!/bin/bash

# Ensure target directories exist
mkdir -p "$HOME/.config/nvim"

# Link tmux.conf
# Use symbolic link so changes in repo are reflected immediately
rm -f "$HOME/.tmux.conf"
ln -sf "$PWD/tmux.conf" "$HOME/.tmux.conf"

# Link .commitlintrc.js
rm -f "$HOME/.commitlintrc.js"
ln -sf "$PWD/.commitlintrc.js" "$HOME/.commitlintrc.js"

# Global npm packages for commitlint and other tools
if command -v npm >/dev/null 2>&1; then
  echo "Installing global npm packages..."
  npm install -g @commitlint/cli @commitlint/config-conventional @github/copilot
fi

# Set up git hooks via templates
mkdir -p "$HOME/.git/templates/hooks"
git config --global init.templatedir "$HOME/.git/templates"

# Link hooks from repo to templates
for hook in git-hooks/*; do
  hook_name=$(basename "$hook")
  ln -sf "$PWD/git-hooks/$hook_name" "$HOME/.git/templates/hooks/$hook_name"
  
  # Also link into the current repo if we are in one
  if [ -d ".git/hooks" ]; then
    ln -sf "$PWD/git-hooks/$hook_name" ".git/hooks/$hook_name"
  fi
done

# Link init.lua
# Use symbolic link so changes in repo are reflected immediately
rm -f "$HOME/.config/nvim/init.lua" 
ln -sf "$PWD/init.lua" "$HOME/.config/nvim/init.lua"

mkdir -p "$HOME/.cache/nvim/swap"

mkdir -p "$HOME/repo"

git config --global diff.tool vimdiff
git config --global merge.tool vimdiff

git config --global core.editor "nvim"
git config --global user.name "wikitopian"
git config --global user.email "wikitopian@pm.me"
