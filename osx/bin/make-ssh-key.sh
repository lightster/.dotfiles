#!/bin/sh

set -e

HOSTNAME=$(hostname -s)

#ssh-keygen -t rsa -f "${HOME}/.ssh/id_rsa.${HOSTNAME}"

echo ""
echo "Upload ${HOME}/.ssh/id_rsa.${HOSTNAME}.pub to ~/.dotfiles"
echo "Do NOT upload the pem!"

open ~/.ssh
