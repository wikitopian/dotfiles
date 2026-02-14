#!/bin/bash

# Ensure target directories exist
mkdir -p "$HOME/.config/nvim"

# Link tmux.conf
rm -f "$HOME/.tmux.conf" # Remove existing file if it's there
ln tmux.conf "$HOME/.tmux.conf"

# Link init.lua
# Remove existing file if it's there to ensure hard link creation
rm -f "$HOME/.config/nvim/init.lua" 
ln init.lua "$HOME/.config/nvim/init.lua"

mkdir -p "$HOME/.cache/nvim/swap"

mkdir -p "$HOME/repo"

git config --global diff.tool vimdiff
git config --global merge.tool vimdiff

git config --global core.editor "nvim"
git config --global user.name "wikitopian"
git config --global user.email "wikitopian@pm.me"
