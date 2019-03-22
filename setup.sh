#!/bin/bash

./.temp.generator.sh

ln $(pwd)/.aliases ~/.aliases
echo "aliases was linked"

ln $(pwd)/.dircolors ~/.dircolors
echo "dircolors was linked"

ln $(pwd)/.exports ~/.exports
echo "exports was linked"

ln $(pwd)/.functions ~/.functions
echo "functions was linked"

cp $(pwd)/.gitconfig ~/.gitconfig
echo "gitconfig was copied"

ln $(pwd)/.hyper.js ~/.hyper.js
echo "hyper.js was linked"

ln $(pwd)/.bash_prompt ~/.bash_prompt
echo "bash_prompt was linked"

ln $(pwd)/.bashrc ~/.bashrc
echo "bashrc was linked"

ln $(pwd)/.temp ~/.temp
echo "temp was linked"
