#!/bin/bash
# Interactive stow prompt. Default (Enter) is option 2: stow --adopt.

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
cd "$DOTFILES_DIR"

echo
echo "Stow options:"
echo "  1) stow         — symlink dotfiles into \$HOME (fails on conflicts)"
echo "  2) stow --adopt — pull existing \$HOME files into the repo, then symlink  [default]"
echo "  3) skip         — do nothing; you'll handle it manually"
read -p "Choice [1/2/3] (default 2): " -n 1 -r choice; echo
choice="${choice:-2}"

case "$choice" in
  1)
    stow .
    ;;
  2)
    stow --adopt .
    echo
    echo "WARNING: 'stow --adopt' overwrites the repo's versions with whatever was in \$HOME."
    echo "Review 'git status' in $DOTFILES_DIR before committing or discarding the changes."
    ;;
  3)
    echo "Skipped. Run 'stow .' from $DOTFILES_DIR when ready."
    ;;
  *)
    echo "Invalid choice ('$choice'), skipping."
    exit 0
    ;;
esac
