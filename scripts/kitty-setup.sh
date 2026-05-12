#!/bin/bash
# Install the custom kitty icon onto the kitty.app bundle. Uses
# `fileicon` to set the icon via extended attributes — modern macOS
# blocks writes inside /Applications/*.app/Contents/ even with sudo,
# so cp'ing into Contents/Resources/ fails with "Operation not
# permitted". No-op if kitty isn't installed.

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
ICON_SRC="$DOTFILES_DIR/.config/kitty/kitty.app.png"
KITTY_APP="/Applications/kitty.app"

if [ ! -d "$KITTY_APP" ]; then
  echo "kitty not installed at $KITTY_APP, skipping icon setup"
  exit 0
fi

if [ ! -f "$ICON_SRC" ]; then
  echo "no custom icon at $ICON_SRC, skipping"
  exit 0
fi

if ! command -v fileicon &>/dev/null; then
  echo "→ installing fileicon (one-time, sets icons via xattr)"
  brew install fileicon
fi

echo "→ setting custom kitty icon via fileicon"
fileicon set "$KITTY_APP" "$ICON_SRC"

echo "→ refreshing dock icon cache"
rm -f /var/folders/*/*/*/com.apple.dock.iconcache 2>/dev/null || true
killall Dock || true
