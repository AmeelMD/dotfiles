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

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/install/common.sh"

case "$OS" in
  Darwin)  source "${SCRIPT_DIR}/install/macos.sh" && install_tools_macos ;;
  Proxmox) source "${SCRIPT_DIR}/install/proxmox.sh" && install_tools_proxmox ;;
  Linux)   source "${SCRIPT_DIR}/install/linux.sh" && install_tools_linux ;;
  *)       echo "🚫 Unsupported OS: $OS" && exit 1 ;;
esac

setup_common
