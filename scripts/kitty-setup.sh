#!/bin/bash
# Clear dock icon cache and restart Dock so kitty's custom icon takes
# effect. No-op if kitty isn't installed.

set -euo pipefail

if ! command -v kitty &>/dev/null; then
  echo "kitty not installed, skipping icon refresh"
  exit 0
fi

echo "→ refreshing dock icon cache for kitty"
rm -f /var/folders/*/*/*/com.apple.dock.iconcache 2>/dev/null || true
killall Dock
