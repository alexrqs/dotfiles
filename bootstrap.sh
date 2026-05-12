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

# 3. Clone dotfiles (or pull if already present, so install.sh is current)
if [ ! -d "$DOTFILES_DIR" ]; then
  echo "==> Cloning dotfiles to $DOTFILES_DIR"
  git clone "$REPO_URL" "$DOTFILES_DIR"
else
  echo "==> Dotfiles already cloned at $DOTFILES_DIR, pulling latest"
  git -C "$DOTFILES_DIR" pull --ff-only
fi

# 4. Hand off to the post-clone installer
echo "==> Handing off to scripts/install.sh $PROFILE"
# Under `curl … | bash`, stdin is the pipe and at EOF by now. Reopen
# /dev/tty so install.sh's interactive prompts (cleanup confirm, stow,
# personalize) can read from the terminal.
exec < /dev/tty
exec "$DOTFILES_DIR/scripts/install.sh" "$PROFILE"
