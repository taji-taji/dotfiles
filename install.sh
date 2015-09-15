#!/bin/sh
if [ ! -e ~/.vim/bundle ]; then
	mkdir ~/.vim/bundle
fi

if [ ! -e ~/.vim/bundle/neobundle.vim/ ]; then
	git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
fi

if [ ! -e ./.fzf ]; then
	mkdir ./.fzf
fi

if [ ! -e ./.fzf/fzf ]; then
	git clone https://github.com/junegunn/fzf.git ./.fzf
fi

if [ ! -e ./enhancd ]; then
	mkdir ./enhancd
fi

if [ ! -e ./enhancd/enhancd.sh ]; then
	git clone http://github.com/b4b4r07/enhancd.git ./enhancd
fi

if [ -e ~/.vim/colors ]; then
	mv ~/.vim/colors ~/.vim/colors.bak
fi

ln -sf ~/dotfiles/vim/colors ~/.vim
ln -sf ~/dotfiles/vim/ftdetect ~/.vim
ln -sf ~/dotfiles/vim/indent ~/.vim
ln -sf ~/dotfiles/vim/.vimrc ~/.vimrc
ln -sf ~/dotfiles/git/.gitconfig ~/
ln -sf ~/dotfiles/.bashrc ~/

. ~/dotfiles/.fzf/install
. ~/dotfiles/.bashrc
