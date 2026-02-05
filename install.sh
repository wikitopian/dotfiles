#!/bin/bash

ln tmux.conf $HOME/.tmux.conf

mkdir -p $HOME/.config/nvim
ln init.lua $HOME/.config/nvim/init.lua

mkdir -p $HOME/repo

git config --global diff.tool vimdiff
git config --global merge.tool vimdiff

git config --global core.editor "nvim"
git config --global user.name "wikitopian"
git config --global user.email "wikitopian@pm.me"
