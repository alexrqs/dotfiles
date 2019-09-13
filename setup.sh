#!/bin/bash

# ./.temp.generator.sh

for file in .{aliases,bash_prompt,bashrc,dircolors,exports,functions,gitconfig,hyper.js,temp}; do
  [ -r "$file" ] && echo "ln $file ~/$file"
done
