if [ "$(uname)" = 'Darwin' ]; then
    export LSCOLORS=gxfxcxdxbxegedabagacad
    alias ls='ls -G'
else
    eval `dircolors ~/.colorrc`
    alias ls='ls --color=auto'
fi

# ls
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -al'

# git
alias gut='git'
alias got='git'
alias gitst='git st'
alias gita='git add .'
alias gitai='git add -i'
alias gitco='git co'
alias gitch='git ch'
alias gitbr='git br'
alias gitdf='git diff'
