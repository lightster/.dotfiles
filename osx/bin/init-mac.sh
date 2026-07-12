#!/bin/bash

set -e

if [ "$#" != "1" ]; then
    echo "Usage: $0 <BUNDLE_NAME>"
    exit 1
fi

BUNDLE_NAME="$1"

echo "Validating for sudo... "
sudo -v

# https://mths.be/osx
# Keep-alive: update existing `sudo` time stamp until this script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

/usr/sbin/softwareupdate --install-rosetta --agree-to-license

brew bundle --file ~/.dotfiles/osx/brew/core.brewfile
if [ "$BUNDLE_NAME" != "" ]; then
  brew bundle --file ~/.dotfiles/osx/brew/"$BUNDLE_NAME".brewfile
fi

if [ -n "$BUNDLE_NAME" ] && [ -f ~/.dotfiles/mise/conf.d/"$BUNDLE_NAME".toml ]; then
  mkdir -p ~/.config/mise/conf.d
  ln -sfn ~/.dotfiles/mise/conf.d/"$BUNDLE_NAME".toml ~/.config/mise/conf.d/"$BUNDLE_NAME".toml
fi

if [ -n "$BUNDLE_NAME" ] && [ -f ~/.dotfiles/claude/rules.d/"$BUNDLE_NAME".md ] && [ -d ~/.claude/rules ]; then
  ln -sfn ~/.dotfiles/claude/rules.d/"$BUNDLE_NAME".md ~/.claude/rules/"$BUNDLE_NAME".d.md
fi

if ! command -v mise &>/dev/null; then
  curl https://mise.run | sh
fi
MISE="$(command -v mise || echo "$HOME/.local/bin/mise")"
if [ -x "$MISE" ]; then
  "$MISE" install
fi

git_clone()
{
  local repo=$1
  local destination=$2

  if [ ! -d $destination ]; then
    git clone "$repo" "$destination"
  fi

  cd $destination
  cd - >/dev/null
}

git_clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
git_clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git_clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
git_clone https://github.com/zsh-users/zsh-completions.git ~/.zsh-completions

vim +PluginInstall +qall
~/.tmux/plugins/tpm/bin/install_plugins

sudo dscl . -create /Users/$USER UserShell /opt/homebrew/bin/zsh

sudo chown $UID:$GID /usr/local/bin

echo ""
echo -e "\033[0;32mFIN\033[0m"
