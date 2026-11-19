#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "1. Installing packages from Brewfile..."
if command -v brew >/dev/null 2>&1; then
  brew bundle --file="$DOTFILES_DIR/homebrew/Brewfile"
fi

echo "2. Preparing config directories and backing up existing .zshrc..."
mkdir -p ~/.config
if [ -f ~/.zshrc ] && [ ! -L ~/.zshrc ]; then
  mv ~/.zshrc ~/.zshrc.bak
fi

echo "3. Creating symlinks in $HOME via GNU Stow..."
cd "$DOTFILES_DIR"
stow -v -t ~ zsh starship nvim git

echo "4. Creating local override files if missing..."
touch ~/.zshrc.local ~/.gitconfig.local

echo "Done! Restart your shell with: exec zsh"
