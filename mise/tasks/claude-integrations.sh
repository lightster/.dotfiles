#!/usr/bin/env bash
#MISE description="Wire up the Claude Code MCP servers and agent skills"
set -euo pipefail

BEARCLI=/Applications/Bear.app/Contents/MacOS/bearcli

if ! command -v claude >/dev/null 2>&1 ; then
  echo "Skipping Claude integrations; claude not found"
  exit 0
fi

if [ -x "$BEARCLI" ] && ! claude mcp get bear >/dev/null 2>&1 ; then
  claude mcp add -s user bear -- "$BEARCLI" mcp-server
fi

if command -v td >/dev/null 2>&1 ; then
  td skill install claude-code --force
fi
