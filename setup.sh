#!/usr/bin/env bash

set -euo pipefail

# Detect OS and Proxmox VE
echo "🌍 Detecting OS..."
OS="$(uname -s)"
if [ -f /etc/os-release ]; then
  . /etc/os-release
  if grep -qi 'proxmox' <<< "$PRETTY_NAME"; then
    OS="Proxmox"
  fi
fi

install_tools_linux() {
  echo "📦 Installing tools for Debian/Ubuntu..."
  sudo apt update
  sudo apt install -y zsh curl unzip neofetch fzf bat ripgrep htop ncdu tmux git

  # Install eza
  TMPDIR="$(mktemp -d)"
  pushd "$TMPDIR" >/dev/null
  EZA_URL=$(curl -s https://api.github.com/repos/eza-community/eza/releases/latest \
    | grep browser_download_url \
    | grep linux-gnu.zip \
    | cut -d '"' -f 4)
  curl -LO "$EZA_URL"
  unzip -o eza_*_linux-gnu.zip
  sudo mv eza /usr/local/bin/
  popd >/dev/null
  rm -rf "$TMPDIR"

  # Alias bat on Debian/Ubuntu
  grep -qxF 'alias bat="batcat"' ~/.zshrc || echo 'alias bat="batcat"' >> ~/.zshrc
}

install_tools_macos() {
  echo "🍏 Installing tools for macOS..."
  if ! command -v brew &> /dev/null; then
    echo "🧪 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  brew update
  brew install zsh starship fzf bat eza ripgrep neofetch htop ncdu tmux git
}

install_tools_proxmox() {
  echo "🚀 Installing tools on Proxmox VE..."
  # Proxmox is Debian-based; reuse Debian/Ubuntu installer
  install_tools_linux
  # Ensure Proxmox CLI tools are available
  sudo apt update
  sudo apt install -y pve-manager pve-cluster || true
}

setup_common() {
  echo "🔧 Applying dotfiles..."
  DOTFILES_DIR="${HOME}/dotfiles"
  mkdir -p "$DOTFILES_DIR"

  if [ ! -f "${DOTFILES_DIR}/.zshrc" ]; then
    git clone https://github.com/AmeelMD/dotfiles.git "$DOTFILES_DIR"
  fi

  # Symlink user config files
  ln -sf "${DOTFILES_DIR}/.zshrc" ~/.zshrc
  ln -sf "${DOTFILES_DIR}/.tmux.conf" ~/.tmux.conf
  ln -sf "${DOTFILES_DIR}/cheatsheet.txt" ~/cheatsheet.txt

  # Install starship prompt if missing
  if ! command -v starship &> /dev/null; then
    curl -sS https://starship.rs/install.sh | sh -s -- -y
  fi
  grep -qxF 'eval "$(starship init zsh)"' ~/.zshrc || echo 'eval "$(starship init zsh)"' >> ~/.zshrc
  grep -qxF 'alias cheat="bat ~/cheatsheet.txt"' ~/.zshrc || echo 'alias cheat="bat ~/cheatsheet.txt"' >> ~/.zshrc

  # Change default shell
  chsh -s "$(which zsh)" || true
  echo "✅ Dotfiles setup complete! Run 'zsh' to start the new shell."
}

# Main dispatcher
case "$OS" in
  Darwin)      install_tools_macos ;;  
  Proxmox)     install_tools_proxmox ;;  
  Linux)       install_tools_linux ;;  
  *)           echo "🚫 Unsupported OS: $OS" && exit 1 ;;  
esac

setup_common
