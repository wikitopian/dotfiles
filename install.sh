#!/bin/bash

mkdir -p ~/.vim/backup/

touch ~/.vim/db.vim

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

vim-addon-manager install detectindent fugitive gnupg info justify latex-suite xmledit youcompleteme

ln .tmux.conf $HOME/.tmux.conf
ln .vimrc $HOME/.vimrc
ln .gitconfig $HOME/.gitconfig
