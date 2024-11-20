#!/bin/bash

./preflight.generator.sh
./.temp.generator.sh

# # install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# # Install brew packages
./homebrew.sh

# After Kitty Terminal installation, icon cache should be cleared
yes | rm /var/folders/*/*/*/com.apple.dock.iconcache
killall Dock

# git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ~/.oh-my-zsh/custom/plugins/zsh-autocomplete

# Misc
# reduce the initial wait to repeat key presses
defaults write -g InitialKeyRepeat -int 11

# Prevernt the menu on hold key press
defaults write -g ApplePressAndHoldEnabled -bool false
