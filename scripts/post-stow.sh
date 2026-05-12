#!/bin/bash
# Post-stow setup: install Node versions via nvm, bootstrap LazyVim
# plugins. Runs after stow so ~/.config/nvim is in place (if stowed).

set -euo pipefail

# Node versions via nvm. nvm is installed by every profile.
echo "→ setting up Node versions via nvm"
export NVM_DIR="$HOME/.nvm"
mkdir -p "$NVM_DIR"

NVM_SH="/opt/homebrew/opt/nvm/nvm.sh"
if [ ! -s "$NVM_SH" ]; then
  echo "nvm.sh not found at $NVM_SH — is nvm installed via brew?"
  exit 1
fi
# shellcheck disable=SC1090
. "$NVM_SH"

nvm install 20
nvm install 22
nvm alias default 22

# LazyVim plugin bootstrap (only if nvim config is in place).
if [ -f "$HOME/.config/nvim/init.lua" ]; then
  echo "→ bootstrapping LazyVim plugins"
  nvim --headless "+Lazy! sync" +qa
else
  echo "→ no ~/.config/nvim/init.lua, skipping LazyVim bootstrap"
fi
