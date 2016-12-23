#!/bin/sh

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
