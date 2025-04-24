#!/usr/bin/env bash

set -euo pipefail

# ========================
# 🌍 OS Detection
# ========================
OS="$(uname -s)"
if [ -f /etc/os-release ]; then
  . /etc/os-release
  if [[ "${PRETTY_NAME,,}" == *"proxmox"* ]]; then
    OS="Proxmox"
  elif [[ "$ID" == "debian" || "$ID_LIKE" == *"debian"* ]]; then
    OS="Linux"
  fi
fi

# ========================
# 🔧 Tool Install Functions
# ========================
install_zsh() { sudo apt install -y zsh; }
install_curl() { sudo apt install -y curl; }
install_unzip() { sudo apt install -y unzip; }
install_neofetch() { sudo apt install -y neofetch; }
install_fzf() { sudo apt install -y fzf; }
install_bat() { sudo apt install -y bat; }
install_ripgrep() { sudo apt install -y ripgrep; }
install_htop() { sudo apt install -y htop; }
install_ncdu() { sudo apt install -y ncdu; }
install_tmux() { sudo apt install -y tmux; }
install_git() { sudo apt install -y git; }

install_eza() {
  if command -v eza &>/dev/null; then
    echo "✅ eza is already installed."
    return
  fi

  echo "🔍 Installing eza..."
  if [[ "$OS" == "Darwin" ]]; then
    brew install eza && return
  elif [[ "$OS" == "Linux" || "$OS" == "Proxmox" ]]; then
    sudo apt update && sudo apt install -y eza && return
  fi

  TMPDIR="$(mktemp -d)"
  pushd "$TMPDIR" >/dev/null

  EZA_URL=$(curl -s https://api.github.com/repos/eza-community/eza/releases/latest \
    | grep browser_download_url \
    | grep 'x86_64-unknown-linux-gnu.zip' \
    | cut -d '"' -f 4)

  if [[ -z "$EZA_URL" ]]; then
    echo "❌ Failed to find eza release URL."
    popd >/dev/null
    rm -rf "$TMPDIR"
    return 1
  fi

  EZA_FILE=$(basename "$EZA_URL")
  curl -LO "$EZA_URL"

  if [[ -f "$EZA_FILE" ]]; then
    unzip -o "$EZA_FILE"
    sudo mv eza /usr/local/bin/
    echo "✅ eza installed successfully."
  else
    echo "❌ Failed to extract eza binary."
  fi

  popd >/dev/null
  rm -rf "$TMPDIR"
}

# ========================
# 📦 Tool Dispatcher
# ========================
install_all_tools() {
  install_zsh
  install_curl
  install_unzip
  install_neofetch
  install_fzf
  install_bat
  install_ripgrep
  install_htop
  install_ncdu
  install_tmux
  install_git
  install_eza
}

# ========================
# 🔧 Dotfiles Setup
# ========================
setup_dotfiles() {
  echo "🔧 Applying dotfiles..."
  DOTFILES_DIR="$HOME/dotfiles"
  mkdir -p "$DOTFILES_DIR"

  if [ ! -f "$DOTFILES_DIR/.zshrc" ]; then
    git clone https://github.com/AmeelMD/dotfiles.git "$DOTFILES_DIR"
  fi

  ln -sf "$DOTFILES_DIR/.zshrc" ~/.zshrc
  ln -sf "$DOTFILES_DIR/.tmux.conf" ~/.tmux.conf
  ln -sf "$DOTFILES_DIR/cheatsheet.txt" ~/cheatsheet.txt

  if ! command -v starship &> /dev/null; then
    curl -sS https://starship.rs/install.sh | sh -s -- -y
  fi

  grep -qxF 'eval "$(starship init zsh)"' ~/.zshrc || echo 'eval "$(starship init zsh)"' >> ~/.zshrc
  grep -qxF 'alias cheat="bat ~/cheatsheet.txt"' ~/.zshrc || echo 'alias cheat="bat ~/cheatsheet.txt"' >> ~/.zshrc

  chsh -s "$(which zsh)" || true
  echo "✅ Dotfiles setup complete! Run 'zsh' to start the new shell."
}

# ========================
# 🚀 Main Execution
# ========================
echo "🌍 OS Detected: $OS"
install_all_tools
setup_dotfiles