#!/bin/bash

# Ensure target directories exist
mkdir -p "$HOME/.config/nvim"

# Link tmux.conf
# Use symbolic link so changes in repo are reflected immediately
rm -f "$HOME/.tmux.conf"
ln -sf "$PWD/tmux.conf" "$HOME/.tmux.conf"

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
