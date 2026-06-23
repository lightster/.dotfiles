# Code Style & General Principles

## Development Philosophy

- **Avoid over-engineering** - only implement what's directly requested
- Don't add features, refactoring, or "improvements" beyond the ask
- A bug fix doesn't need surrounding code cleaned up
- A simple feature doesn't need extra configurability
- Don't add docstrings, comments, or type annotations to code you didn't change
- Three similar lines of code is better than a premature abstraction

## Comments & Documentation

- **Avoid redundant comments** that just restate what code does
- Don't add comments like "// Parse date" before `time.Parse()`
- Only add comments where the logic isn't self-evident
- Explain non-obvious reasoning or complex logic, not what the code does
- **Write comments for a future reader who has only the repository** - they cannot see our conversation, the plan, or any design discussion; a comment that only makes sense with that context is worse than no comment
- **Never reference ephemeral or out-of-repo artifacts by name** - e.g. "see the Plan B' identity-model section", "as discussed", "per the plan". The reader has no way to resolve these. If a decision genuinely needs external justification, link something durable: a committed doc/ADR or a ticket number
- **Don't narrate the design process** - explain the constraint the code satisfies, not the path taken to it. "Equivalence is enforced case-insensitively at the index + ON CONFLICT layer" is a fine comment; wrapping it in references to which plan option it came from is not
- **Place a comment next to the code it describes, not a layer away** - if the behavior a comment explains is enforced elsewhere (a DB index, a migration, middleware, another function), document it there. A comment whose subject isn't in the adjacent code reads as out of place and is a signal to either move it to the enforcement site or delete it

## Error Handling

- Always check errors from conversions, database queries, and type operations
- Don't ignore errors that could indicate validation failures
- Provide user-friendly error messages, not just wrapped technical errors

## Variables & Naming

- `_` prefix is appropriate for ignored return values (Go) or unused interface parameters
- Rather than comment out or circumvent linters when unused code is detected, delete the unused code
- Use clear, descriptive names that make the code self-documenting
- Match existing naming conventions in the codebase - consistency with surrounding code takes priority over personal style

## Generated Code

- Never manually edit auto-generated code (sqlc, gqlgen, GraphQL codegen, etc.)
- If generated code needs changes, modify the source files and regenerate

## Linter Suppressions

- Use inline disable comments sparingly and always explain **why** the rule is being disabled
- Valid reasons: interface requirements, dynamic values TypeScript can't validate, dev-only code
