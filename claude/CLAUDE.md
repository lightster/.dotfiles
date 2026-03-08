# CLAUDE.md

This file provides user-level guidance to Claude Code across all repositories.

## Working Directory

- Prefer running commands from the project root using relative or absolute paths
- When a command must run from a different directory, use a **subshell** to avoid changing the session's working directory: `(cd some/dir && command)`
- **Never use bare `cd`** outside of a subshell — it permanently changes the working directory and causes subsequent commands to fail

## Plan Documentation

When implementing a feature branch using plan mode:
1. After completing the implementation, copy the plan file to `docs/claude-plans/` with a descriptive name
2. Example: Plan for handling pre-created moments → `docs/claude-plans/handle-pre-created-moments.md`
3. Commit the plan documentation along with the feature changes
4. This provides context for future developers and PR reviewers
