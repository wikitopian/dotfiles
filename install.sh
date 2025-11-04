#!/bin/bash

ln tmux.conf $HOME/.tmux.conf

ln vimrc $HOME/.vimrc

mkdir -p $HOME/.vim/backup

mkdir $HOME/repo

touch $HOME/repo/dadbod.vim

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

git config --global diff.tool vimdiff
git config --global merge.tool vimdiff

git config --global core.editor "vim"
git config --global user.name "wikitopian"
git config --global user.email "wikitopian@pm.me"
