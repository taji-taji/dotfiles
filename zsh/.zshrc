########################################
# include files
if [ -f ${HOME}/.zsh_main ]; then
    source ${HOME}/.zsh_main
fi

if [ -f ${HOME}/.zsh_option ]; then
    source ${HOME}/.zsh_option
fi

if [ -f ${HOME}/.zsh_alias ]; then
    source ${HOME}/.zsh_alias
fi

if [ -f ${HOME}/.zsh_local ]; then
    source ${HOME}/.zsh_local
fi

########################################
# 環境変数

# language
export LANG=ja_JP.UTF-8
# SET GOPATH
export GOPATH=$HOME/go
# SET GREP COLOR
export GREP_OPTIONS='--color=auto'


########################################
# color

autoload -Uz colors
colors


########################################
# auto complete

autoload -Uz compinit
compinit


########################################
# history

HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# ヒストリーに重複を表示しない
setopt histignorealldups

# 他のターミナルとヒストリーを共有
setopt share_history

# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space

# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks


########################################
# emacs key bind
#
bindkey -e


########################################
# cd

# 自動でpushdを実行
setopt auto_pushd

# pushdから重複を削除
setopt pushd_ignore_dups


########################################
# スクリプト読み込み
source ~/dotfiles/git/git-completion.bash


########################################
# オプション
# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# beep を無効にする
setopt no_beep

# フローコントロールを無効にする
setopt no_flow_control

# Ctrl+Dでzshを終了しない
setopt ignore_eof

# '#' 以降をコメントとして扱う
setopt interactivecomments


# 高機能なワイルドカード展開を使用する
setopt extended_glob


########################################
# キーバインド

# ^R で履歴検索をするときに * でワイルドカードを使用出来るようにする
bindkey '^R' history-incremental-pattern-search-backward


########################################
# git completion
zstyle ':completion:*:*:git:*' script ~/.zsh/completion/git-completion.zsh
fpath=(~/.zsh/completion $fpath)
autoload -U compinit
compinit -u
rm -f ~/.zcompdump; compinit

########################
# peco
function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi

    BUFFER=$(\history -n 1 | \
        eval $tac | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

#　ユーザーディレクトリ内にインストールした場合はPATHを設定
PATH=$PATH:~/local/bin/
export PATH=$PATH:~/local/bin/


########################
# rbenv
export PATH="$HOME/.rbenv/bin:$PATH" 
eval "$(rbenv init - zsh)"

########################
# pyenv
export PYENV_ROOT=$HOME/.pyenv
export PATH=$PYENV_ROOT/bin:$PATH
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
export PATH="/usr/local/opt/libxml2/bin:$PATH"
export PATH="/usr/local/opt/libxml2/bin:$PATH"
export PATH="/usr/local/opt/libxslt/bin:$PATH"
export PATH="/usr/local/opt/libiconv/bin:$PATH"


########################
# starship
eval "$(starship init zsh)"
