#!/bin/sh
if [ ! -e ~/.vim/bundle ]; then
	mkdir ~/.vim/bundle
fi

if [ ! -e ~/.vim/bundle/neobundle.vim/ ]; then
	git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
fi

if [ -e ~/.vim/colors ]; then
	mv ~/.vim/colors ~/.vim/colors.bak
fi

if [ ! -e ~/.gitconfig_local ]; then
	echo "[user]" >>  ~/.gitconfig_local

	echo -n "Enter git username : "
	while read username; do
		case $username in
			'' ) echo "Blank error."
				echo -n "Enter git username : " ;;
			* ) echo "	name = $username" >> ~/.gitconfig_local 
				break ;;
		esac
	done

	echo -n "Enter git email : "
	while read email; do
		case $email in
			'' ) echo "Blank error."
				echo -n "Enter git email : " ;;
			* ) echo "	email = $email" >> ~/.gitconfig_local 
				break ;;
		esac
	done
fi

if [ -e ~/.bash_profile ]; then
	count=`cat ~/.bash_profile | grep -c 'if [ -f ~/.bashrc ]'`
	echo $count
	if [ $count -eq 0 ]; then
		echo 
"if [ -f ~/.bashrc]; then
	. ~.bashrc
fi" >> ~/.bash_profile
	fi

else
	echo
"if [ -f ~/.bashrc]; then
	. ~.bashrc
fi" >> ~/.bash_profile

fi

ln -sf ~/dotfiles/vim/colors ~/.vim
ln -sf ~/dotfiles/vim/ftdetect ~/.vim
ln -sf ~/dotfiles/vim/indent ~/.vim
ln -sf ~/dotfiles/vim/.vimrc ~/.vimrc
ln -sf ~/dotfiles/git/.gitconfig ~/
ln -sf ~/dotfiles/.bashrc ~/

git add .gitmodules fzf
git add .gitmodules enhancd

bash ~/dotfiles/fzf/install --all

chmod 755 ~/dotfiles/.bashrc
exec bash
