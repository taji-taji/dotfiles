########################
# rbenv
export PATH="$HOME/.rbenv/bin:$PATH" 
eval "$(rbenv init - zsh --no-rehash)"

########################
# pyenv
export PYENV_ROOT=$HOME/.pyenv
export PATH=$PYENV_ROOT/bin:$PATH
eval "$(pyenv init - zsh --no-rehash)"
eval "$(pyenv virtualenv-init -)"

########################
# cargo
export PATH="$HOME/.cargo/bin:$PATH"

########################
# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"
