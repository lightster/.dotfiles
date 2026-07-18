ZSH_CUSTOM=~/.dotfiles/zsh

DROPBOX_HISTFILE="$HOME/Dropbox/Application Support/bash_history/${HOST}.zsh_history"
if [ -f "$DROPBOX_HISTFILE" ]; then
  HISTFILE="$DROPBOX_HISTFILE"
fi
export HISTSIZE=999999999
export SAVEHIST=$HISTSIZE

fpath=(
  "${ZSH_CUSTOM}/functions"
  "${ZSH_CUSTOM}/completions"
  $fpath
)

if [ -d "${HOME}/.docker/completions" ]; then
  fpath=("${HOME}/.docker/completions" $fpath)
fi

# these need to load before compinit
completion_plugins=(
  zsh-completions
)
for plugin in $completion_plugins; do
  plugin_file="${ZSH_CUSTOM}/plugins/${plugin}/${plugin}.plugin.zsh"
  [ -f "$plugin_file" ] && source "$plugin_file"
done

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select

setopt \
  extended_history \
  hist_expire_dups_first \
  hist_ignore_dups \
  hist_ignore_space \
  hist_verify \
  share_history

setopt correct

# use emacs mode for command input
bindkey -e

autoload -U colors && colors

SHORT_HOST=${HOST%%.*}
setopt prompt_subst

git_prompt_info() {
  local ref
  ref=$(git symbolic-ref --short HEAD 2>/dev/null) \
    || ref=$(git rev-parse --short HEAD 2>/dev/null) \
    || return 0
  if [[ -n "$(git status --porcelain 2>/dev/null)" ]]; then
    echo "${ZSH_THEME_GIT_PROMPT_PREFIX}${ref}${ZSH_THEME_GIT_PROMPT_DIRTY}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
  else
    echo "${ZSH_THEME_GIT_PROMPT_PREFIX}${ref}${ZSH_THEME_GIT_PROMPT_CLEAN}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
  fi
}

source "${ZSH_CUSTOM}/bash.zsh-theme"

autoload -Uz wt

source ~/.dotfiles/shell/common

if [ -f "/opt/homebrew/bin/terraform" ]; then
  autoload -U +X bashcompinit && bashcompinit
  complete -o nospace -C /opt/homebrew/bin/terraform terraform
fi

if command -v ngrok &>/dev/null; then
  eval "$(ngrok completion)"
fi

if command -v kubectl &>/dev/null; then
  source <(kubectl completion zsh)
fi

if command -v mise &> /dev/null; then
  eval "$(mise activate zsh)"
fi

if command -v fzf &>/dev/null; then
  source <(fzf --zsh)
fi

if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

BUOY_CERT="${HOME}/.buoy/b-com-cert.pem"
if [ -f "${BUOY_CERT}" ]; then
  export NODE_EXTRA_CA_CERTS="/Users/lightster/.buoy/b-com-cert.pem"
fi

# these need to load after compinit
interactive_plugins=(
  zsh-autosuggestions
  zsh-syntax-highlighting # keep zsh-syntax-highlighting last
)
for plugin in $interactive_plugins; do
  plugin_file="${ZSH_CUSTOM}/plugins/${plugin}/${plugin}.plugin.zsh"
  [ -f "$plugin_file" ] && source "$plugin_file"
done
