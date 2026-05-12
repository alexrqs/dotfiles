#!/bin/bash
# Post-clone installer. Validates profile, runs brew bundle, then the
# universal helper scripts. Called by bootstrap.sh after the repo is
# cloned, but can also be re-run directly:
#
#   ~/dotfiles/scripts/install.sh <light|corporate|full>

set -euo pipefail

PROFILE="${1:-light}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
BREWFILE="$SCRIPT_DIR/profiles/Brewfile.$PROFILE"

if [ ! -f "$BREWFILE" ]; then
  echo "Unknown profile: $PROFILE"
  echo "Available profiles:"
  ls -1 "$SCRIPT_DIR/profiles/" | sed 's/Brewfile\./  /'
  exit 1
fi

echo "==> Installing profile '$PROFILE' from $BREWFILE"
brew bundle install --file="$BREWFILE"

# Preview cleanup, then prompt before destructive removal.
echo
echo "==> Packages installed but not in profile '$PROFILE':"
# `cleanup` (no --force) exits non-zero when there's something to clean.
# We don't want pipefail to kill us here.
set +e
brew bundle cleanup --file="$BREWFILE"
set -e
echo
read -p "Uninstall the packages listed above? [y/N]: " -n 1 -r; echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  brew bundle cleanup --force --file="$BREWFILE"
fi

echo
echo "==> Running helpers"
bash "$SCRIPT_DIR/ohmyzsh-plugins.sh"
bash "$SCRIPT_DIR/kitty-setup.sh"
bash "$SCRIPT_DIR/macos-defaults.sh"
bash "$SCRIPT_DIR/stow-prompt.sh"
bash "$SCRIPT_DIR/post-stow.sh"

# Personalize is one-time per machine.
if [ ! -f "$HOME/.temp" ]; then
  echo
  bash "$SCRIPT_DIR/personalize.sh"
else
  echo
  echo "~/.temp already exists, skipping personalize."
  echo "Re-run $SCRIPT_DIR/personalize.sh to update git identities."
fi

echo
echo "==> Install complete for profile '$PROFILE'."
