#!/usr/bin/env bash

set -euo pipefail
echo "🌍 Detecting OS..."
OS="$(uname -s)"
if [ -f /etc/os-release ]; then
  . /etc/os-release
  if [[ "${PRETTY_NAME,,}" == *"proxmox"* ]]; then
    OS="Proxmox"
  elif [[ "$ID" == "debian" || "$ID_LIKE" == *"debian"* ]]; then
    OS="Linux"
  fi
fi

REPO_BASE="https://raw.githubusercontent.com/AmeelMD/dotfiles/main/install"

source <(curl -sSL ${REPO_BASE}/common.sh)

case "$OS" in
  Darwin)  source <(curl -sSL ${REPO_BASE}/macos.sh) && install_tools_macos ;;
  Proxmox) source <(curl -sSL ${REPO_BASE}/proxmox.sh) && install_tools_proxmox ;;
  Linux)   source <(curl -sSL ${REPO_BASE}/linux.sh) && install_tools_linux ;;
  *)       echo "🚫 Unsupported OS: $OS" && exit 1 ;;
esac

setup_common
