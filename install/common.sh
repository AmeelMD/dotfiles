#!/usr/bin/env bash

setup_common() {
  echo "🔧 Applying dotfiles..."
  DOTFILES_DIR="${HOME}/dotfiles"
  mkdir -p "$DOTFILES_DIR"

  if [ ! -f "${DOTFILES_DIR}/.zshrc" ]; then
    git clone https://github.com/AmeelMD/dotfiles.git "$DOTFILES_DIR"
  fi

  ln -sf "${DOTFILES_DIR}/.zshrc" ~/.zshrc
  ln -sf "${DOTFILES_DIR}/.tmux.conf" ~/.tmux.conf
  ln -sf "${DOTFILES_DIR}/cheatsheet.txt" ~/cheatsheet.txt

  if ! command -v starship &> /dev/null; then
    curl -sS https://starship.rs/install.sh | sh -s -- -y
  fi

  grep -qxF 'eval "$(starship init zsh)"' ~/.zshrc || echo 'eval "$(starship init zsh)"' >> ~/.zshrc
  grep -qxF 'alias cheat="bat ~/cheatsheet.txt"' ~/.zshrc || echo 'alias cheat="bat ~/cheatsheet.txt"' >> ~/.zshrc

  chsh -s "$(which zsh)" || true
  echo "✅ Dotfiles setup complete! Run 'zsh' to start the new shell."
}
