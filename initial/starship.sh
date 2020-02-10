#/bin/sh

# install
curl -fsSL https://starship.rs/install.sh | zsh

# link
ln -sf ~/dotfiles/starship/starship.toml ~/.config/starship.toml
