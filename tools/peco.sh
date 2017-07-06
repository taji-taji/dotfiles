#!/bin/sh

# mac用
if [ `uname` = "Darwin" ]; then
	brew update
	brew install peco
# linux用
elif [ `uname` = "Linux" ]; then
	mkdir -p ~/local/src
	wget https://github.com/peco/peco/releases/download/v0.5.1/peco_linux_amd64.tar.gz -P ~/local/src
	tar -C ~/local -xzf peco_linux_amd64.tar.gz
	mkdir ~/local/bin
	mv ~/local/peco_linux_amd64/peco ~/local/bin/
	chmod 700 ~/local/bin/
fi
