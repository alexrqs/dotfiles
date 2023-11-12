#!/bin/bash

./preflight.generator.sh
./.temp.generator.sh

# install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Write permissions for brew
sudo chown -R $(whoami) /opt/homebrew /opt/homebrew/share/aclocal /opt/homebrew/share/info /opt/homebrew/share/locale /opt/homebrew/share/man/man5 /opt/homebrew/share/man/man8 /opt/homebrew/share/zsh /opt/homebrew/share/zsh/site-functions /opt/homebrew/var/homebrew/locks
chmod u+w /opt/homebrew /opt/homebrew/share/aclocal /opt/homebrew/share/info /opt/homebrew/share/locale /opt/homebrew/share/man/man5 /opt/homebrew/share/man/man8 /opt/homebrew/share/zsh /opt/homebrew/share/zsh/site-functions /opt/homebrew/var/homebrew/locks

# Install brew packages
./homebrew.sh

git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ~/.oh-my-zsh/custom/plugins/zsh-autocomplete

for file in .{aliases,exports,functions,gitconfig,temp,preflight,zshrc}; do
	[ -r "$file" ] && echo "ln -s $(pwd)/$file ~/$file"
done

ln -s $(pwd)/.config/startship.toml ~/.config/startship.toml
ln -s $(pwd)/delta-themes.gitconfig ~/delta-themes.gitconfig
ln -s $(pwd)/.config/nvim ~/.config/nvim
# WIP ln -s $(pwd)/.git-hooks ~/.git-hooks
