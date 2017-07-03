#/bin/sh

# install
if [ `uname` = "Darwin" ]; then
	./tools/brew.sh
	brew install zsh
elif [ `uname` = "Linux" ]; then
	if type yum > /dev/null 2>&1; then
		yum -y install zsh
	elif type apt-get > /dev/null 2>&1; then
		apt-get install zsh
	fi
fi
chsh -s /bin/zsh

# git completion
ZSH_DIR="${HOME}/.zsh"
COMP_DIR="${ZSH_DIR}/completion"
mkdir -p ${COMP_DIR}
curl https://github.com/git/git/raw/master/contrib/completion/git-prompt.sh -L > $COMP_DIR/git-prompt.sh 
curl https://github.com/git/git/raw/master/contrib/completion/git-completion.bash -L > $COMP_DIR/git-completion.bash
curl https://github.com/git/git/raw/master/contrib/completion/git-completion.zsh -L > $COMP_DIR/_git
