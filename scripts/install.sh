#!/bin/bash
# Post-clone installer. Validates profile, installs everything in the
# stacked Brewfile (one item at a time so progress is visible), then
# runs the universal helper scripts. Called by bootstrap.sh after the
# repo is cloned, but can also be re-run directly:
#
#   ~/dotfiles/scripts/install.sh <light|corporate|full>

set -euo pipefail

PROFILE="${1:-light}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
PROFILES_DIR="$SCRIPT_DIR/profiles"

log() { echo "[$(date +%H:%M:%S)] $*"; }

# Build the effective Brewfile by stacking common + profile cascades.
# light = common + light
# corporate = common + corporate
# full = common + corporate + full
case "$PROFILE" in
  light)     STACK=(common light) ;;
  corporate) STACK=(common corporate) ;;
  full)      STACK=(common corporate full) ;;
  *)
    log "Unknown profile: $PROFILE"
    log "Available profiles: light, corporate, full"
    exit 1
    ;;
esac

BREWFILE="$(mktemp -t "brewfile.$PROFILE.XXXXXX")"
trap 'rm -f "$BREWFILE"' EXIT

for tier in "${STACK[@]}"; do
  cat "$PROFILES_DIR/Brewfile.$tier" >> "$BREWFILE"
  echo >> "$BREWFILE"
done

log "==> Profile '$PROFILE' (stack: ${STACK[*]})"
log "==> Resolved Brewfile:"
sed 's/^/    /' "$BREWFILE"
echo

# Parse formulae and casks so we can install one-at-a-time with
# explicit progress output. brew bundle install is too quiet on big
# downloads; calling brew install per item gives a clear heartbeat.
mapfile -t FORMULAE < <(grep -E '^brew "'  "$BREWFILE" | sed -E 's/^brew "([^"]+)".*/\1/')
mapfile -t CASKS    < <(grep -E '^cask "'  "$BREWFILE" | sed -E 's/^cask "([^"]+)".*/\1/')

log "==> Plan: ${#FORMULAE[@]} formulae, ${#CASKS[@]} casks"
echo

i=0
for f in "${FORMULAE[@]}"; do
  i=$((i + 1))
  log "==> [$i/${#FORMULAE[@]}] brew install $f"
  brew install "$f"
done

echo
i=0
for c in "${CASKS[@]}"; do
  i=$((i + 1))
  log "==> [$i/${#CASKS[@]}] brew install --cask $c"
  brew install --cask "$c"
done

# Preview cleanup, then prompt before destructive removal.
echo
log "==> Packages installed but not in profile '$PROFILE':"
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
log "==> Running helpers"
for helper in ohmyzsh-plugins.sh kitty-setup.sh macos-defaults.sh stow-prompt.sh post-stow.sh; do
  log "    helper: $helper"
  bash "$SCRIPT_DIR/$helper"
done

# Personalize is one-time per machine.
if [ ! -f "$HOME/.temp" ]; then
  echo
  log "    helper: personalize.sh"
  bash "$SCRIPT_DIR/personalize.sh"
else
  echo
  log "~/.temp already exists, skipping personalize."
  log "Re-run $SCRIPT_DIR/personalize.sh to update git identities."
fi

echo
log "==> Install complete for profile '$PROFILE'."
