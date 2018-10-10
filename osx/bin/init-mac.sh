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
brew doctor

brew tap caskroom/drivers
brew tap caskroom/versions

brew install ack
brew install ansible
brew install ctags
brew install dockutil
brew install jq
brew install git
brew install --with-default-names gnu-sed
brew install gpg
brew install --with-default-names grep
brew install hub
brew install mas
brew install npm
brew install postgresql
brew install the_silver_searcher
brew install tmux
brew install yarn
brew install zsh

brew cask install 1password
brew cask install alfred
brew cask install atom-beta
brew cask install dropbox
brew cask install gpg-suite
brew cask install google-chrome
brew cask install phpstorm
brew cask install sequel-pro
brew cask install spotify
brew cask install sublime-text
brew cask install vagrant
brew cask install virtualbox

curl -sSL https://rvm.io/mpapis.asc | gpg --import -
curl -sSL https://get.rvm.io | bash -s -- --ignore-dotfiles stable

sudo gem install travis --no-rdoc --no-ri

sudo pip2 install -q awscli boto boto3

npm install -g eslint eslint-config-google http-server xo

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

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
git clone --depth=1 https://github.com/zsh-users/zsh-completions.git ~/.zsh-completions

~/.rvm/bin/rvm alias create default system

echo "👨🏼‍💻 😌 "
