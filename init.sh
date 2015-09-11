#!/bin/sh
rm -rf ~/.vim/bundle/
rm -rf ~/.vim/colors/

ln -sf ~/dotfiles/vim/bundle ~/.vim
ln -sf ~/dotfiles/vim/colors ~/.vim
ln -sf ~/dotfiles/vim/ftdetect ~/.vim
ln -sf ~/dotfiles/vim/indent ~/.vim
ln -sf ~/dotfiles/vim/.vimrc ~/.vimrc
ln -sf ~/dotfiles/git/.gitconfig ~/
ln -sf ~/dotfiles/.bashrc ~/

. ~/dotfiles/.fzf/install
. ~/.bashrc
