#!/bin/sh
CURRENT_DIR=`dirname $0`

########## 
# zsh
. ${CURRENT_DIR}/initial/zsh.sh


########## 
# starship
. ${CURRENT_DIR}/initial/starship.sh


##########
# vim
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

##########
# peco
. ${CURRENT_DIR}/tools/peco.sh

# シンボリックリンク
ln -sf "${CURRENT_DIR}/vim/colors" ~/.vim
ln -sf "${CURRENT_DIR}/vim/ftdetect" ~/.vim
ln -sf "${CURRENT_DIR}/vim/ftplugin" ~/.vim
ln -sf "${CURRENT_DIR}/vim/indent" ~/.vim
ln -sf "${CURRENT_DIR}/vim/.vimrc" ~/.vimrc
ln -sf "${CURRENT_DIR}/git/.gitconfig" ~/
ln -sf "${CURRENT_DIR}/zsh/.zsh_alias" ~/
ln -sf "${CURRENT_DIR}/zsh/.zshrc" ~/
ln -sf "${CURRENT_DIR}/zsh/.zshenv" ~/
ln -sf "${CURRENT_DIR}/zsh/.zprofile" ~/
ln -sf "${CURRENT_DIR}/zsh/completion" ~/.zsh/completion

# vim binding config for IDE
ln -sf "$HOME/.vimrc" "$HOME/.ideavimrc"
ln -sf "$HOME/.vimrc" "$HOME/.xvimrc"

chmod -R 755 ${CURRENT_DIR}/zsh/
exec zsh
