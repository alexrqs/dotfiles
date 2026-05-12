#!/bin/bash
# Post-clone installer. Validates profile, runs brew bundle, then the
# universal helper scripts. Called by bootstrap.sh after the repo is
# cloned, but can also be re-run directly:
#
#   ~/dotfiles/scripts/install.sh <light|corporate|full>

set -euo pipefail

PROFILE="${1:-light}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
PROFILES_DIR="$SCRIPT_DIR/profiles"

# Build the effective Brewfile by stacking common + profile cascades.
# light = common + light
# corporate = common + corporate
# full = common + corporate + full
case "$PROFILE" in
  light)     STACK=(common light) ;;
  corporate) STACK=(common corporate) ;;
  full)      STACK=(common corporate full) ;;
  *)
    echo "Unknown profile: $PROFILE"
    echo "Available profiles: light, corporate, full"
    exit 1
    ;;
esac

BREWFILE="$(mktemp -t "brewfile.$PROFILE.XXXXXX")"
trap 'rm -f "$BREWFILE"' EXIT

for tier in "${STACK[@]}"; do
  cat "$PROFILES_DIR/Brewfile.$tier" >> "$BREWFILE"
  echo >> "$BREWFILE"
done

echo "==> Installing profile '$PROFILE' (stack: ${STACK[*]})"
brew bundle install --verbose --file="$BREWFILE"

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
