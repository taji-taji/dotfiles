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
setopt interactive_comments


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

## PROMPT
PROMPT=$'${fg[cyan]}[%~]${reset_color} `branch-status-check`
${fg[green]}>>${reset_color} '
## RPROMPT
RPROMPT='[%*]'
setopt prompt_subst #表示毎にPROMPTで設定されている文字列を評価する

function branch-status-check {
    local prefix branchname suffix
        # .gitの中だから除外
        if [[ "$PWD" =~ '/\.git(/.*)?$' ]]; then
            return
        fi
        branchname=`get-branch-name`
        # ブランチ名が無いので除外
        if [[ -z $branchname ]]; then
            return
        fi
        reponame=`get-repo-name`
	# リポジトリ名がないので除外
	if [[ -z $reponame ]]; then
	    return
	fi
        prefix=`get-branch-status` #色だけ返ってくる
        suffix='%{'${reset_color}'%}'
        atmark='%{'${fg[yellow]}'%}@%{'${reset_color}'%}'
        branch=${prefix}${branchname}${suffix}
        repo=${prefix}${reponame}${suffix}
        echo ${branch}${atmark}${repo}
}
function get-repo-name {
    echo `basename -s .git \`git config --get remote.origin.url\` 2> /dev/null`
}
function get-branch-name {
    # gitディレクトリじゃない場合のエラーは捨てます
    echo `git rev-parse --abbrev-ref HEAD 2> /dev/null`
}
function get-branch-status {
    local res color
        output=`git status --short 2> /dev/null`
        if [ -z "$output" ]; then
            res=':' # status Clean
            color='%{'${fg[green]}'%}'
        elif [[ $output =~ "[\n]?\?\? " ]]; then
            res='?:' # Untracked
            color='%{'${fg[yellow]}'%}'
        elif [[ $output =~ "[\n]? M " ]]; then
            res='M:' # Modified
            color='%{'${fg[red]}'%}'
        else
            res='A:' # Added to commit
            color='%{'${fg[cyan]}'%}'
        fi
        # echo ${color}${res}'%{'${reset_color}'%}'
        echo ${color} # 色だけ返す
}

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
