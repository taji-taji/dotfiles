#!/bin/sh

# rbenv
echo "[rbenv] install? (y, n): "
while read res; do
	case $res in
		[yY] | [yY]es | YES )
			# mac用
			if [ `uname` = "Darwin" ]; then
				brew update
				brew install rbenv
				count=`cat ~/.bash_profile | grep -c 'export PATH="$HOME/.rbenv/bin:$PATH"'`
				if [ $count -eq 0 ]; then
					echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
				fi
				count=`cat ~/.bash_profile | grep -c 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi'`
				if [ $count -eq 0 ]; then
					echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.bash_profile
				fi
				brew install ruby-build
				brew install rbenv-gemset
				brew install rbenv-gem-rehash
			# linux用
			elif [ `uname` = "Linux" ]; then
				git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
				count=`cat ~/.bash_profile | grep -c 'export PATH="$HOME/.rbenv/bin:$PATH'`
				if [ $count -eq 0 ]; then
					echo 'export PATH="$HOME/.rbenv/bin:$PATH' >> ~/.bash_profile
				fi
				count=`cat ~/.bash_profile | grep -c 'eval "$(rbenv init -)"'`
				if [ $count -eq 0 ]; then
					echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
				fi
			fi
			break;;
		[nN] | [nN]o | NO )
			break;;
		* ) echo "Please enter [y] or [n]."
			echo -n "Do you want to install [rbenv]? (y, n): ";;
	esac
done
