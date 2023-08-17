# Path to your oh-my-zsh installation.
export ZSH="/Users/lightster/.oh-my-zsh"

# oh-my-zsh options
ZSH_THEME="bash"
DISABLE_LS_COLORS="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyyy-mm-dd"
ZSH_CUSTOM=~/.dotfiles/zsh

plugins=(
)

# shell options that need to be set before including oh-my-zsh
DROPBOX_HISTFILE="$HOME/Dropbox/Application Support/bash_history/${HOST}.zsh_history"
if [ -f "$DROPBOX_HISTFILE" ]; then
  HISTFILE="$DROPBOX_HISTFILE"
fi

fpath=(
  "${ZSH_CUSTOM}/completions"
  "/Users/lightster/.zsh-completions/src"
  $fpath
)

source $ZSH/oh-my-zsh.sh

source ~/.dotfiles/shell/common

WB_AC_ZSH_SETUP_PATH=~/Library/Caches/@workboard/wb-cli/autocomplete/zsh_setup
if [ -f "$WB_AC_ZSH_SETUP_PATH" ]; then
  source "$WB_AC_ZSH_SETUP_PATH"
fi

# remove oh-my-zsh's LSCOLORS and let Terminal.app's color theme handle ls colors
unset LSCOLORS
export CLICOLOR=1
export CLICOLOR_FORCE=1

unsetopt correct_all
setopt correct

# pnpm
export PNPM_HOME="/Users/lightster/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end
