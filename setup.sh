#!/bin/bash

./.temp.generator.sh

ln $(pwd)/.aliases ~/.aliases
echo "aliases was copied"

ln $(pwd)/.dircolors ~/.dircolors
echo "dircolors was copied"

ln $(pwd)/.exports ~/.exports
echo "exports was copied"

ln $(pwd)/.functions ~/.functions
echo "functions was copied"

ln $(pwd)/.gitconfig ~/.gitconfig
echo "gitconfig was copied"

ln $(pwd)/.hyper.js ~/.hyper.js
echo "hyper.js was copied"

ln $(pwd)/.bash_prompt ~/.bash_prompt
echo "bash_prompt was copied"

ln $(pwd)/.bashrc ~/.bashrc
echo "bashrc was copied"

ln $(pwd)/.temp ~/.temp
echo "temp was copied"
