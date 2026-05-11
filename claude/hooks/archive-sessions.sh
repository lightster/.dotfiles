#!/usr/bin/env bash
# Mirror ~/.claude/projects/ to an iCloud Drive archive so session JSONL
# files outlive the cleanupPeriodDays window. Append-only mirror — never
# deletes from the archive.
#
# Exit code 2 on failure: Claude surfaces stderr as a system message at
# session start so the user can't miss a broken archive, but the session
# still proceeds. Every failure is also appended to
# ~/.claude/archive-errors.log for postmortem.
#
# No file locking: macOS doesn't ship with flock, and locking isn't
# required for correctness here — openrsync's per-file temp+rename is
# atomic and source JSONLs are append-only, so concurrent SessionStart
# hooks (rare in practice) converge to a correct end state.
set -u
set -o pipefail

SRC="$HOME/.claude/projects/"
DST="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Application Support/claude/projects/"
ERRLOG="$HOME/.claude/archive-errors.log"

mkdir -p "$DST"

# Quoting matters: "Application Support" contains a space. The "~" chars
# in "com~apple~CloudDocs" are literal U+007E characters, not home-dir
# expansion (safe because $DST is double-quoted at every use site).
if ! rsync_err=$(rsync -a "$SRC" "$DST" 2>&1); then
  ts=$(date -u +'%Y-%m-%dT%H:%M:%SZ')
  printf '[%s] archive-sessions: rsync failed\n%s\n' "$ts" "$rsync_err" >>"$ERRLOG"
  printf 'archive-sessions: rsync to iCloud archive FAILED. See %s\n%s\n' \
    "$ERRLOG" "$rsync_err" >&2
  exit 2
fi
