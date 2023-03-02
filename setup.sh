#!/bin/bash

./.preflight.generator.sh
./.temp.generator.sh

for file in .{aliases,bash_prompt,bashrc,dircolors,exports,functions,gitconfig,hyper.js,temp,preflight,zshrc}; do
  [ -r "$file" ] && echo "ln -s $(pwd)/$file ~/$file"
done
