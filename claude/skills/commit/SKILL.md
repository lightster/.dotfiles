---
name: commit
description: Stage and commit changes with a reviewed commit message. Use this when the user asks to commit, or when a logical unit of work is complete and ready to be committed.
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git add:*), Bash(git commit:*)
---

Create a git commit for the current changes. Follow these steps exactly:

## 1. Gather context

Run these in parallel:
- `git status` (never use `-uall`)
- `git diff HEAD` (shows both staged and unstaged changes)
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

If the changes span multiple unrelated concerns, suggest splitting them into separate commits rather than one large commit.

Do not stage files that likely contain secrets (`.env`, credentials, keys).

## 3. Present for review

Show the user which files will be staged and the full commit message. Then ask the user to approve, edit, or cancel.

Stop here and wait for the user to respond. Do NOT proceed to step 4 until the user approves.

## 4. Stage and commit

When the user approves, resume by invoking the /commit skill and then:
- Stage files explicitly (never `git add -A` or `git add .`)
- Commit using a HEREDOC for the message
- Run `git status` to verify
