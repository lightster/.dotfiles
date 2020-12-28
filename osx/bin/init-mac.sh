#!/bin/sh

set -e

if [ "$#" != "1" ]; then
    echo "Usage: $0 computer-name"
    exit 1
fi

COMPUTER_NAME="$1"

GIT_NAME="Matt Light"
SSH_REPO=".ssh"
DOTFILES_REPO=".dotfiles"

echo "Validating for sudo... "
sudo -v

# https://mths.be/osx
# Keep-alive: update existing `sudo` time stamp until this script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

set +e
WHICH_BREW=`which brew >/dev/null 2>&1`
HAS_NOT_BREW=$?
set -e

if [ "$HAS_NOT_BREW" == "1" ]; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    brew update
fi

# prevent `brew doctor` from complaining about missing path in PATH
export PATH="/usr/local/sbin:$PATH"

brew doctor

export HOMEBREW_NO_AUTO_UPDATE=1

brew tap homebrew/cask-drivers
brew tap homebrew/cask-versions
brew tap heroku/brew

brew install ack
brew install ansible
brew install ctags
brew install dockutil
brew install exiftool
brew install fdupes
brew install jq
brew install git
brew install gnu-sed
brew install gpg
brew install grep
brew install heroku
brew install hub
brew install htop
brew install httpie
brew install mas
brew install ncdu
brew install postgresql
brew install the_silver_searcher
brew install tmux
brew install vim
brew install zsh

brew install --cask 1password
brew install --cask alfred
brew install --cask atom-beta
brew install --cask dash
brew install --cask discord
brew install --cask dropbox
brew install --cask gpg-suite
brew install --cask google-chrome
brew install --cask handbrake
brew install --cask intellij-idea
brew install --cask makemkv
brew install --cask quicklook-json
brew install --cask sequel-pro
brew install --cask sketch
brew install --cask spotify
brew install --cask subler
brew install --cask sublime-text
brew install --cask vlc

curl -sSL https://rvm.io/mpapis.asc | gpg --import -
curl -sSL https://get.rvm.io | bash -s -- --ignore-dotfiles stable

sudo pip3 install -q awscli boto boto3

curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
composer global require \
    "lightster/dnsmasq-mgmt=~0.0.4" \
    "squizlabs/php_codesniffer=*" \
    "friendsofphp/php-cs-fixer=@stable" \
    "phpmd/phpmd=@stable"

echo ""
echo "Setting the name of the computer..."
sudo scutil --set ComputerName "${COMPUTER_NAME}"
sudo scutil --set HostName "${COMPUTER_NAME}.local"
sudo scutil --set LocalHostName "${COMPUTER_NAME}"

sudo dscl . -create /Users/$USER UserShell /usr/local/bin/zsh

if [ ! -d ~/.dotfiles ]; then
    echo ""
    echo "Setting up .dotfiles"
    git clone https://github.com/lightster/.dotfiles.git ~/.dotfiles
    cd ~/.dotfiles
    make configs
    cd - >/dev/null
else
    echo ".dotfiles already setup"
fi

if [ ! -d ~/.ssh ]; then
    echo ""
    echo "Setting up .ssh"
    git clone https://github.com/lightster/.ssh.git ~/.ssh
else
    echo ".ssh already setup"
fi

git_clone()
{
  local repo=$1
  local destination=$2

  if [ -d $destination ]; then
    return
  fi

  git clone --depth=1 $repo $destination
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

echo "👨🏼‍💻 😌 "
