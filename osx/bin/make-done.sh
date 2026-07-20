#!/bin/bash

if [ -d ~/.dotfiles ]; then
    echo -n "updating .dotfiles remote origin to use ssh protocol... "
    cd ~/.dotfiles
    git remote set-url origin git@github.com:lightster/.dotfiles.git
    cd - >/dev/null
    echo "done"
fi
