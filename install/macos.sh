#!/usr/bin/env bash

install_tools_macos() {
  echo "🍏 Installing tools for macOS..."
  if ! command -v brew &> /dev/null; then
    echo "🧪 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  brew update
  brew install zsh starship fzf bat eza ripgrep neofetch htop ncdu tmux git
}
