#!/usr/bin/env bash
#MISE description="Install Homebrew, the minimal bundle, and set the computer name"
set -euo pipefail

DOTFILES="${MISE_PROJECT_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)}"
source "$DOTFILES/config/env.sh"

if [ -z "${DOTFILES_DEVICE_NAME:-}" ]; then
  echo "DOTFILES_DEVICE_NAME is not set. Run 'mise run bootstrap' to configure it." >&2
  exit 1
fi

if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  brew update
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# prevent `brew doctor` from complaining about missing path in PATH
export PATH="/opt/homebrew/sbin:$PATH"

brew doctor
brew bundle --file "$DOTFILES/macos/brew/minimal.brewfile"

echo ""
echo -n "setting name of computer... "
sudo scutil --set ComputerName "${DOTFILES_DEVICE_NAME}"
sudo scutil --set HostName "${DOTFILES_DEVICE_NAME}.local"
sudo scutil --set LocalHostName "${DOTFILES_DEVICE_NAME}"
echo "done setting name of computer"
