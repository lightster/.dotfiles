---
name: commit
description: Stage and commit changes with a reviewed commit message
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git add:*)
---

Create a git commit for the current changes. Follow these steps exactly:

## 1. Gather context

Run these in parallel:
- `git status` (never use `-uall`)
- `git diff` (staged and unstaged)
- `git log --oneline -5`

## 2. Draft a commit message

Analyze the changes and write a commit message following these rules:
- Imperative mood subject line: "Add feature" not "Added feature"
- Capitalize first letter, no period at end
- No conventional commit prefixes (feat:, fix:, chore:, etc.)
- Body (when needed) explains **why**, not what
- Start the body with the problem or business need
- Use `-` bullet points for listing multiple related changes
- Focus on what's being committed, not the development process
- End with: `Co-Authored-By: Claude <noreply@anthropic.com>`

## 3. Commit

- Stage files explicitly (never `git add -A` or `git add .`)
- Commit using a HEREDOC for the message
- Run `git status` to verify
