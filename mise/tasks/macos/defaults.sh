#!/usr/bin/env bash
#MISE description="Apply macOS defaults: Terminal theme, iTerm2 prefs, dock"
set -euo pipefail

DOTFILES="${MISE_PROJECT_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)}"

bash "$DOTFILES/macos/bin/init-mac-more.sh"
