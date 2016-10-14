#!/bin/sh

set -e

if [ "$#" != "3" ]; then
    echo "Usage: $0 computer-name git-email git-template"
    exit 1
fi

COMPUTER_NAME="$1"
GIT_EMAIL="$2"
GIT_TEMPLATE="$3"

GIT_NAME="Matt Light"
GIT_TEMPLATE="blank"
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
brew install brew-cask
brew install git
brew install --with-default-names gnu-sed
brew install --with-default-names grep
brew install npm
brew install postgresql93

brew cask install 1password
brew cask install alfred
brew cask install dropbox
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

sudo gem install travis -v 1.8.2 --no-rdoc --no-ri

curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
composer global require \
    "lightster/dnsmasq-mgmt=~0.0.4" \
    "squizlabs/php_codesniffer=*" \
    "fabpot/php-cs-fixer=@stable" \
    "phpmd/phpmd=@stable"

echo ""
echo "Setting the name of the computer..."
sudo scutil --set ComputerName "${COMPUTER_NAME}"
sudo scutil --set HostName "${COMPUTER_NAME}.local"
sudo scutil --set LocalHostName "${COMPUTER_NAME}"

if [ ! -d ~/.dotfiles ]; then
    echo ""
    echo "Setting up .dotfiles"
    git clone git://github.com/lightster/.dotfiles ~/.dotfiles
    cd ~/.dotfiles
    echo "${GIT_NAME}" >git/config.user.name
    echo "${GIT_EMAIL}" >git/config.user.email
    echo "${HOME}/.dotfiles" >git/config.dot.path
    echo "${GIT_TEMPLATE}" >git/config.dot.commit_template
    make configs
    cd - >/dev/null
fi

if [ ! -d ~/.ssh ]; then
    echo ""
    echo "Setting up .ssh"
    git clone git://github.com/lightster/.ssh ~/.ssh
fi
