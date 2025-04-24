#!/usr/bin/env bash

install_tools_linux() {
  echo "📦 Installing tools for Debian/Ubuntu..."
  apt update
  apt install -y zsh curl unzip neofetch fzf bat ripgrep htop ncdu tmux git

  TMPDIR="$(mktemp -d)"
  pushd "$TMPDIR" >/dev/null

  EZA_URL=$(curl -s https://api.github.com/repos/eza-community/eza/releases/latest | grep browser_download_url | grep 'x86_64-unknown-linux-gnu.zip' | cut -d '"' -f 4)

  if [[ -z "$EZA_URL" ]]; then
    echo "❌ Could not find eza release URL. Falling back to apt install..."
    apt install -y eza || echo "❌ eza install failed. Please check your sources."
  else
    curl -LO "$EZA_URL"
    unzip -o "$(basename "$EZA_URL")"
    mv eza /usr/local/bin/ || echo "⚠️ Failed to move eza"
  fi

  popd >/dev/null
  rm -rf "$TMPDIR"
  grep -qxF 'alias bat="batcat"' ~/.zshrc || echo 'alias bat="batcat"' >> ~/.zshrc
}
