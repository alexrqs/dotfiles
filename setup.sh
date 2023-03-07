#!/bin/bash

./preflight.generator.sh
./.temp.generator.sh

for file in .{aliases,exports,functions,gitconfig,temp,preflight,zshrc}; do
  [ -r "$file" ] && echo "ln -s $(pwd)/$file ~/$file"
done
