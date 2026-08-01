#!/usr/bin/env bash
#MISE description="Authenticate the CLIs that need per-machine credentials"
set -euo pipefail

if command -v td >/dev/null 2>&1 && ! td auth status >/dev/null 2>&1 ; then
  echo "td is not authenticated. Copy your API token from"
  echo "  https://app.todoist.com/app/settings/integrations/developer"
  read -r -s -p "  token: " todoist_token
  echo

  if [ -n "$todoist_token" ]; then
    td auth token "$todoist_token"
  else
    echo "  no token entered; skipping"
  fi
fi
