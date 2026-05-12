#!/bin/bash
# Install the custom kitty icon from this repo into /Applications/kitty.app,
# then refresh the Dock so the new icon appears. No-op if kitty isn't
# installed yet.

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
ICON_SRC="$DOTFILES_DIR/.config/kitty/kitty.app.icns"
KITTY_APP="/Applications/kitty.app"
ICON_DST="$KITTY_APP/Contents/Resources/kitty.app.icns"

if [ ! -d "$KITTY_APP" ]; then
  echo "kitty not installed at $KITTY_APP, skipping icon setup"
  exit 0
fi

if [ ! -f "$ICON_SRC" ]; then
  echo "custom icon not found at $ICON_SRC, skipping"
  exit 0
fi

echo "→ installing custom kitty icon"
cp "$ICON_SRC" "$ICON_DST"
# Bump the .app's mtime so macOS LaunchServices re-reads the icon.
touch "$KITTY_APP"

echo "→ refreshing dock icon cache"
rm -f /var/folders/*/*/*/com.apple.dock.iconcache 2>/dev/null || true
killall Dock || true
