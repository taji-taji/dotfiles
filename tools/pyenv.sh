#!/bin/sh

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

exec bash
