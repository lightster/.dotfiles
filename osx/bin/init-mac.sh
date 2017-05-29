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

if [ ! -x "/usr/bin/gcc" ]; then
    echo "xcode tools are NOT installed."
    echo "xcode tool installation is about to be requested."
    echo "Please re-run $0 after xcode tools are installed."
    sudo gcc --version >/dev/null 2>&1
    exit 1
else
    echo "xcode tools are already installed"
fi

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

brew tap homebrew/dupes
brew tap caskroom/versions

brew install ack
brew install ansible
brew install git
brew install --with-default-names gnu-sed
brew install gpg
brew install --with-default-names grep
brew install npm
brew install postgresql
brew install yarn

brew cask install 1password
brew cask install alfred
brew cask install atom-beta
brew cask install dash2
brew cask install dropbox
brew cask install flux
brew cask install google-chrome
brew cask install hyper
brew cask install macdown
brew cask install phpstorm
brew cask install sequel-pro
brew cask install spotify
brew cask install sublime-text
brew cask install vagrant
brew cask install virtualbox
brew cask install qlmarkdown

curl -sSL https://rvm.io/mpapis.asc | gpg --import -
curl -sSL https://get.rvm.io | bash -s -- --ignore-dotfiles stable

sudo gem install travis -v 1.8.2 --no-rdoc --no-ri

sudo pip install -q awscli boto boto3

sudo npm install -g eslint eslint-config-google

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

if [ ! -d ~/.dotfiles ]; then
    echo ""
    echo "Setting up .dotfiles"
    git clone https://github.com/lightster/.dotfiles.git ~/.dotfiles
    cd ~/.dotfiles
    make configs
    cd - >/dev/null
fi

if [ ! -d ~/.ssh ]; then
    echo ""
    echo "Setting up .ssh"
    git clone https://github.com/lightster/.ssh.git ~/.ssh
fi
