#!/usr/bin/env bash

# Heavily inspired by and copied from
# ~/.osx — http://mths.be/osx

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until this script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

HOSTNAME=$(hostname -s)


## Disable press and hold accents
defaults write -g ApplePressAndHoldEnabled -bool false

###############################################################################
# Terminal
###############################################################################

# Use a modified version of the Solarized Dark theme by default in Terminal.app
TERM_PROFILE='TomorrowNightBright';
CURRENT_PROFILE="$(defaults read com.apple.terminal 'Default Window Settings')";
if [ "${CURRENT_PROFILE}" != "${TERM_PROFILE}" ]; then
    open "${HOME}/.dotfiles/osx/terminal/profile/${TERM_PROFILE}.terminal";
    sleep 2; # Wait a bit to make sure the theme is loaded
    defaults write com.apple.terminal 'Default Window Settings' -string "${TERM_PROFILE}";
    defaults write com.apple.terminal 'Startup Window Settings' -string "${TERM_PROFILE}";
fi;

###############################################################################
#
###############################################################################

curl -L -o ~/Downloads/dockutil-3.0.2.pkg \
  https://github.com/kcrawford/dockutil/releases/download/3.0.2/dockutil-3.0.2.pkg
sudo installer -pkg ~/Downloads/dockutil-3.0.2.pkg -target /
dockutil --remove all

echo "Done. Some changes require a logout/restart to take effect."
