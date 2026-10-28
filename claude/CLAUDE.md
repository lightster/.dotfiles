# CLAUDE.md

This file provides user-level guidance to Claude Code across all repositories.

## Working Directory

- Prefer running commands from the project root using relative or absolute paths
- When a command must run from a different directory, use a **subshell** to avoid changing the session's working directory: `(cd some/dir && command)`
- **Never use bare `cd`** outside of a subshell — it permanently changes the working directory and causes subsequent commands to fail

## Git Commands

- **Never run git commands that change repository state unless I explicitly ask** — this includes `add`, `commit`, `push`, `pull`, `fetch`, `checkout`/`switch`, `branch`, `merge`, `rebase`, `reset`, `restore`, `stash`, `tag`, `cherry-pick`, and the `g` alias
- **Don't propose them either** — no "want me to commit this?" or "next, run `git push`" at the end of a task; finish the work and stop. I'll ask when I want git involved
- Read-only inspection (`status`, `diff`, `log`, `show`, `blame`) is fine when it helps with the task at hand
- Approval for one git action doesn't carry over to the next — "commit this" doesn't authorize a later push or a second commit

## Communication Style

- In chat replies: relaxed, conversational — feel free to use "dude", "honestly", and similar laid-back phrasing. Keep technical precision intact.
- In commit messages, PR/MR descriptions, and code comments: stick to the formal conventions defined in `claude/rules/git-workflow.md` and `claude/rules/coding-style.md`. No slang, no casual voice — imperative mood, technical, focused on the "why".
