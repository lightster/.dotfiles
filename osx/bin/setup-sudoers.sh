#!/bin/bash

set -e
set -u

# Exit on any error
set -e

echo "Updating /etc/sudoers requires sudo"

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until this script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# copy the file so it has the same attributes
sudo cp -a /etc/sudoers /etc/sudoers.vagrant

# reomve the existing auto-generated lines
sudo gsed -i '/#BEGIN-VAGRANT/,/#END-VAGRANT/d' /etc/sudoers.vagrant

# append the auto-generated lines
sudo tee -a /etc/sudoers.vagrant >/dev/null <<'EOF'
#BEGIN-VAGRANT
Cmnd_Alias VAGRANT_EXPORTS_ADD = /usr/bin/tee -a /etc/exports
Cmnd_Alias VAGRANT_NFSD = /sbin/nfsd restart
Cmnd_Alias VAGRANT_EXPORTS_REMOVE = /usr/bin/sed -E -e /*/ d -ibak /etc/exports
Cmnd_Alias VAGRANT_EXPORTS_REMOVE_LOCAL = /usr/local/bin/sed -E -e /*/ d -ibak /etc/exports
%admin ALL=(root) NOPASSWD: VAGRANT_EXPORTS_ADD, VAGRANT_NFSD, VAGRANT_EXPORTS_REMOVE, VAGRANT_EXPORTS_REMOVE_LOCAL
#END-VAGRANT
EOF

# check syntax of file
sudo visudo -c -s -f /etc/sudoers.vagrant

echo "Moving into place"
sudo mv /etc/sudoers.vagrant /etc/sudoers
