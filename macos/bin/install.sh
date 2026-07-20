#!/bin/bash

set -e

if [ ! -d ~/.dotfiles ]; then
    echo ""
    echo "cloning .dotfiles"
    git clone https://github.com/lightster/.dotfiles.git ~/.dotfiles
    cd ~/.dotfiles
    make configs
    cd - >/dev/null
    echo "done cloning .dotfiles"
else
    echo ".dotfiles already cloned"
fi

if [ ! -d ~/.ssh ]; then
    echo ""
    echo "cloning .ssh"
    git clone https://github.com/lightster/.ssh.git ~/.ssh
    echo "done cloning .ssh"
else
    echo ".ssh already cloned"
fi

echo ""
# green checkmarks
echo -e "\033[0;32m\xE2\x9C\x94\xE2\x9C\x94\xE2\x9C\x94\033[0m"
