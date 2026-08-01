#!/usr/bin/env bash
#MISE description="Set up tmux/vim plugins, the login shell, and /usr/local/bin"
set -euo pipefail

if [ ! -d ~/.tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

vim +PlugInstall +qall
~/.tmux/plugins/tpm/bin/install_plugins

mise run submodules
mise run build-hooks
mise run claude-integrations

sudo dscl . -create /Users/"$USER" UserShell /opt/homebrew/bin/zsh

sudo mkdir -p /usr/local/bin
sudo chown "$USER":staff /usr/local/bin
