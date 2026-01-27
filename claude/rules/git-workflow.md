# Git Workflow

- **NEVER commit directly to `main` or `master`** - always create a feature branch and PR
- Create a feature branch: `g go descriptive-name`
- The `g go` alias automatically adds a username prefix for certain repos - do NOT add extra prefixes manually
- **Never use `git add -A` or `git add .`** without specifying files
- **Always explicitly list the files to add**: `git add file1 file2 file3`
- This prevents accidentally committing unintended changes (like local config files, temporary files, etc.)
- Note: Generated files and templates (like `.env.example`) should be committed when appropriate

## Commit Messages

- Use imperative mood for subject line: "Add feature" not "Added feature" or "Adds feature"
- Capitalize first letter of subject line
- No period at end of subject line
- Do NOT use conventional commit prefixes (feat:, fix:, chore:, etc.)
- Keep subject line concise but descriptive
- Body (when needed) should explain **why**, not just what
- When writing a body, start with the problem or business need, then describe what the changeset does
- Use bullet points (`-`) for listing multiple related changes
- **Focus on what's being committed, not the development process**: Describe the actual changes in the repository, not feedback received or iterations during development (e.g., don't mention "remove redundant comments" if those comments were never committed)
- When making multiple logical changes, break them into separate commits rather than one large commit
- When work is tied to a ticket, put the ticket number on its own line at the end of the commit message body

## Pull Requests

- Title follows commit message conventions (imperative mood, capitalized, no period)
- When project uses JIRA/ticket tracking, prefix title with ticket number: `[PROJ-123] Add feature`
- Description should explain **why** the change is being made, not just what
- Use complete sentences in paragraphs; bullet points can be concise fragments
- Use bullet points (`-`) for listing multiple related changes
- Link related issues in description when applicable (e.g., "Closes #123")
- Use sections (## Summary, ## Test Plan) for complex PRs; keep simple PRs minimal
- Focus on what's in the PR, not the development process or iterations
- Assign the PR/MR to me when creating it
- Scale description detail with complexity: simple config changes need 1-2 sentences; complex features or bug fixes warrant thorough descriptions
- For bug fixes, include root cause analysis: what was observed, what was investigated, what caused it, and how the fix addresses it
- Include testing/verification instructions for non-trivial changes — step-by-step procedures, specific records to check, or screenshots/videos as evidence
- For multi-part MR series, number them (e.g., "1 of 4") and explain the scope of each MR
- Link to external evidence (logs, traces, screenshots, videos) when it supports the description

### What NOT to Include

- **Don't list file-by-file changes** - The code diff shows exactly what changed in each file; the description should focus on outcomes and impacts, not implementation details
- **Don't document CI/CD responsibilities** - Never include items like "✅ All tests pass", "✅ Linter passes", or "✅ Build files updated" - pipelines verify these automatically
- **Don't add a Testing section for CI-verified items** - Only include Testing/Verification sections when there are **manual** steps (e.g., "verify in Datadog that spans appear", "test the UI flow by clicking X then Y")
- **Don't explain code mechanics** - Avoid describing which functions were added or which parameters changed; instead explain what capabilities were added or what behavior changed
