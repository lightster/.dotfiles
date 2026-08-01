#!/usr/bin/env bash
#MISE description="Register the Bear MCP server with Claude Code"
set -euo pipefail

BEARCLI=/Applications/Bear.app/Contents/MacOS/bearcli

if ! command -v claude >/dev/null 2>&1 ; then
  echo "Skipping MCP setup; claude not found"
  exit 0
fi

if [ -x "$BEARCLI" ] ; then
  # Remove first so re-running does not create a duplicate server entry.
  claude mcp remove -s user bear >/dev/null 2>&1 || true
  claude mcp add -s user bear -- "$BEARCLI" mcp-server
fi
