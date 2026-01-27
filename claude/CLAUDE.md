# CLAUDE.md

This file provides user-level guidance to Claude Code across all repositories.

## Working Directory

- Prefer running commands from the project root directory
- Avoid changing directories (`cd`) as it can cause loss of context
- Most commands can be run with paths from the root directory

## Plan Documentation

When implementing a feature branch using plan mode:
1. After completing the implementation, copy the plan file to `docs/claude-plans/` with a descriptive name
2. Example: Plan for handling pre-created moments → `docs/claude-plans/handle-pre-created-moments.md`
3. Commit the plan documentation along with the feature changes
4. This provides context for future developers and PR reviewers
