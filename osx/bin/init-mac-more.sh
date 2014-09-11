#!/usr/bin/env bash

# Heavily inspired by and copied from
# ~/.osx — http://mths.be/osx

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until this script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# Terminal
###############################################################################

# Only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4

# Use a modified version of the Solarized Dark theme by default in Terminal.app
TERM_PROFILE='TomorrowNightBright';
CURRENT_PROFILE="$(defaults read com.apple.terminal 'Default Window Settings')";
if [ "${CURRENT_PROFILE}" != "${TERM_PROFILE}" ]; then
    open "${HOME}/.dotfiles/osx/terminal/profile/${TERM_PROFILE}.terminal";
    sleep 1; # Wait a bit to make sure the theme is loaded
    defaults write com.apple.terminal 'Default Window Settings' -string "${TERM_PROFILE}";
    defaults write com.apple.terminal 'Startup Window Settings' -string "${TERM_PROFILE}";
fi;

###############################################################################
# source bash_profile
###############################################################################

source ~/.bash_profile

###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "cfprefsd" "Dock" "Finder" "SystemUIServer" "Terminal"; do
    killall "${app}" > /dev/null 2>&1
done

echo "Done. Note that some of these changes require a logout/restart to take effect."
