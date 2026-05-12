#!/bin/bash
# Interactive stow prompt. Default (Enter) is option 2: overwrite — back
# up conflicting $HOME files into ~/.dotfiles-backup-<timestamp>/, then
# symlink from the repo so the repo's curated dotfiles always win.
#
# IMPORTANT: option 3 (adopt) does the opposite — it pulls existing $HOME
# files INTO the repo, overwriting the repo's curated versions. That is
# almost never what you want on a fresh setup. It's preserved for the
# specific case of migrating an existing manually-curated $HOME into the
# repo.

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
cd "$DOTFILES_DIR"

echo
echo "Stow options:"
echo "  1) stow      — symlink, fail on conflicts (safest)"
echo "  2) overwrite — back up conflicting \$HOME files, then symlink from repo  [default]"
echo "  3) adopt     — pull existing \$HOME files INTO the repo (CLOBBERS repo files)"
echo "  4) skip      — do nothing"
read -p "Choice [1/2/3/4] (default 2): " -n 1 -r choice; echo
choice="${choice:-2}"

case "$choice" in
  1)
    stow .
    ;;
  2)
    # Find what stow would conflict on, move those files to a backup
    # dir, then re-run stow for real. `|| true` keeps set -e happy when
    # stow returns non-zero because of conflicts.
    conflicts=$(stow -nv . 2>&1 | awk -F': ' '/\* existing target/{print $NF}' | sort -u || true)
    if [ -n "$conflicts" ]; then
      ts=$(date +%Y%m%d-%H%M%S)
      backup="$HOME/.dotfiles-backup-$ts"
      mkdir -p "$backup"
      echo "→ backing up conflicting files to $backup"
      while IFS= read -r rel; do
        [ -z "$rel" ] && continue
        src="$HOME/$rel"
        dst="$backup/$rel"
        if [ -e "$src" ] || [ -L "$src" ]; then
          mkdir -p "$(dirname "$dst")"
          mv "$src" "$dst"
          echo "  $rel"
        fi
      done <<< "$conflicts"
    else
      echo "→ no conflicts in \$HOME, stowing directly"
    fi
    stow .
    ;;
  3)
    stow --adopt .
    echo
    echo "WARNING: 'stow --adopt' moved \$HOME files INTO the repo, overwriting the repo's"
    echo "curated versions. Review changes before continuing:"
    echo "  cd $DOTFILES_DIR && git status"
    ;;
  4)
    echo "Skipped. Run 'stow .' (or this script again) from $DOTFILES_DIR when ready."
    ;;
  *)
    echo "Invalid choice ('$choice'), skipping."
    exit 0
    ;;
esac
