#!/bin/bash

echo "🧰 Installing dotfiles terminal setup..."

# Install tools
sudo apt update && sudo apt install -y zsh fzf curl unzip neofetch htop ncdu bat ripgrep tmux

# Install eza
cd /tmp
curl -LO https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.zip
unzip -o eza_x86_64-unknown-linux-gnu.zip
sudo mv eza /usr/local/bin/

# Install Starship
curl -sS https://starship.rs/install.sh | sh -s -- -y

# Symlink configs
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/cheatsheet.txt ~/cheatsheet.txt

# Apply config
source ~/.zshrc

echo "✅ All set! Type 'zsh' to begin your magic terminal."
