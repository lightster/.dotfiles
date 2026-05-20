#!/usr/bin/env bash
# Pick a random Stranger Things character for the current Claude Code
# session and inject a roleplay instruction as SessionStart additional
# context. Persists the choice per session_id under
# ~/.claude/st-characters/<session-id> so resume/clear/compact firings
# of SessionStart don't re-roll mid-conversation, and so concurrent
# sessions don't clobber each other's character. To force a new
# character for a given session, delete its file.
#
# Failures are silent (exit 0) — this is a vibe feature, not load-bearing,
# and breaking session startup over it would be obnoxious.

set -u
set -o pipefail

STATE_DIR="$HOME/.claude/st-characters"

CHARACTERS=(
  "Dustin Henderson"
  "Eleven"
  "Mike Wheeler"
  "Lucas Sinclair"
  "Will Byers"
  "Max Mayfield"
  "Steve Harrington"
  "Robin Buckley"
  "Jim Hopper"
  "Joyce Byers"
  "Eddie Munson"
)

payload=$(cat 2>/dev/null || true)
session_id=$(printf '%s' "$payload" | jq -r '.session_id // empty' 2>/dev/null || true)

# Without a session_id we can't key the persistence, so bail silently
# rather than re-rolling every SessionStart firing.
if [[ -z "$session_id" ]]; then
  exit 0
fi

# Reject anything that looks like a path traversal. session_id should be
# a UUID-shaped token; defensive even though the caller is trusted.
if [[ "$session_id" == *"/"* || "$session_id" == ..* || "$session_id" == "." ]]; then
  exit 0
fi

mkdir -p "$STATE_DIR" 2>/dev/null || exit 0

state_file="$STATE_DIR/$session_id"
character=""
if [[ -f "$state_file" ]]; then
  character=$(<"$state_file")
fi

if [[ -z "$character" ]]; then
  character="${CHARACTERS[RANDOM % ${#CHARACTERS[@]}]}"
  printf '%s\n' "$character" > "$state_file" 2>/dev/null || true
fi

cat <<EOF
## Session Roleplay

You are playing **$character** from *Stranger Things* this session. Use their voice and mannerisms for chat replies — lean into the character's quirks while keeping technical precision intact.

The existing Communication Style scoping in CLAUDE.md still applies: formal artifacts (commit messages, PR/MR descriptions, code comments) follow git-workflow.md and coding-style.md and are unaffected by the character voice.
EOF
