#!/bin/bash
ln -s ~/Dropbox/admin/dotfiles/.bashrc ~/.bashrc
ln -s ~/Dropbox/admin/dotfiles/.devilspie ~/.devilspie
ln -s ~/Dropbox/admin/dotfiles/.gitconfig ~/.gitconfig
ln -s ~/Dropbox/admin/dotfiles/.vimrc ~/.vimrc
ln -s ~/Dropbox/admin/.vim ~
ln -s ~/Dropbox/admin/dotfiles/.skypecallrecorder.rc ~/.skypecallrecorder.rc

ln -s ~/Dropbox/admin/dotfiles/.Xmodmap ~/.Xmodmap

ln -s ~/Dropbox/admin/dotfiles/.dmrc ~/.dmrc

ln -s ~/Dropbox/admin/dotfiles/.topen ~/.topen
ln -s ~/Dropbox/admin/dotfiles/.tmux.conf ~/.tmux.conf

ln -s ~/Dropbox/admin/ssh-config ~/.ssh/config
ln -s ~/Dropbox/admin/backuprc.secret ~/.backuprc

cp $HOME/Dropbox/admin/dotfiles/*.desktop $HOME/.config/autostart
