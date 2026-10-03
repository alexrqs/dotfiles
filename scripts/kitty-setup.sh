#!/bin/bash
# Give kitty the custom cat icon from this repo, in notifications too.
#
# kitty applies ~/.config/kitty/kitty.app.icns itself at startup (see kitty
# FAQ: https://sw.kovidgoyal.net/kitty/faq/), but only as a Finder/Dock
# custom icon. Notification Center ignores custom icons and reads the icon
# baked into the bundle (Assets.car first, then kitty.icns), so kitty's
# notifications — Claude Code's included — kept the stock icon. Swap
# kitty.icns for assets/kitty-bundle.icns (the same cat on a black tile,
# since macOS 26+ would otherwise put it on a grey one; rebuild it with
# assets/make-kitty-bundle-icon.py) and drop Assets.car so macOS falls
# back to it.
#
# Only those two resources change: Info.plist and the executables are left
# alone and nothing is re-signed, so kitty keeps its Developer ID identity
# (and its privacy permissions); `codesign --verify` just reports the
# changed resources. A kitty update restores the stock icon, so re-run this
# afterwards (`kitty-icon`). `brew reinstall --cask kitty` undoes it.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ICON_SRC="$SCRIPT_DIR/assets/kitty-bundle.icns"
CUSTOM_ICON="$SCRIPT_DIR/../.config/kitty/kitty.app.icns"
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

# The Dock and Finder show the plain cat as a custom icon instead (kitty
# FAQ's cocoa_set_app_icon). kitty re-applies it at startup once an update
# drops it, but not while an older kitty process is still running.
if [ -f "$CUSTOM_ICON" ] && [ ! -e "$KITTY_APP/Icon"$'\r' ]; then
  echo "→ setting the plain cat as kitty.app's custom icon"
  "$KITTY_APP/Contents/MacOS/kitty" +runpy \
    'from kitty.fast_data_types import cocoa_set_app_icon; import sys; cocoa_set_app_icon(*sys.argv[1:])' \
    "$CUSTOM_ICON" "$KITTY_APP"
fi

echo "→ refreshing Dock icon cache"
rm -f /var/folders/*/*/*/com.apple.dock.iconcache 2>/dev/null || true
killall Dock || true
echo "→ done."
