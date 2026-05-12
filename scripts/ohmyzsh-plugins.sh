#!/bin/bash
# Clone oh-my-zsh community plugins. Idempotent: skips clones where the
# plugin directory already exists. Strips .git/.github to keep the tree
# light.

set -euo pipefail

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
mkdir -p "$ZSH_CUSTOM/plugins"

clone_plugin() {
  local repo="$1" name="$2"
  local dest="$ZSH_CUSTOM/plugins/$name"
  if [ -d "$dest" ]; then
    echo "✓ $name already cloned, skipping"
    return 0
  fi
  echo "→ cloning $name"
  git clone --depth 1 "$repo" "$dest"
  rm -rf "$dest/.git" "$dest/.github"
}

clone_plugin https://github.com/zsh-users/zsh-syntax-highlighting.git zsh-syntax-highlighting
clone_plugin https://github.com/zsh-users/zsh-autosuggestions       zsh-autosuggestions
clone_plugin https://github.com/marlonrichert/zsh-autocomplete.git  zsh-autocomplete
