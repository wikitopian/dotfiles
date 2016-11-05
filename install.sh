#!/bin/bash

mkdir -p ~/.vim/bundle/
mkdir -p ~/.vim/backup/

git clone git@github.com:VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

touch ~/.vim/db.vim

ln .tmux.conf $HOME/.tmux.conf
ln .vimrc $HOME/.vimrc
ln .gitconfig $HOME/.gitconfig
