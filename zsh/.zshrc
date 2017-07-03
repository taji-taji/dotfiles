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
# プロンプト
# 2行表示
PROMPT="%{${fg[green]}%}[%n@%m]%{${reset_color}%} %~
%# "


########################################
# スクリプト読み込み
source ~/dotfiles/git/git-completion.bash
source ~/dotfiles/git/git-prompt.sh


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

# git prompt
source ~/.zsh/completion/git-prompt.sh

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' max-exports 6 # formatに入る変数の最大数
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' formats '%b@%r' '%c' '%u'
zstyle ':vcs_info:git:*' actionformats '%b@%r|%a' '%c' '%u'

function vcs_echo() {
    local st branch color
    STY= LANG=en_US.UTF-8 vcs_info
    st=`git status 2> /dev/null`
    if [[ -z "$st" ]]; then return; fi
    branch="$vcs_info_msg_0_"
    if   [[ -n "$vcs_info_msg_1_" ]]; then color=${fg[green]} #staged
    elif [[ -n "$vcs_info_msg_2_" ]]; then color=${fg[red]} #unstaged
    elif [[ -n `echo "$st" | grep "^Untracked"` ]]; then color=${fg[blue]} # untracked
    else color=${fg[cyan]}
    fi
    echo "%F${color}(%{${branch}%})${reset_color}%f" | sed -e s/@/"%F{yellow}@%f${color}"/
}

setopt prompt_subst

local p_cdir="%F{cyan}[%~]%f"
local p_git=`vcs_echo`
local p_mark="%B%(?,%F{green},%F{red})%(!,#,>>=)%f%b"
export PROMPT="$p_cdir$p_git
$p_mark "
