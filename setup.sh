#!/bin/bash

echo "🌍 Detecting OS..."
OS="$(uname -s)"

install_tools_linux() {
  echo "📦 Installing tools for Linux..."
  sudo apt update
  sudo apt install -y zsh curl unzip neofetch fzf bat ripgrep htop ncdu tmux git

  # Install eza
  cd /tmp
  curl -LO https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.zip
  unzip -o eza_x86_64-unknown-linux-gnu.zip
  sudo mv eza /usr/local/bin/

  # Alias bat
  echo 'alias bat="batcat"' >> ~/.zshrc
}

install_tools_macos() {
  echo "🍏 Installing tools for macOS..."
  if ! command -v brew >/dev/null; then
    echo "🧪 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  brew install zsh starship fzf bat eza ripgrep neofetch htop ncdu tmux git
}

setup_common() {
  echo "🔧 Applying dotfiles..."
  mkdir -p ~/dotfiles
  cd ~/dotfiles

  # Clone if run from curl
  if [ ! -f ".zshrc" ]; then
    git clone https://github.com/AmeelMD/dotfiles.git .
  fi

  # Symlinks
  ln -sf ~/dotfiles/.zshrc ~/.zshrc
  ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
  ln -sf ~/dotfiles/cheatsheet.txt ~/cheatsheet.txt

  # Starship
  curl -sS https://starship.rs/install.sh | sh -s -- -y
  echo 'eval "$(starship init zsh)"' >> ~/.zshrc
  echo 'alias cheat="bat ~/cheatsheet.txt"' >> ~/.zshrc

  chsh -s $(which zsh)
  echo "✅ Done! Run 'zsh' to start the new shell."
}

case "$OS" in
  Linux*)     install_tools_linux ;;
  Darwin*)    install_tools_macos ;;
  *)          echo "🚫 Unsupported OS: $OS" && exit 1 ;;
esac

setup_common
