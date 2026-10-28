#!/usr/bin/env bash
set -euo pipefail

CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Setting up dotfile symlinks from $CONFIG_DIR to $HOME..."

DOTFILES=(
  .zshrc
  .p10k.zsh
  .gitconfig
  .clangd
  .clang-format
  .prettierrc
  .zshenv
  .zprofile
  .profile
)

for file in "${DOTFILES[@]}"; do
  source_file="$CONFIG_DIR/$file"
  target="$HOME/$file"

  if [[ ! -f "$source_file" ]]; then
    continue
  fi

  if [[ -e "$target" && ! -L "$target" ]]; then
    echo "Backing up existing $target to $target.bak"
    mv "$target" "$target.bak"
  fi

  echo "Linking $target -> $source_file"
  ln -sf "$source_file" "$target"
done

echo "Dotfiles successfully linked!"
