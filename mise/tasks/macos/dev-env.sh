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

LOGIN_SHELL=/opt/homebrew/bin/zsh
if [ "$(dscl . -read /Users/"$USER" UserShell | awk '{print $2}')" != "$LOGIN_SHELL" ]; then
  sudo dscl . -create /Users/"$USER" UserShell "$LOGIN_SHELL"
fi

if [ ! -d /usr/local/bin ] || [ "$(stat -f %Su /usr/local/bin)" != "$USER" ]; then
  sudo mkdir -p /usr/local/bin
  sudo chown "$USER":staff /usr/local/bin
fi
