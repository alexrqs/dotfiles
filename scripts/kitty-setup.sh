#!/bin/bash
# Refresh the Dock so kitty's custom icon takes effect. The icon itself
# is delivered by stow: ~/.config/kitty/kitty.app.icns is a symlink into
# this repo, and kitty reads it automatically at startup (see kitty
# FAQ: https://sw.kovidgoyal.net/kitty/faq/). No bundle modification, no
# sudo needed.

set -euo pipefail

KITTY_CONFIG="$HOME/.config/kitty"

if ! command -v kitty &>/dev/null; then
  echo "kitty not installed, skipping icon refresh"
  exit 0
fi

if [ ! -f "$KITTY_CONFIG/kitty.app.icns" ] && [ ! -f "$KITTY_CONFIG/kitty.app.png" ]; then
  echo "no kitty.app.icns/png in $KITTY_CONFIG, skipping"
  echo "(should be stowed from this repo's .config/kitty/)"
  exit 0
fi

echo "→ refreshing Dock icon cache"
rm -f /var/folders/*/*/*/com.apple.dock.iconcache 2>/dev/null || true
killall Dock || true
echo "→ done. The custom icon will appear next time kitty launches."
