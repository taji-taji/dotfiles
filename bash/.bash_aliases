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
alias gti='git'
alias gits='git st'
alias gtis='git st'
alias gita='git add .'
alias gtia='gita'
alias gitai='git add -i'
alias gitco='git co'
alias gtico='git co'
alias gitch='git ch'
alias gitbr='git br'
alias gitd='git diff'

# swiftenv
alias se='swiftenv'
alias sev='swiftenv version'
alias sevs='swiftenv versions'
