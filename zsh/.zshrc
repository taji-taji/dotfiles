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

