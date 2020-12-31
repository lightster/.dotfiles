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
# Sublime Text                                                                #
###############################################################################

# Install Sublime Text settings
mkdir -p ~/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages/
curl -o ~/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages/Package\ Control.sublime-package \
    https://sublime.wbond.net/Package%20Control.sublime-package
SUBLIME_USER_DIR="${HOME}/Library/Application Support/Sublime Text 3/Packages/User"
mkdir -p "$SUBLIME_USER_DIR"
if [[ -d "$SUBLIME_USER_DIR" && ! -L "$SUBLIME_USER_DIR" ]]; then
    rmdir "$SUBLIME_USER_DIR"
fi
ln -sfn ~/Dropbox/Application\ Support/Sublime\ Text\ 3/Packages/User ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User

###############################################################################
# Atom                                                                        #
###############################################################################

ATOM_USER_DIR="${HOME}/.atom"
ATOM_DROPBOX_DIR="${HOME}/Dropbox/Application Support/atom"
if [ -L "$ATOM_USER_DIR" ]; then
    rm "$ATOM_USER_DIR"
fi
mkdir -p "$ATOM_USER_DIR"

ln -sfn "${ATOM_DROPBOX_DIR}/config.cson" "${ATOM_USER_DIR}/config.cson"
ln -sfn "${ATOM_DROPBOX_DIR}/github.cson" "${ATOM_USER_DIR}/github.cson"
ln -sfn "${ATOM_DROPBOX_DIR}/init.coffee" "${ATOM_USER_DIR}/init.coffee"
ln -sfn "${ATOM_DROPBOX_DIR}/keymap.cson" "${ATOM_USER_DIR}/keymap.cson"
ln -sfn "${ATOM_DROPBOX_DIR}/projects.cson" "${ATOM_USER_DIR}/projects.cson"
ln -sfn "${ATOM_DROPBOX_DIR}/snippets.cson" "${ATOM_USER_DIR}/snippets.cson"
ln -sfn "${ATOM_DROPBOX_DIR}/styles.less" "${ATOM_USER_DIR}/styles.less"

###############################################################################
#
###############################################################################

ln -sfn ~/Dropbox/Application\ Support/dnsmasq-mgmt ~/.dnsmasq-mgmt
touch ~/Dropbox/Application\ Support/bash_history/$HOSTNAME
ln -sfn ~/Dropbox/Application\ Support/bash_history/$HOSTNAME ~/.bash_history

dockutil --remove all

echo "Done. Some changes require a logout/restart to take effect."
