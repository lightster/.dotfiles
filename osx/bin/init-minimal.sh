#!/bin/bash

set -e

if [ "$#" != "1" ]; then
    echo "Usage: $0 <COMPUTER_NAME>"
    exit 1
fi

COMPUTER_NAME="$1"

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
brew bundle --file ~/.dotfiles/osx/brew/minimal.brewfile

echo ""
echo -n "setting name of computer... "
sudo scutil --set ComputerName "${COMPUTER_NAME}"
sudo scutil --set HostName "${COMPUTER_NAME}.local"
sudo scutil --set LocalHostName "${COMPUTER_NAME}"
echo "done setting name of computer"

echo ""
# green checkmarks
echo -e "\033[0;32m\xE2\x9C\x94\xE2\x9C\x94\xE2\x9C\x94\033[0m"
