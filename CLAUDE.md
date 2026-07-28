# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Shell Script Style

- Use `source` instead of `.` for sourcing files
- Use conditional checks with silent failures for optional tools:
  ```bash
  if command -v tool &>/dev/null; then
    eval "$(tool init)"
  fi
  ```

## Configuration Philosophy

- Remove configuration for tools you're not actively using - add back only when needed
- When a tool might not be installed on all machines, check for its existence before loading
- Prefer silent failures over error messages for optional tools
- Deduplicate configuration before adding new entries - check if similar config already exists
