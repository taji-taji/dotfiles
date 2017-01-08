#!/bin/sh

# phpenv
echo "[phpenv] install? (y, n): "
while read res; do
	case $res in
		[yY] | [yY]es | YES )
			# mac用
			if [ `uname` = "Darwin" ]; then
				brew update
				brew tap homebrew/php
				brew install phpenv
				git clone git://github.com/CHH/php-build.git $HOME/.phpenv/plugins/php-build
				count=`cat ~/.bash_profile | grep -c 'export PHPENV_ROOT=$HOME/.phpenv'`
				if [ $count -eq 0 ]; then
					echo 'export PHPENV_ROOT=$HOME/.phpenv' >> ~/.bash_profile
				fi
				count=`cat ~/.bash_profile | grep -c 'export PATH="$PATH:$PHPENV_ROOT/bin"'`
				if [ $count -eq 0 ]; then
					echo 'export PATH="$PATH:$PHPENV_ROOT/bin"' >> ~/.bash_profile
				fi
				count=`cat ~/.bash_profile | grep -c 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi'`
				if [ $count -eq 0 ]; then
					echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.bash_profile
				fi
				count=`cat ~/.bash_profile | grep -c 'if which phpenv > /dev/null; then eval "$(phpenv init -)"; fi'`
				if [ $count -eq 0 ]; then
					echo 'if which phpenv > /dev/null; then eval "$(phpenv init -)"; fi' >> ~/.bash_profile
				fi
			# linux用
			elif [ `uname` = "Linux" ]; then
				echo 'Sorry, not implemented yet.' # todo
			fi
			break;;
		[nN] | [nN]o | NO )
			break;;
		* ) echo "Please enter [y] or [n]."
			echo -n "Do you want to install [phpenv]? (y, n): ";;
	esac
done
