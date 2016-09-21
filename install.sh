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

# .bash_profile
if [ -e ~/.bash_profile ]; then
	count=`cat ~/.bash_profile | grep -c 'if [ -f ~/.bashrc ]'`
	echo $count
	if [ $count -eq 0 ]; then
		echo "\nif [ -f ~/.bashrc]; then\n\t. ~/.bashrc\nfi" >> ~/.bash_profile
	fi

else
	echo "if [ -f ~/.bashrc]; then\n\t. ~/.bashrc\nfi" >> ~/.bash_profile

fi

# swiftenv
echo "[swiftenv] install? (y, n): "
while read res; do
	case $res in
		[yY] | [yY]es | YES )
			# mac用
			if [ `uname` = "Darwin" ]; then
				brew update
				brew install kylef/formulae/swiftenv
				count=`cat ~/.bash_profile | grep -c 'if which swiftenv > /dev/null; then eval "$(swiftenv init -)"; fi'`
				if [ $count -eq 0 ]; then
					echo 'if which swiftenv > /dev/null; then eval "$(swiftenv init -)"; fi' >> ~/.bash_profile
				fi
			# linux用
			elif [ `uname` = "Linux" ]; then
				git clone https://github.com/kylef/swiftenv.git ~/.swiftenv
				count=`cat ~/.bash_profile | grep -c 'export SWIFTENV_ROOT="$HOME/.swiftenv"'`
				if [ $count -eq 0 ]; then
					echo 'export SWIFTENV_ROOT="$HOME/.swiftenv"' >> ~/.bash_profile
				fi
				count=`cat ~/.bash_profile | grep -c 'export PATH="$SWIFTENV_ROOT/bin:$PATH"'`
				if [ $count -eq 0 ]; then
					echo 'export PATH="$SWIFTENV_ROOT/bin:$PATH"' >> ~/.bash_profile
				fi
				count=`cat ~/.bash_profile | grep -c 'eval "$(swiftenv init -)"'`
				if [ $count -eq 0 ]; then
					echo 'eval "$(swiftenv init -)"' >> ~/.bash_profile
				fi
			fi
			break;;
		[nN] | [nN]o | NO )
			break;;
		* ) echo "Please enter [y] or [n]."
			echo -n "Do you want to install [swiftenv]? (y, n): ";;
	esac
done

# pyenv + virtualenv
echo "[pyenv + virtualenv] install? (y, n): "
while read res; do
	case $res in
		[yY] | [yY]es | YES )
			git clone https://github.com/yyuu/pyenv.git ~/.pyenv
			git clone https://github.com/yyuu/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
			echo 'export PYENV_ROOT=$HOME/.pyenv' >> ~/.bash_profile
			echo 'export PATH=$PYENV_ROOT/bin:$PATH' >> ~/.bash_profile
			echo 'eval "$(pyenv init -)"' >> ~/.bash_profile
			echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bash_profile
			break;;
		[nN] | [nN]o | NO )
			break;;
		* ) echo "Please enter [y] or [n]."
			echo -n "Do you want to install [virtualenv]? (y, n): ";;
	esac
done

# シンボリックリンク
ln -sf ~/dotfiles/vim/colors ~/.vim
ln -sf ~/dotfiles/vim/ftdetect ~/.vim
ln -sf ~/dotfiles/vim/indent ~/.vim
ln -sf ~/dotfiles/vim/.vimrc ~/.vimrc
ln -sf ~/dotfiles/git/.gitconfig ~/
ln -sf ~/dotfiles/bash/.bash_aliases ~/
ln -sf ~/dotfiles/bash/.bashrc ~/

git submodule update --init

bash ~/dotfiles/fzf/install --all

chmod 755 ~/dotfiles/bash/.bashrc
exec bash
