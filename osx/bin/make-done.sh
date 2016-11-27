#!/bin/sh

HOSTNAME=$(hostname -s)

if [ ! -f "${HOME}/.ssh/id_rsa.${HOSTNAME}" ]; then
    echo "'${HOME}/.ssh/id_rsa.${HOSTNAME}' is not setup!"
    exit 1
fi

echo ""
echo "Killing ssh-agent"
sudo killall ssh-agent

echo ""
echo "Cloning the .ssh-private repo to ~/.ssh/private..."
if [ ! -d ~/.ssh/private ]; then
    export GIT_SSH_COMMAND="ssh -i ${HOME}/.ssh/id_rsa.${HOSTNAME} -F /dev/null"
    git clone git@github.com:lightster/.ssh-private.git ~/.ssh/private
    cd ~/.ssh
    ./bin/sshk-update
    cd - >/dev/null
fi

if [ -d ~/.ssh ]; then
    cd ~/.ssh
    git remote set-url origin git@github.com:lightster/.ssh.git
    cd - >/dev/null
fi

if [ -d ~/.dotfiles ]; then
    cd ~/.dotfiles
    git remote set-url origin git@github.com:lightster/.dotfiles.git
    cd - >/dev/null
fi
