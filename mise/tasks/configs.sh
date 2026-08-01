#!/usr/bin/env bash
#MISE description="Symlink dotfiles into $HOME"
set -euo pipefail

DOTFILES="${MISE_PROJECT_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
source "$DOTFILES/config/env.sh"

mkdir -p ~/.tmp ~/.gnupg ~/.claude ~/.config/zellij ~/.config/mise/conf.d

ln -sfn "$DOTFILES"/git/gitconfig ~/.gitconfig
ln -sfn "$DOTFILES"/macos/psqlrc ~/.psqlrc
ln -sfn "$DOTFILES"/vim/vimrc ~/.vimrc
ln -sfn "$DOTFILES"/vim/ctags ~/.ctags
ln -sfn "$DOTFILES"/tmux.conf ~/.tmux.conf
ln -sfn "$DOTFILES"/zellij/config.kdl ~/.config/zellij/config.kdl
ln -sfn "$DOTFILES"/zellij/layouts ~/.config/zellij/layouts
ln -sfn "$DOTFILES"/mise/global.toml ~/.config/mise/config.toml
ln -sfn "$DOTFILES"/mise/try-me.toml ~/.config/mise/conf.d/try-me.toml
ln -sfn "$DOTFILES"/zshrc ~/.zshrc
ln -sfn "$DOTFILES"/claude/settings.json ~/.claude/settings.json
ln -sfn "$DOTFILES"/claude/CLAUDE.md ~/.claude/CLAUDE.md
ln -sfn "$DOTFILES"/claude/rules ~/.claude/rules
ln -sfn "$DOTFILES"/claude/hooks ~/.claude/hooks
ln -sfn "$DOTFILES"/claude/skills ~/.claude/skills

BUNDLE="${DOTFILES_BUNDLE:-}"

if [ -n "$BUNDLE" ] && [ -f "$DOTFILES/mise/conf.d/$BUNDLE.toml" ]; then
  ln -sfn "$DOTFILES/mise/conf.d/$BUNDLE.toml" ~/.config/mise/conf.d/"$BUNDLE".toml
fi

if [ -n "$BUNDLE" ] && [ -f "$DOTFILES/claude/rules.d/$BUNDLE.md" ]; then
  ln -sfn "$DOTFILES/claude/rules.d/$BUNDLE.md" ~/.claude/rules/"$BUNDLE".d.md
fi
