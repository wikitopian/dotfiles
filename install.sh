#!/bin/bash

mkdir -p ~/.vim/bundle/
mkdir -p ~/.vim/backup/

git clone git@github.com:VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

touch ~/.vim/db.vim

ln -s .tmux.conf ~/.tmux.conf
ln -s .vimrc ~/.vimrc
ln -s .gitconfig ~/.vimrc
