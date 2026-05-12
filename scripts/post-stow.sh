#!/bin/bash
# Post-stow setup: install Node versions via nvm, bootstrap LazyVim
# plugins. Runs after stow so ~/.config/nvim is in place (if stowed).
#
# Flags:
#   --reset-nvim   Wipe ~/.local/share/nvim, ~/.local/state/nvim and
#                  ~/.cache/nvim before bootstrapping, so LazyVim
#                  reinstalls plugins from scratch. The config under
#                  ~/.config/nvim is left alone.

set -euo pipefail

RESET_NVIM=0
for arg in "$@"; do
  case "$arg" in
    --reset-nvim) RESET_NVIM=1 ;;
    *) echo "Unknown flag: $arg"; exit 1 ;;
  esac
done

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

# LazyVim plugin bootstrap. Runs against the deployed config at
# ~/.config/nvim, which should be a symlink into the repo after stow.
NVIM_INIT="$HOME/.config/nvim/init.lua"
NVIM_INIT_SRC="${DOTFILES_DIR:-$HOME/dotfiles}/.config/nvim/init.lua"

if [ -f "$NVIM_INIT" ]; then
  if [ "$RESET_NVIM" -eq 1 ]; then
    echo "→ --reset-nvim: wiping LazyVim install state (config left alone)"
    rm -rf "$HOME/.local/share/nvim" "$HOME/.local/state/nvim" "$HOME/.cache/nvim"
  fi
  echo "→ bootstrapping LazyVim plugins"
  nvim --headless "+Lazy! sync" +qa
elif [ -f "$NVIM_INIT_SRC" ]; then
  echo "✗ WARN: $NVIM_INIT is missing, but source exists at $NVIM_INIT_SRC"
  echo "        Stow likely didn't run or was skipped. Fix:"
  echo "          cd ${DOTFILES_DIR:-$HOME/dotfiles} && stow --adopt ."
  echo "        Then re-run: nvim --headless '+Lazy! sync' +qa"
else
  echo "→ no nvim config found, skipping LazyVim bootstrap"
fi
