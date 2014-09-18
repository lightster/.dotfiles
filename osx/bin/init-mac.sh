#!/bin/sh

set -e

DEFAULT_GIT_TEMPLATE="blank"
DEFAULT_SSH_REPO=".ssh"
DEFAULT_DOTFILES_REPO=".dotfiles"

echo "Install Dropbox"
echo "Install Chrome"
echo "Install 1Password"
echo "Install 1Password Extensions"

echo "Run 'xcode-select --install'"

echo "Install VirtualBox"
echo "Install Homebrew"
echo '  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"'
echo '  brew doctor'
echo "Install Vagrant"
echo "Install Sublime Text"

echo "Validating for sudo... "
sudo -v

# https://mths.be/osx
# Keep-alive: update existing `sudo` time stamp until this script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

read    -p "What name should be used when git committing? " GIT_NAME
read    -p "What email address should be used when git committing? " GIT_EMAIL
read    -p "What git commit template should be used [blank]? " GIT_TEMPLATE
read    -p "What is your GitHub username? " GITHUB_USERNAME
read -s -p "What is your GitHub 2FA token? " GITHUB_PASSWORD
echo ""
read    -p "What is the name of your '.ssh' repo [.ssh]? " SSH_REPO
read    -p "What is the name of your '.dotfiles' repo [.dotfiles]? " DOTFILES_REPO
read    -p "What do you want to name this computer (lightster-xyz)? " COMPUTER_NAME

if [ "$GIT_TEMPLATE" == "" ]; then
    GIT_TEMPLATE=$DEFAULT_GIT_TEMPLATE
fi
if [ "$SSH_REPO" == "" ]; then
    SSH_REPO=$DEFAULT_SSH_REPO
fi
if [ "$DOTFILES_REPO" == "" ]; then
    DOTFILES_REPO=$DEFAULT_DOTFILES_REPO
fi

echo ""
echo "Setting the name of the computer..."
sudo scutil --set ComputerName "${COMPUTER_NAME}"
sudo scutil --set HostName "${COMPUTER_NAME}.local"
sudo scutil --set LocalHostName "${COMPUTER_NAME}"

echo "Removing ~/.gitconfig if it exists"
rm -f ~/.gitconfig

echo "Setting the git user.name and user.email options"
git config --global user.name "${GIT_NAME}"
git config --global user.email "${GIT_EMAIL}"

echo "Setting the git push.default option to simple"
git config --global push.default simple

echo ""
echo "Creating a new SSH key..."
ssh-keygen -t rsa -f "${HOME}/.ssh/id_rsa"

echo ""
echo "Adding public key to GitHub account..."
PUB_KEY=$(cat ${HOME}/.ssh/id_rsa.pub)
echo $PUB_KEY
curl -v \
    -H "Authorization: token ${GITHUB_PASSWORD}" \
    -d "{\"title\":\"${USER}@${COMPUTER_NAME}\",\"key\":\"${PUB_KEY}\"}" \
    https://api.github.com/user/keys

echo ""
echo "Cloning the .ssh repo to ~/ssh..."
git clone "git@github.com:${GITHUB_USERNAME}/${SSH_REPO}.git" "${HOME}/ssh"
cp -a "${HOME}/.ssh/id_rsa" "${HOME}/ssh/id_rsa.${COMPUTER_NAME}"
cp -a "${HOME}/.ssh/id_rsa.pub" "${HOME}/ssh/id_rsa.${COMPUTER_NAME}.pub"
cd ~/ssh
git add "id_rsa.${COMPUTER_NAME}.pub"
git commit -m "Adding public key for ${COMPUTER_NAME}"
git push
./bin/sshk-update
cd - >/dev/null

echo ""
echo "Moving ~/.ssh to ~/.ssh-tmp"
mv ~/.ssh ~/.ssh-tmp
echo "Moving ~/ssh to ~/.ssh"
mv ~/ssh ~/.ssh

echo "Killing ssh-agent"
sudo killall ssh-agent

echo ""
echo "Cloning the .dotfiles repo to ~/.dotfiles..."
git clone "git@github.com:${GITHUB_USERNAME}/${DOTFILES_REPO}.git" "${HOME}/.dotfiles"

echo ""
echo "Setting up .dotfiles"
cd ~/.dotfiles
echo "${GIT_NAME}" >git/config.user.name
echo "${GIT_EMAIL}" >git/config.user.email
echo "${HOME}/.dotfiles" >git/config.dot.path
echo "${GIT_TEMPLATE}" >git/config.dot.commit_template
make install
cd - >/dev/null

echo ""
echo "Cleaning up"
echo "  Removing ~/.ssh-tmp"
rm -rf ~/.ssh-tmp
