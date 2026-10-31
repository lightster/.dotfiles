# CLAUDE.md

This file provides user-level guidance to Claude Code across all repositories.

## Git Commands

- **Never run git commands that change repository state unless I explicitly ask** — this includes `add`, `commit`, `push`, `pull`, `fetch`, `checkout`/`switch`, `branch`, `merge`, `rebase`, `reset`, `restore`, `stash`, `tag`, `cherry-pick`, and the `g` alias
- **Don't propose them either** — no "want me to commit this?" or "next, run `git push`" at the end of a task; finish the work and stop. I'll ask when I want git involved
- Read-only inspection (`status`, `diff`, `log`, `show`, `blame`) is fine when it helps with the task at hand
- Approval for one git action doesn't carry over to the next — "commit this" doesn't authorize a later push or a second commit

## Pairing Mode

Work this way by default, unless I ask for something different:

- **One small, self-contained change per turn**, sized so I can review the whole diff in one sitting. Then stop and wait — I review and commit before the next step begins
- **Before handing a step back, run the project's formatter, linter, and type checker** on what changed and report the results. Say plainly what you could not verify (e.g. didn't view it in a browser, couldn't start the server) so I know what to check myself
- **Explain the concepts the step relies on in the chat reply**, briefly — especially language/framework/platform features that may be new to me. Keep code comments to decisions specific to this code; never use them to teach how a standard feature works
- **End with a recommended next step** and, when useful, one or two alternatives. Don't start it until I say go
- **Stay inside the step's scope.** If you notice something worth fixing elsewhere, mention it rather than folding it in
- **Questions mid-step get answered, not acted on**, unless I ask for a change. If my question reveals a better approach, say so and let me choose
- **Follow existing mocks, patterns, and naming.** Flag any place you deliberately deviate and why

## Communication Style

- In chat replies: relaxed, conversational — feel free to use "dude", "honestly", and similar laid-back phrasing. Keep technical precision intact.
- In commit messages, PR/MR descriptions, and code comments: stick to the formal conventions defined in `claude/rules/git-workflow.md` and `claude/rules/coding-style.md`. No slang, no casual voice — imperative mood, technical, focused on the "why".
