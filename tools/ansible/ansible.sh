#!/bin/sh

# ansible
echo "[ansible] install? (y, n): "
while read res; do
	case $res in
		[yY] | [yY]es | YES )
			# mac用
			if [ `uname` = "Darwin" ]; then
				brew update
				brew install ansible
			# linux用
			elif [ `uname` = "Linux" ]; then
				# todo
			fi
			break;;
		[nN] | [nN]o | NO )
			break;;
		* ) echo "Please enter [y] or [n]."
			echo -n "Do you want to install [ansible]? (y, n): ";;
	esac
done
