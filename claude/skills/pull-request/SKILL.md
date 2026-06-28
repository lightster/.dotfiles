---
name: pull-request
description: Write or revise a pull request or merge request title and description in Matt's voice. Use this whenever creating a PR or MR (including before running `gh pr create` or `glab mr create`), or when asked to align, clean up, or rewrite an existing PR/MR description, so the title and description sound like Matt wrote them instead of generic, impersonal, AI-generated boilerplate.
---

Write a pull request (GitHub) or merge request (GitLab) title and description that read
like Matt wrote them. This covers two cases:

- **Creating** a new PR/MR from the current branch.
- **Revising** an existing PR/MR's description to align it with these guidelines —
  including when another session is asked to clean up a description after the fact.

Follow the steps in order; step 2 and step 4 branch on which case you are in.

## 1. Detect platform and context

Read the remote to decide the tooling and the context knobs:

- `git remote -v` — host tells you the platform:
  - `github.com` → GitHub, create with `gh pr create`
  - a GitLab host (e.g. `gitlab.atticus.com`) → GitLab, create with `glab mr create`
- The remote path / checkout directory tells you the org context (`personal`,
  `tinyprint`, `atticus`). Apply the matching row from the knobs table below.

| Context | Platform | Ticket prefix | Notes |
|---|---|---|---|
| personal | GitHub | none | Loosest. Plain prose, can be a single sentence. |
| tinyprint | GitHub | none | Disciplined prose, why-first. This is the baseline voice. |
| atticus | GitLab | `[PROJ-123] ` when work ties to a JIRA ticket | "MR" not "PR" in prose; create with `glab`. |

If detection is ambiguous, ask which context applies rather than guessing.

## 2. Gather the change

Run in parallel:
- `git log <base>..HEAD --oneline` (and full `git log <base>..HEAD` for messages) — what the branch actually does
- `git diff <base>...HEAD --stat` then targeted `git diff` — the real change

Determine `<base>` from the branch you branched from. The Claude Code
context is probably the best raw material but the commit messages can also be
useful. The PR description is the same story told once, at the right altitude.

**When revising an existing PR/MR**, also read its current title and description first
so you preserve any genuinely useful content and only fix what is off-voice:
- GitHub: `gh pr view <number> --json title,body`
- GitLab: `glab mr view <id>`

## 3. Draft the title and description

Read `voice.md` (how Matt writes) and `examples.md` (real PRs to pattern-match) in
this skill's directory, then draft.

- **Title:** imperative, capitalized, no period, and concrete — name the change like the
  example titles and make sure it reads as a complete phrase. Prefix with the ticket for
  atticus when applicable (`[PROJ-123] Add feature`).
- **Description:** lead with the *why* — the business need or current-state problem —
  then what the change does. Default to plain prose scaled to the change (often 1–3
  sentences). Reach for structure (a `## Verification` block, bullet lists) only when
  the change genuinely earns it. Match the voice guide and examples exactly; the point
  of this skill is that the result does NOT read like generic AI output.
- After drafting, cut every sentence the diff already makes self-evident — restated
  changes, CI-verified work (no `✅ Tests pass`), and mechanical or secondary changes that
  explain themselves. Being in the PR doesn't earn a sentence. Add a Verification section
  only for genuinely manual steps.
- Don't explain interim decisions we made in the branch but later changed our mind on.
- For bug fixes, include root cause: what was observed, what caused it, how the fix addresses it.


## 4. Create or update the PR / MR

First, show Matt the drafted title and description and **wait for his explicit
go-ahead**. This is a hard stop — do not run any `gh` or `glab` command until he
approves; he may want to adjust the wording first. Once he confirms, create or update
depending on the case:

**Creating a new PR/MR** — assign it to Matt:
- GitHub: `gh pr create --title "..." --body "..." --assignee @me`
- GitLab: `glab mr create --title "..." --description "..." --assignee @me`

**Revising an existing PR/MR** — update only the title and description; leave assignee,
reviewers, and labels as they are:
- GitHub: `gh pr edit <number> --title "..." --body "..."`
- GitLab: `glab mr update <id> --title "..." --description "..."`

Never add a "Generated with Claude Code" footer to the description.
