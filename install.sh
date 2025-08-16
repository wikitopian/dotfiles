#!/bin/bash

ln tmux.conf $HOME/.tmux.conf

ln vimrc $HOME/.vimrc

mkdir $HOME/repo

touch $HOME/repo/dadbod.vim

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

git config --global diff.tool vimdiff
git config --global merge.tool vimdiff
