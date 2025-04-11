#!/bin/bash
# Simple script to install Homebrew, Oh My Zsh, and set up your environment

# Exit on error
set -e

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "Oh My Zsh already installed, skipping..."
fi

if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add Homebrew to PATH
  # if [[ $(uname -m) == 'arm64' ]]; then
  #   echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zprofile
  #   eval "$(/opt/homebrew/bin/brew shellenv)"
  # fi
else
  echo "Homebrew already installed, updating..."
  brew update
fi

DOTFILES_DIR="$HOME/dotfiles"

if [ ! -d "$DOTFILES_DIR" ]; then
  echo "Cloning dotfiles repository..."
  git clone https://github.com/alexrqs/dotfiles.git "$DOTFILES_DIR"
fi

# Run your existing installation script
echo "Running your brew installation script..."
bash "$DOTFILES_DIR/scripts/setup.sh"

echo "Installation complete!"
