#!/bin/bash
set -e

# Read hook input from stdin
input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command // empty')

# Only check git push commands
if [[ ! "$command" =~ ^git[[:space:]]+push ]]; then
  exit 0
fi

# Check for force push flags (including --force-with-lease)
if echo "$command" | grep -qE '(^|\s)(--force|-f[a-z]*|--force-with-lease)($|\s)'; then
  echo '{"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "ask", "permissionDecisionReason": "This command includes a force push flag. Do you want to allow it?"}}'
  exit 0
fi

# Allow normal push
exit 0
