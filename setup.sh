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

# not yet using autosuggestions
# git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

# install sintax highlighting support for zsh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting


for file in .{aliases,exports,functions,gitconfig,temp,preflight,zshrc}; do
  [ -r "$file" ] && echo "ln -s $(pwd)/$file ~/$file"
done
