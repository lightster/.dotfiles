# CLAUDE.md

This file provides user-level guidance to Claude Code across all repositories.

## Git Workflow

- **NEVER commit directly to `main` or `master`** - always create a feature branch and PR
- Create a feature branch: `g go descriptive-name`
- **Never use `git add -A` or `git add .`** without specifying files
- **Always explicitly list the files to add**: `git add file1 file2 file3`
- This prevents accidentally committing unintended changes (like local config files, temporary files, etc.)
- Note: Generated files and templates (like `.env.example`) should be committed when appropriate

### Commit Messages
- Use imperative mood for subject line: "Add feature" not "Added feature" or "Adds feature"
- Capitalize first letter of subject line
- No period at end of subject line
- Do NOT use conventional commit prefixes (feat:, fix:, chore:, etc.)
- Keep subject line concise but descriptive
- Body (when needed) should explain **why**, not just what
- Use bullet points (`-`) for listing multiple related changes
- **Focus on what's being committed, not the development process**: Describe the actual changes in the repository, not feedback received or iterations during development (e.g., don't mention "remove redundant comments" if those comments were never committed)

### Pull Requests
- Title follows commit message conventions (imperative mood, capitalized, no period)
- When project uses JIRA/ticket tracking, prefix title with ticket number: `[PROJ-123] Add feature`
- Description should explain **why** the change is being made, not just what
- Use bullet points (`-`) for listing multiple related changes
- Link related issues in description when applicable (e.g., "Closes #123")
- Use sections (## Summary, ## Test Plan) for complex PRs; keep simple PRs minimal
- Focus on what's in the PR, not the development process or iterations

## Code Style & General Principles

### Development Philosophy
- **Avoid over-engineering** - only implement what's directly requested
- Don't add features, refactoring, or "improvements" beyond the ask
- A bug fix doesn't need surrounding code cleaned up
- A simple feature doesn't need extra configurability
- Don't add docstrings, comments, or type annotations to code you didn't change
- Three similar lines of code is better than a premature abstraction

### Comments & Documentation
- **Avoid redundant comments** that just restate what code does
- Don't add comments like "// Parse date" before `time.Parse()`
- Only add comments where the logic isn't self-evident
- Explain non-obvious reasoning or complex logic, not what the code does

### Error Handling
- Always check errors from conversions, database queries, and type operations
- Don't ignore errors that could indicate validation failures
- Provide user-friendly error messages, not just wrapped technical errors

### Variables & Naming
- `_` prefix is appropriate for ignored return values (Go) or unused interface parameters
- Rather than comment out or circumvent linters when unused code is detected, delete the unused code
- Use clear, descriptive names that make the code self-documenting

### Working Directory
- Prefer running commands from the project root directory
- Avoid changing directories (`cd`) as it can cause loss of context
- Most commands can be run with paths from the root directory

### Generated Code
- Never manually edit auto-generated code (sqlc, gqlgen, GraphQL codegen, etc.)
- If generated code needs changes, modify the source files and regenerate

### Linter Suppressions
- Use inline disable comments sparingly and always explain **why** the rule is being disabled
- Valid reasons: interface requirements, dynamic values TypeScript can't validate, dev-only code

## Plan Documentation

When implementing a feature branch using plan mode:
1. After completing the implementation, copy the plan file to `docs/claude-plans/` with a descriptive name
2. Example: Plan for handling pre-created moments → `docs/claude-plans/handle-pre-created-moments.md`
3. Commit the plan documentation along with the feature changes
4. This provides context for future developers and PR reviewers
