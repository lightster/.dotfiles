#!/usr/bin/env bash

# Heavily inspired by and copied from
# ~/.osx — http://mths.be/osx

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
    open "${HOME}/.dotfiles/macos/terminal/profile/${TERM_PROFILE}.terminal";
    sleep 2; # Wait a bit to make sure the theme is loaded
    defaults write com.apple.terminal 'Default Window Settings' -string "${TERM_PROFILE}";
    defaults write com.apple.terminal 'Startup Window Settings' -string "${TERM_PROFILE}";
fi;

###############################################################################
# iTerm2
###############################################################################

# Load preferences from dotfiles and save changes back on quit
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "${HOME}/.dotfiles/macos/iterm2"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

###############################################################################
#
###############################################################################

dockutil --remove all

echo "Done. Some changes require a logout/restart to take effect."
