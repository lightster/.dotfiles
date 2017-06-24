#!/bin/sh

set -e

HOSTNAME=$(hostname -s)

if [ ! -f "${HOME}/.ssh/id_rsa.${HOSTNAME}" ]; then
    ssh-keygen -t rsa -f "${HOME}/.ssh/id_rsa.${HOSTNAME}"
fi

echo ""
echo "Upload ${HOME}/.ssh/id_rsa.${HOSTNAME}.pub to ~/.dotfiles"
echo "Do NOT upload the pem!"

open ~/.ssh
