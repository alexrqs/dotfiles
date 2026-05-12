#!/bin/bash
# macOS system-wide defaults. `defaults write` is set-to-value (not
# append), so re-running this is a no-op.

set -euo pipefail

echo "→ setting fast key repeat"
defaults write -g InitialKeyRepeat -int 11

echo "→ disabling press-and-hold accent menu"
defaults write -g ApplePressAndHoldEnabled -bool false
