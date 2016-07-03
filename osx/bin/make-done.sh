#!/bin/sh

set -e

HOSTNAME=$(hostname -s)

if [ ! -f "${HOME}/.ssh/id_rsa.${HOSTNAME}" ]; then
    echo "'${HOME}/.ssh/id_rsa.${HOSTNAME}' is not setup!"
    exit 1
fi

echo "Switch .dotfiles from https:// to git://"
cd ~/.dotfiles
git remote add origin git://github.com/lightster/.dotfiles.git
git fetch origin
git branch -u origin/master
cd - >/dev/null

echo "Switch .ssh from https:// to git://"
cd ~/.ssh
git remote add origin git://github.com/lightster/.ssh.git
git fetch origin
git branch -u origin/master
cd - >/dev/null

echo ""
echo "Killing ssh-agent"
sudo killall ssh-agent

echo ""
echo "Cloning the .ssh-private repo to ~/.ssh/private..."
git clone git@github.com:lightster/.ssh-private.git ~/.ssh/private
cd ~/.ssh
./bin/sshk-update
cd - >/dev/null
