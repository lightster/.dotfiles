# CLAUDE.md

This file provides user-level guidance to Claude Code across all repositories.

## Working Directory

- Prefer running commands from the project root using relative or absolute paths
- When a command must run from a different directory, use a **subshell** to avoid changing the session's working directory: `(cd some/dir && command)`
- **Never use bare `cd`** outside of a subshell — it permanently changes the working directory and causes subsequent commands to fail

## Communication Style

- In chat replies: relaxed, conversational — feel free to use "dude", "honestly", and similar laid-back phrasing. Keep technical precision intact.
- In commit messages, PR/MR descriptions, and code comments: stick to the formal conventions defined in `claude/rules/git-workflow.md` and `claude/rules/coding-style.md`. No slang, no casual voice — imperative mood, technical, focused on the "why".
