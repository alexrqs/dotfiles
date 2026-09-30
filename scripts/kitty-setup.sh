#!/bin/bash
# Give kitty the custom icon from this repo (.config/kitty/kitty.app.icns).
#
# kitty applies ~/.config/kitty/kitty.app.icns itself at startup (see kitty
# FAQ: https://sw.kovidgoyal.net/kitty/faq/), but only as a Finder/Dock
# custom icon. Notification Center ignores custom icons and reads the icon
# baked into the bundle (Assets.car first, then kitty.icns), so kitty's
# notifications — Claude Code's included — kept the stock icon. Swap
# kitty.icns for ours and drop Assets.car so macOS falls back to it.
#
# Only those two resources change: Info.plist and the executables are left
# alone and nothing is re-signed, so kitty keeps its Developer ID identity
# (and its privacy permissions); `codesign --verify` just reports the
# changed resources. A kitty update restores the stock icon, so re-run this
# afterwards (`kitty-icon`). `brew reinstall --cask kitty` undoes it.

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
ICON_SRC="$DOTFILES_DIR/.config/kitty/kitty.app.icns"
KITTY_APP="/Applications/kitty.app"
RESOURCES="$KITTY_APP/Contents/Resources"
LSREGISTER=/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister

if [ ! -d "$KITTY_APP" ]; then
  echo "kitty not installed at $KITTY_APP, skipping icon setup"
  exit 0
fi

if [ ! -f "$ICON_SRC" ]; then
  echo "custom icon not found at $ICON_SRC, skipping"
  exit 0
fi

if cmp -s "$ICON_SRC" "$RESOURCES/kitty.icns" && [ ! -e "$RESOURCES/Assets.car" ]; then
  echo "→ kitty bundle icon already up to date"
else
  echo "→ installing custom icon into $KITTY_APP"
  cp "$ICON_SRC" "$RESOURCES/kitty.icns"
  rm -f "$RESOURCES/Assets.car"
  # Make LaunchServices re-read the bundle, then drop the per-user
  # IconServices cache (it keeps serving the stock icon otherwise) and
  # restart everything that holds the icon in memory.
  touch "$KITTY_APP"
  "$LSREGISTER" -f "$KITTY_APP"
  rm -rf "$(getconf DARWIN_USER_CACHE_DIR)com.apple.iconservices"
  pkill -9 -U "$UID" -x iconservicesagent || true
  killall usernotificationsd NotificationCenter 2>/dev/null || true
fi

echo "→ refreshing Dock icon cache"
rm -f /var/folders/*/*/*/com.apple.dock.iconcache 2>/dev/null || true
killall Dock || true
echo "→ done."
