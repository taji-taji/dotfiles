#!/bin/sh
if [ ! -e ~/.vim/bundle ]; then
	mkdir ~/.vim/bundle
fi

if [ ! -e ~/.vim/colors/ ]; then
	mkdir ~/.vim/colors
	cp -r ~/dotfiles/vim/colors ~/.vim
fi

ln -sf ~/dotfiles/vim/ftdetect ~/.vim
ln -sf ~/dotfiles/vim/indent ~/.vim
ln -sf ~/dotfiles/vim/.vimrc ~/.vimrc
ln -sf ~/dotfiles/git/.gitconfig ~/
ln -sf ~/dotfiles/.bashrc ~/

. ~/dotfiles/.fzf/install
. ~/.bashrc
