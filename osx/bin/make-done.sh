#!/bin/bash

HOSTNAME=$(hostname -s)

if [ ! -f "${HOME}/.ssh/id_rsa.${HOSTNAME}" ]; then
    echo "'${HOME}/.ssh/id_rsa.${HOSTNAME}' is not setup!"
    exit 1
fi

echo ""
echo "Killing ssh-agent"
sudo killall ssh-agent

echo ""
if [ ! -d ~/.ssh/private ]; then
    echo "cloning .ssh-private"
    export GIT_SSH_COMMAND="ssh -i ${HOME}/.ssh/id_rsa.${HOSTNAME} -F /dev/null"
    git clone git@github.com:lightster/.ssh-private.git ~/.ssh/private
    cd ~/.ssh
    ./bin/sshk-update
    cd - >/dev/null
    echo "done cloning .ssh-private"
else
    echo ".ssh-private already cloned"
fi

if [ -d ~/.ssh ]; then
    echo -n "updating .ssh remote origin to use ssh protocol... "
    cd ~/.ssh
    git remote set-url origin git@github.com:lightster/.ssh.git
    cd - >/dev/null
    echo "done"
fi

if [ -d ~/.dotfiles ]; then
    echo -n "updating .dotfiles remote origin to use ssh protocol... "
    cd ~/.dotfiles
    git remote set-url origin git@github.com:lightster/.dotfiles.git
    cd - >/dev/null
    echo "done"
fi
