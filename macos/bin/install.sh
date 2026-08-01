#!/bin/bash

set -e

if [ ! -d ~/.dotfiles ]; then
    echo ""
    echo "cloning .dotfiles"
    git clone https://github.com/lightster/.dotfiles.git ~/.dotfiles
    echo "done cloning .dotfiles"
else
    echo ".dotfiles already cloned"
fi


if ! command -v mise &>/dev/null; then
    echo ""
    echo "installing mise"
    curl https://mise.run | sh
fi
MISE="$(command -v mise || echo "$HOME/.local/bin/mise")"

echo ""
# green checkmarks
echo -e "\033[0;32m\xE2\x9C\x94\xE2\x9C\x94\xE2\x9C\x94\033[0m"

(cd ~/.dotfiles && "$MISE" run bootstrap)
