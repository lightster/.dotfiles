#!/bin/bash

HOSTNAME=$(hostname -s)

if [ ! -f "${HOME}/.ssh/id_rsa.${HOSTNAME}" ]; then
    echo "'${HOME}/.ssh/id_rsa.${HOSTNAME}' is not setup!"
    exit 1
fi

# Reload gpg-agent so it picks up the latest gpg-agent.conf (with
# enable-ssh-support) before we import the SSH key.
echo "reloading gpg-agent..."
gpgconf --kill gpg-agent
gpg-connect-agent /bye >/dev/null

# Make sure this script's ssh-add talks to gpg-agent rather than the
# launchd ssh-agent the parent shell may have inherited.
SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
export SSH_AUTH_SOCK

echo "adding 'id_rsa.${HOSTNAME}' to gpg-agent..."
echo "(pinentry-mac will prompt; check 'Save in Keychain' to skip re-prompting on reboot)"
ssh-add "${HOME}/.ssh/id_rsa.${HOSTNAME}"
echo "done"

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
