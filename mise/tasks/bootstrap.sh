#!/usr/bin/env bash
#MISE description="Set up this machine from scratch, pausing for manual steps"
set -Eeuo pipefail

DOTFILES="${MISE_PROJECT_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
ENV_D="$DOTFILES/config/env.d"
PLATFORM="$(uname -s)"

# Phases are "name|kind|task". An auto phase runs its mise task; a manual phase
# prints a checklist and waits.
PHASES_DARWIN=(
  "configs|auto|configs"
  "macos:minimal|auto|macos:minimal"
  "signin-core|manual|"
  "macos:packages|auto|macos:packages"
  "macos:dev-env|auto|macos:dev-env"
  "signin-apps|manual|"
  "auth|auto|auth"
  "ssh-setup|auto|ssh-setup"
  "macos:defaults|auto|macos:defaults"
  "system-prefs|manual|"
  "finalize|auto|finalize"
)

PHASES_LINUX=(
  "configs|auto|configs"
  "submodules|auto|submodules"
  "build-hooks|auto|build-hooks"
  "claude-integrations|auto|claude-integrations"
  "auth|auto|auth"
  "ssh-setup|auto|ssh-setup"
  "finalize|auto|finalize"
)

usage() {
  cat <<EOF
Usage: mise run bootstrap [--from <phase>] [--reconfigure]

  --from <phase>   start at <phase> instead of the first one
  --reconfigure    re-ask for the computer name and bundle

Phases for this machine:
EOF
  local entry
  for entry in "${PHASES[@]}"; do
    printf '  %s\n' "${entry%%|*}"
  done
}

manual_checklist() {
  case "$1" in
    signin-core)
      cat <<'EOF'
  - Sign in to 1Password and unlock the vault
  - Sign in to the Mac App Store
EOF
      ;;
    signin-apps)
      cat <<'EOF'
  - Sign in to Dropbox
  - Sign in to Google Chrome
  - Authenticate the GitHub CLI (needed for `git cl` clones):
      gh auth login --web --clipboard --git-protocol ssh --skip-ssh-key \
        --scopes "admin:ssh_signing_key,admin:public_key"
EOF
      ;;
    system-prefs)
      cat <<'EOF'
  - Work through the "System Preferences" section of README.md, plus the
    Alfred, Amphetamine, Magnet, Sublime Text and Finder sections below it.
EOF
      ;;
    *)
      echo "  (no checklist defined for $1)"
      ;;
  esac
}

load_answers() {
  if [ -r "$DOTFILES/config/env.sh" ]; then
    source "$DOTFILES/config/env.sh"
  fi
}

ask_questions() {
  local name bundle available

  read -r -p "Computer name [${DOTFILES_DEVICE_NAME:-}]: " name
  name="${name:-${DOTFILES_DEVICE_NAME:-}}"
  if [ -z "$name" ]; then
    echo "A computer name is required." >&2
    exit 1
  fi

  mkdir -p "$ENV_D"
  echo "DOTFILES_DEVICE_NAME=${name}" >"$ENV_D/hostname.local.sh"

  available=$(find "$DOTFILES/mise/conf.d" -name '*.toml' -exec basename {} .toml \; |
    sort | tr '\n' '/' | sed 's:/$::') || available=""
  read -r -p "Bundle [${available}] (blank for none): " bundle
  echo "DOTFILES_BUNDLE=${bundle}" >"$ENV_D/bundle.local.sh"

  load_answers
}

run_phase() {
  local name=$1 kind=$2 task=$3 index=$4 total=$5

  case "$kind" in
    auto)
      printf '\n▸ phase %d/%d  %s  [auto]\n' "$index" "$total" "$name"
      mise run "$task"
      ;;
    manual)
      printf '\n▸ phase %d/%d  %s  [MANUAL — do these now]\n' "$index" "$total" "$name"
      manual_checklist "$name"
      read -r -p "  press enter when done "
      ;;
  esac
}

case "$PLATFORM" in
  Darwin) PHASES=("${PHASES_DARWIN[@]}") ;;
  Linux)  PHASES=("${PHASES_LINUX[@]}") ;;
  *)
    echo "Unsupported platform: $PLATFORM" >&2
    exit 1
    ;;
esac

FROM=""
RECONFIGURE=0
while [ $# -gt 0 ]; do
  case "$1" in
    --from)
      FROM="${2:-}"
      if [ -z "$FROM" ]; then
        echo "--from requires a phase name" >&2
        exit 1
      fi
      shift 2
      ;;
    --reconfigure)
      RECONFIGURE=1
      shift
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [ -n "$FROM" ]; then
  found=0
  for entry in "${PHASES[@]}"; do
    [ "${entry%%|*}" = "$FROM" ] && found=1
  done
  if [ "$found" -eq 0 ]; then
    echo "No phase named '$FROM' on this platform." >&2
    usage >&2
    exit 1
  fi
fi

load_answers

if [ "$RECONFIGURE" -eq 1 ] || { [ -z "$FROM" ] && [ -z "${DOTFILES_DEVICE_NAME:-}" ]; }; then
  ask_questions
fi

if [ "$PLATFORM" = "Linux" ]; then
  echo "Linux: running the cross-platform phases only."
  echo "Package installation and dev-env phases are not yet defined for Linux."
fi

CURRENT_PHASE=""
on_error() {
  [ -n "$CURRENT_PHASE" ] || exit 1
  printf '\n✗ phase %s failed\n  fix it, then:  mise run bootstrap --from %s\n' \
    "$CURRENT_PHASE" "$CURRENT_PHASE" >&2
}
trap on_error ERR

total=${#PHASES[@]}
index=0
started=0
for entry in "${PHASES[@]}"; do
  index=$((index + 1))
  name="${entry%%|*}"
  rest="${entry#*|}"
  kind="${rest%%|*}"
  task="${rest#*|}"

  if [ -n "$FROM" ] && [ "$started" -eq 0 ]; then
    if [ "$name" = "$FROM" ]; then
      started=1
    else
      continue
    fi
  fi

  CURRENT_PHASE="$name"
  run_phase "$name" "$kind" "$task" "$index" "$total"
done

CURRENT_PHASE=""
printf '\n✓ done\n'
