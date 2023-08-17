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

sudo chown $UID:$GID /usr/local/bin

/usr/sbin/softwareupdate --install-rosetta --agree-to-license

brew bundle --file ~/.dotfiles/osx/brew/core.brewfile
if [ "$BUNDLE_NAME" != "" ]; then
  brew bundle --file ~/.dotfiles/osx/brew/"$BUNDLE_NAME".brewfile
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
git_clone https://github.com/nvm-sh/nvm.git ~/.nvm

vim +PluginInstall +qall
~/.tmux/plugins/tpm/bin/install_plugins

~/.rvm/bin/rvm alias create default system

cd ~/.nvm
git checkout v0.37.2
cd - >/dev/null

export NVM_DIR="$HOME/.nvm"
source ~/.dotfiles/shell/nvm
nvm install 'lts/*' --latest-npm
npm install -g npm http-server yarn

sudo dscl . -create /Users/$USER UserShell /opt/homebrew/bin/zsh

echo ""
echo -e "\033[0;32mFIN\033[0m"
