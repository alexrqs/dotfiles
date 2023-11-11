#!/bin/bash

./preflight.generator.sh
./.temp.generator.sh

# install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Write permissions for brew
sudo chown -R $(whoami) /opt/homebrew /opt/homebrew/share/aclocal /opt/homebrew/share/info /opt/homebrew/share/locale /opt/homebrew/share/man/man5 /opt/homebrew/share/man/man8 /opt/homebrew/share/zsh /opt/homebrew/share/zsh/site-functions /opt/homebrew/var/homebrew/locks
chmod u+w /opt/homebrew /opt/homebrew/share/aclocal /opt/homebrew/share/info /opt/homebrew/share/locale /opt/homebrew/share/man/man5 /opt/homebrew/share/man/man8 /opt/homebrew/share/zsh /opt/homebrew/share/zsh/site-functions /opt/homebrew/var/homebrew/locks

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
brew install nmap
brew install wakeonlan
brew install kubectx
brew install kubens
brew install kubectl
brew install httpie
brew install httrack
brew install bat
brew install htop
brew install tree
brew install terminal-notifier
brew install iterm2
brew install neovim
brew install elixir
brew install git-delta
brew install ripgrep
brew install lazygit
brew install op

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
brew install discord

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
# brew install raytrace

# Cyberduck is a libre server and cloud storage browser for Mac
# and Windows with support for FTP, SFTP, WebDAV, Amazon S3,
# OpenStack Swift, Backblaze B2, Microsoft Azure & OneDrive, Google Drive and Dropbox
brew install cyberduck

# Create a custom DNS
brew install duckdns
# replaced maccy with raytrace clipboard
# brew install maccy

# raytrace is not yet in the workflow
# brew install raytrace

# replace docker with orbstack
# brew install docker
brew install orbstack

brew install flameshot
brew install keycastr

brew install obs
brew install vscodium
brew install --cask visual-studio-code-insiders

# required for font installation
brew tap homebrew/cask-fonts
brew install font-fira-code-nerd-font
brew install font-hack-nerd-font
brew install font-operator-mono-nerd-font
brew install font-operator-mono-lig
brew install font-lobster

brew install --cask adobe-creative-cloud

git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ~/.oh-my-zsh/custom/plugins/zsh-autocomplete

for file in .{aliases,exports,functions,gitconfig,temp,preflight,zshrc}; do
	[ -r "$file" ] && echo "ln -s $(pwd)/$file ~/$file"
done

ln -s $(pwd)/.config/startship.toml ~/.config/startship.toml
ln -s $(pwd)/delta-themes.gitconfig ~/delta-themes.gitconfig
ln -s $(pwd)/.git-hooks ~/.git-hooks
