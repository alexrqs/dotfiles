#!/bin/sh

# will install under /usr/local/opt/fzf/install
# later referenced in ZSHRC export FZF_BASE=/usr/local/opt/fzf/
brew install fzf
brew install fd
# brew install jq
# NOTE: `dasel` is the replacement for jq, yq, etc
brew install dasel
brew install jless
# maintained replacement from exa, ls replacement
brew install eza
brew install noahgorstein/tap/jqp
brew install ast-grep
brew install expect
brew install md5sha1sum
brew install wget
brew install starship
brew install alt-tab
brew install tldr

# for metadata
brew install exiftool

# dig replacement
# brew install dog

# NOTE: du replacement (du will measure the size of the directory)
brew install dust

# for network
brew install iftop
brew install k6

# optional due to AV restrictions
# brew install nmap
brew install wakeonlan
brew install httpie

# for terminal
brew install bat
brew install htop
brew install tree
brew install terminal-notifier
brew install kitty

# Language tools
brew install node
brew install nvm
brew install python
brew install go
brew install elixir
brew install livebook
brew install rust
brew install --cask 1password
brew install --cask 1password-cli
brew install nordvpn

# Code Editors
brew install vscodium
brew install --cask visual-studio-code-insiders
brew install neovim

# Cool 4 neovim
brew install gnu-sed
brew install git-delta
brew install git-extras
brew install gh
brew install glab
brew install ripgrep
brew install lazygit
brew install lazydocker
brew install lazynpm
brew install derailed/k9s/k9s

# for Lua
brew install luarocks

# for rest-nvim
brew install tidy-html5

# browsers
brew install google-chrome
brew install --cask arc
brew install tor-browser
brew install firefox

brew install slack
brew install vlc
brew install dbeaver-community
brew install spotify
brew install telegram

# Stopped using fig because it's really annoying that UI gettings stuck all the time
# brew install fig
brew install rar
brew install appcleaner

# video transcoder
brew install handbrake
brew install zoom

# QuickLook plugin that lets you view text files without their own dedicated QuickLook plugin
# brew install qlstephen

# Cyberduck is a libre server and cloud storage browser for Mac
# and Windows with support for FTP, SFTP, WebDAV, Amazon S3,
# OpenStack Swift, Backblaze B2, Microsoft Azure & OneDrive, Google Drive and Dropbox
brew install cyberduck

# Create a custom DNS
# brew install duckdns

# NOTE: remove rectangle in favor of raycast window management
# brew install rectangle

# NOTE: replaced maccy with raycast clipboard
# brew uninstall maccy

brew uninstall raycast

# NOTE: replace docker with orbstack
# brew uninstall docker
brew install orbstack
brew install ansible

# required for aws cli
brew install groff

brew install flameshot
brew install keycastr
brew install audacity

# NOTE: control the brightness of your external monitors
# brew install monitorcontrol

# NOTE: screen recorder
brew install obs


# virtualization like virtualbox
# brew install qemu

# required for font installation
brew tap homebrew/cask-fonts
brew install font-fira-code-nerd-font
brew install font-hack-nerd-font
brew install font-symbols-only-nerd-font

# brew install --cask adobe-creative-cloud

# Optional packages 
brew_packages=("nmap" "discord" "kubectx" "kubens" "kubectl" "httrack" "wacom-tablet") # Add your packages here

# Function to ask for user confirmation
confirm_install() {
    read -p "Install $1? (Enter for yes, Space/Esc for no): " -n 1 -r
    echo  # Move to a new line
    if [[ $REPLY =~ ^$ ]]  # Enter pressed
    then
        return 0  # Return 0 for 'yes'
    else
        return 1  # Return 1 for 'no'
    fi
}

# Loop through each package and ask for confirmation
for pkg in "${brew_packages[@]}"; do
    if confirm_install "$pkg"; then
        brew install "$pkg"
    else
        echo "Skipping $pkg"
    fi
done
