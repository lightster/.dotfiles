#!/usr/bin/env bash

set -euo pipefail

source ~/.dotfiles/config/env.sh

REPO_DIR=~/.dotfiles
AVAILABLE_DIR="${REPO_DIR}/ssh/config.d/available"
SSH_DIR="${HOME}/.ssh"
PUBKEY_FILE="${SSH_DIR}/id_ed25519.pub"

die() {
  echo "ssh-setup: $*" >&2
  exit 1
}

case "$(uname -s)" in
  Darwin) PLATFORM="macos" ;;
  Linux)  PLATFORM="linux" ;;
  *)      die "unsupported platform: $(uname -s)" ;;
esac

mkdir -p "${SSH_DIR}"

ln -sfn "${REPO_DIR}/ssh/config" "${SSH_DIR}/config"

rm -f "${REPO_DIR}/git/config.d/signing-1password.local.gitconfig"

if [ "${PLATFORM}" = "macos" ]; then
  VAULT="Private"
  ITEM="ssh-${DOTFILES_DEVICE_NAME}"

  if ! op item get "${ITEM}" --vault "${VAULT}" >/dev/null 2>&1; then
    op item create --category ssh --title "${ITEM}" --vault "${VAULT}" --ssh-generate-key ed25519
  fi
  op read "op://${VAULT}/${ITEM}/public key" > "${PUBKEY_FILE}"

  ln -sfn "${AVAILABLE_DIR}/80-agent-1password.conf" "${REPO_DIR}/ssh/config.d/80-agent.local.conf"
  ln -sfn "${REPO_DIR}/git/config.d/available/signing-1password.gitconfig" "${REPO_DIR}/git/config.d/signing-1password.local.gitconfig"
else
  if [ ! -f "${SSH_DIR}/id_ed25519" ]; then
    ssh-keygen -t ed25519 -f "${SSH_DIR}/id_ed25519" -N "" -C "${DOTFILES_DEVICE_NAME}"
  fi
  chmod 600 "${SSH_DIR}/id_ed25519"

  mkdir -p "${HOME}/.config/systemd/user"
  ln -sfn "${REPO_DIR}/ssh/systemd/ssh-agent.service" "${HOME}/.config/systemd/user/ssh-agent.service"
  systemctl --user daemon-reload
  systemctl --user enable --now ssh-agent.service

  SOCK="${XDG_RUNTIME_DIR}/ssh-agent.sock"
  if ! SSH_AUTH_SOCK="${SOCK}" ssh-add -l 2>/dev/null | grep -qF "${DOTFILES_DEVICE_NAME}"; then
    SSH_AUTH_SOCK="${SOCK}" ssh-add "${SSH_DIR}/id_ed25519"
  fi

  ln -sfn "${AVAILABLE_DIR}/80-agent-linux.conf" "${REPO_DIR}/ssh/config.d/80-agent.local.conf"
fi

chmod 644 "${PUBKEY_FILE}"

read -r KEYTYPE KEYDATA _ < "${PUBKEY_FILE}"

gh_key_registered() {
  local KEY="$1"
  local TYPE="$2"

  gh ssh-key list 2>/dev/null | grep -F "${KEY}" | grep -qF "${TYPE}"
}

if ! gh_key_registered "${KEYDATA}" "authentication"; then
  gh ssh-key add "${PUBKEY_FILE}" --title "${DOTFILES_DEVICE_NAME}" --type authentication
fi

if ! gh_key_registered "${KEYDATA}" "signing"; then
  gh ssh-key add "${PUBKEY_FILE}" --title "${DOTFILES_DEVICE_NAME}-sign" --type signing
fi
