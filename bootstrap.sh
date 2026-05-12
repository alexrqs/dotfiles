#!/bin/bash
# Bootstrap a fresh macOS machine. The curl|bash entry point:
#
#   curl -fsSL https://raw.githubusercontent.com/alexrqs/dotfiles/master/bootstrap.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/alexrqs/dotfiles/master/bootstrap.sh | bash -s corporate
#
# Does the pre-clone work, then hands off to scripts/install.sh.

set -euo pipefail

PROFILE="${1:-light}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
REPO_URL="https://github.com/alexrqs/dotfiles.git"

# 1. Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "==> Installing Oh My Zsh"
  RUNZSH=no CHSH=no \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "==> Oh My Zsh already installed"
fi

# 2. Homebrew
# `</dev/tty` so the installer's RETURN-to-continue prompt and sudo can
# read input even when bootstrap.sh is itself piped from `curl | bash`.
if ! command -v brew &>/dev/null; then
  echo "==> Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" </dev/tty
else
  echo "==> Homebrew already installed"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

# 3. Clone dotfiles, or sync an existing checkout to origin/master.
# If a previous run used `stow --adopt`, $HOME files were moved INTO the
# repo and the working tree is dirty. To make install.sh idempotent we
# stash any local changes (recoverable via `git stash list / pop`) and
# hard-reset to the remote, so stow starts from a clean curated state.
if [ ! -d "$DOTFILES_DIR" ]; then
  echo "==> Cloning dotfiles to $DOTFILES_DIR"
  git clone "$REPO_URL" "$DOTFILES_DIR"
else
  echo "==> Dotfiles already cloned at $DOTFILES_DIR, syncing to origin/master"
  git -C "$DOTFILES_DIR" fetch origin
  if [ -n "$(git -C "$DOTFILES_DIR" status --porcelain)" ]; then
    STASH_MSG="auto-stash before bootstrap reset $(date +%Y%m%d-%H%M%S)"
    echo "    local changes detected, stashing as: $STASH_MSG"
    git -C "$DOTFILES_DIR" stash push --include-untracked -m "$STASH_MSG" || true
  fi
  git -C "$DOTFILES_DIR" reset --hard origin/master
fi

# 4. Hand off to the post-clone installer.
# `< /dev/tty` gives install.sh a real terminal as stdin so its
# interactive prompts (cleanup confirm, stow, personalize) can read
# from the keyboard even when bootstrap.sh was piped from `curl | bash`.
# CRITICAL: keep the redirect on the SAME line as exec. Doing
# `exec < /dev/tty` on its own line first would close the curl pipe
# while bash is still reading this script from it, causing bash to
# silently block trying to read the next command from /dev/tty.
echo "==> Handing off to scripts/install.sh $PROFILE"
exec "$DOTFILES_DIR/scripts/install.sh" "$PROFILE" < /dev/tty
