#!/usr/bin/env bash

install_tools_proxmox() {
  echo "🚀 Installing tools on Proxmox VE..."
  source "$(dirname "${BASH_SOURCE[0]}")/linux.sh"
  install_tools_linux
  apt install -y pve-manager pve-cluster || true
}
