# Ameel's Dotfiles

🚀 Simple, cross-platform terminal setup for Linux and macOS — perfect for workstations, homelab servers, and new VM deployments.

## 🔧 Features

- 🧠 zsh + Starship prompt
- 🧪 Tools: `eza`, `bat`, `fzf`, `ripgrep`, `neofetch`, `htop`, `ncdu`, `tmux`
- 📄 Custom aliases (like `cheat`) and a handy `cheatsheet.txt`
- 🌍 Works on macOS and most Debian/Ubuntu-based Linux systems
- ⚙️ One-liner install for fast setup on any new machine

⸻

## 📄 Contents

- .zshrc — Your zsh config with aliases and Starship prompt
- cheatsheet.txt — Terminal tips and quick reference
- .tmux.conf — Optional, but included if you use tmux
- setup.sh — Automated setup for both macOS and Linux

⸻

## 🧠 Tip: After Setup

- Use zsh (or reopen your terminal)
- Try ls → shows eza output with icons
- Try cheat → shows your cheatsheet using bat

⸻

## 🛠 Notes

- bat is aliased to batcat on Linux for compatibility
- You can edit setup.sh to customize what gets installed
- Make sure to install a Nerd Font for full icon support (like MesloLGS NF)

---

## ⚡ Quick Install (One-Liner)

Paste this into any Linux or macOS terminal:

```bash
bash <(curl -sSL https://raw.githubusercontent.com/AmeelMD/dotfiles/main/setup.sh)

