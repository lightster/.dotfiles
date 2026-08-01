#!/usr/bin/env bash
#MISE description="Install Rosetta, the brew bundles, and the mise tools"
set -euo pipefail

DOTFILES="${MISE_PROJECT_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)}"
source "$DOTFILES/config/env.sh"

BUNDLE="${DOTFILES_BUNDLE:-}"

/usr/sbin/softwareupdate --install-rosetta --agree-to-license

brew bundle --file "$DOTFILES/macos/brew/core.brewfile"
if [ -n "$BUNDLE" ] && [ -f "$DOTFILES/macos/brew/$BUNDLE.brewfile" ]; then
  brew bundle --file "$DOTFILES/macos/brew/$BUNDLE.brewfile"
fi

mise install
