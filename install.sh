#!/bin/bash

mkdir -p ~/.vim/backup/

touch ~/.vim/dadbd.vim
chmod 600 ~/.vim/dadbd.vim

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

ln .tmux.conf $HOME/.tmux.conf
ln .vimrc $HOME/.vimrc
ln .gitconfig $HOME/.gitconfig
