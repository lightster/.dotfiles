#!/bin/sh

set -e

if [ ! -d ~/.dotfiles ]; then
    echo ""
    echo "setting up .dotfiles"
    git clone https://github.com/lightster/.dotfiles.git ~/.dotfiles
    cd ~/.dotfiles
    make configs
    cd - >/dev/null
    echo "done setting up .dotfiles"
else
    echo ".dotfiles already setup"
fi

if [ ! -d ~/.ssh ]; then
    echo ""
    echo "setting up .ssh"
    git clone https://github.com/lightster/.ssh.git ~/.ssh
    echo "done setting up .ssh"
else
    echo ".ssh already setup"
fi

echo ""
echo "FIN"
