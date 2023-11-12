#!/bin/sh

# will install under /usr/local/opt/fzf/install
# later referenced in ZSHRC export FZF_BASE=/usr/local/opt/fzf/
brew install fzf
brew install fd
brew install jq
brew install noahgorstein/tap/jqp
brew install expect
brew install md5sha1sum
brew install wget
brew install starship
brew install alt-tab
# optional due to AV restrictions
# brew install nmap
brew install wakeonlan
brew install httpie
brew install bat
brew install htop
brew install tree
brew install terminal-notifier
brew install iterm2
brew install elixir
brew install --cask 1password
brew install --cask 1password-cli

# browsers
brew install google-chrome
brew install --cask arc
brew install tor-browser
brew install firefox

# replace ngrock with port forwarding from vscode
# brew install ngrok
brew install slack
brew install vlc
brew install dbeaver-community
brew install rectangle
brew install spotify

# Stopped using fig be ause it's really annoying that UI gettings stuck all the time
# brew install fig
brew install rar
brew install appcleaner

# video transcoder
brew install handbrake
brew install zoom
# QuickLook plugin that lets you view text files without their own dedicated QuickLook plugin
brew install qlstephen
brew install audacity

# Cyberduck is a libre server and cloud storage browser for Mac
# and Windows with support for FTP, SFTP, WebDAV, Amazon S3,
# OpenStack Swift, Backblaze B2, Microsoft Azure & OneDrive, Google Drive and Dropbox
brew install cyberduck

# Create a custom DNS
brew install duckdns

# replaced maccy with raytrace clipboard
brew uninstall maccy

# raycast is not yet in the workflow
brew uninstall raycast

# replace docker with orbstack
brew uninstall docker
brew install orbstack

brew install flameshot
brew install keycastr
brew install monitorcontrol
brew install obs

# Code Editors
brew install vscodium
brew install --cask visual-studio-code-insiders
brew install neovim
brew install git-delta
brew install ripgrep
brew install lazygit
brew install lazydocker

# required for font installation
brew tap homebrew/cask-fonts
brew install font-fira-code-nerd-font
brew install font-hack-nerd-font
brew install font-operator-mono-nerd-font
brew install font-operator-mono-lig
brew uninstall font-lobster

brew install --cask adobe-creative-cloud

# Optional packages 
brew_packages=("nmap" "discord" "kubectx" "kubens" "kubectl" "httrack") # Add your packages here

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
