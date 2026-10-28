#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_CONFIG_DIR="$SCRIPT_DIR/home"

echo "Setting up dotfile symlinks from $HOME_CONFIG_DIR to $HOME..."

for file in "$HOME_CONFIG_DIR"/.*; do
  base="$(basename "$file")"
  if [[ "$base" == "." || "$base" == ".." || "$base" == ".DS_Store" ]]; then
    continue
  fi

  target="$HOME/$base"
  if [[ -e "$target" && ! -L "$target" ]]; then
    echo "Backing up existing $target to $target.bak"
    mv "$target" "$target.bak"
  fi

  echo "Linking $target -> $file"
  ln -sf "$file" "$target"
done

echo "Dotfiles successfully linked!"
