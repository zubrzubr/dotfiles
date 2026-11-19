#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "1. Installing packages from Brewfile..."
if command -v brew >/dev/null 2>&1; then
  brew bundle --no-upgrade --file="$DOTFILES_DIR/homebrew/Brewfile"
fi

for cmd in git stow; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: '$cmd' is required but not installed." >&2
    exit 1
  fi
done

echo "2. Preparing config directories and backing up existing configs..."
mkdir -p ~/.config
if [ -f ~/.zshrc ] && [ ! -L ~/.zshrc ]; then
  mv ~/.zshrc ~/.zshrc.bak
fi
if [ -f ~/.config/starship.toml ] && [ ! -L ~/.config/starship.toml ]; then
  mv ~/.config/starship.toml ~/.config/starship.toml.bak
fi
if [ ! -L ~/.config/git ]; then
  mkdir -p ~/.config/git
  for cfg in ~/.config/git/config ~/.config/git/ignore; do
    if [ -f "$cfg" ] && [ ! -L "$cfg" ]; then
      mv "$cfg" "$cfg.bak"
    fi
  done
fi
if [ ! -L ~/.config/nvim ]; then
  mkdir -p ~/.config/nvim
  for cfg in ~/.config/nvim/init.lua ~/.config/nvim/lazy-lock.json; do
    if [ -f "$cfg" ] && [ ! -L "$cfg" ]; then
      mv "$cfg" "$cfg.bak"
    fi
  done
  if [ -d ~/.config/nvim/lua ] && [ ! -L ~/.config/nvim/lua ]; then
    mv ~/.config/nvim/lua ~/.config/nvim/lua.bak
  fi
fi

echo "3. Initializing submodules and creating symlinks in $HOME via GNU Stow..."
cd "$DOTFILES_DIR"
git submodule update --init --recursive
stow -v --ignore='\.git$' -t ~ zsh starship nvim git

echo "4. Creating local override files if missing..."
touch ~/.zshrc.local ~/.gitconfig.local

if command -v nvim >/dev/null 2>&1 && command -v tree-sitter >/dev/null 2>&1; then
  echo "5. Installing Neovim plugins and Treesitter parsers..."
  nvim --headless "+Lazy! sync" +qa || true
  nvim --headless "+TSUpdate" +qa || true
fi

echo "Done! Restart your shell with: exec zsh"
