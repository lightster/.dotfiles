# Matt's PR/MR Voice

This guide describes how Matt writes pull and merge request descriptions, distilled
from the real PRs in `examples.md`. The goal is that a reader cannot tell whether Matt
or a tool wrote it. When in doubt, the examples are the ground truth and this guide is
the explanation; match the examples.

## The shape of a description

Most descriptions follow the same arc:

1. **Open with the why.** The first sentence establishes the reason the change exists.
   It takes one of a few forms:
   - the need ahead of it — "The Durian API is going to send sign-in emails through
     Postmark and needs `POSTMARK_SERVER_TOKEN` and `EMAIL_FROM_ADDRESS` set" (Ex 1);
   - the current-state pain — "Our test suite has been using the stdlib and relying on
     conditionals + `t.Fatal*` to make assertions" (Ex 5);
   - the history that no longer fits — "When we originally brought the tinyprint.dev
     zone ... under OpenTofu management, we were only thinking about managing one
     domain ... We have since realized that we are going to want to manage multiple
     domains" (Ex 3);
   - the broader effort this is part of — "We are developing authentication for the
     Durian API across multiple PRs that are independently deployable and manually
     testable" (Ex 4).
2. **Pivot to what the change does with "This PR ..." / "This MR ...".** This is the
   hinge, and Matt uses it deliberately: "This PR introduces managing Heroku App
   environment variables ...", "This PR moves all of tinyprint.dev's zone and DNS
   configuration into one file", "This MR moves all assertions over to testify ...". The
   why comes first; the "This PR ..." sentence then says plainly what happened.
3. **Describe at the level of behavior and outcomes**, naming the specific endpoints,
   files, env vars, and packages that matter (in backticks) — not a file-by-file recap
   of the diff.
4. **State the boundaries and deferrals plainly.** Say what is intentionally left out
   and what comes later: "Existing Heroku App environment variables are left untouched"
   (Ex 1), "The verify endpoint logs the verified identity but does not yet implement
   session functionality. Session creation will come in a future PR" (Ex 4).
5. **Justify the non-obvious decisions, including the road not taken.** When something
   is done a particular way, the reason is in the description, and Matt names the
   alternative he rejected: "We could move around the interfaces to avoid this import
   cycle, but these mocks are going to go away once we finish implementing email-code
   authentication, sessions, etc." (Ex 5).

## What earns a place

A description carries what the diff cannot: the why, the non-obvious reasoning, the
boundaries, and how to verify. Since the diff already shows what changed, a sentence
belongs only if the reviewer needs it beyond scrolling the diff. Cut anything
self-evident — including mechanical or secondary changes that are part of the PR but
explain themselves (a flag flipped, a config value allowlisted, a dependency bumped).
Being in the PR is not enough to earn a sentence; default to the shortest description
that still carries the why.

## Voice characteristics

- **First person, team voice.** "we", "our", and "I" all appear naturally — "I bought
  `durian.page`" (Ex 2), "we are developing authentication" (Ex 4), "we have since
  realized" (Ex 3). Don't force it and don't scrub it out.
- **Conversational but technical.** Plain connectors carry the reasoning — "so that",
  "since", "rather than continuing down that road", "but". Mildly informal turns of
  phrase are authentic and should stay ("going to be awkward", "on my local"); precision
  is never sacrificed for them.
- **Backticks around concrete things** — identifiers, env var names, file names,
  endpoints, package names, commands, and values.
- **Cross-reference related work** by `org/repo#NN` when this PR depends on or relates to
  another (Ex 4 references `tinyprint/infra#13`).
- **Length scales to the change.** A config or DNS change is one short paragraph (Ex 1,
  Ex 2). A structural refactor narrates original decision → why it no longer fits →
  the change (Ex 3). A feature or migration runs a paragraph or two plus earned sections
  (Ex 4, Ex 5).

## Sections

Headings are earned and specific, never generic. Two recur:

- **`## Dependencies`** — when the PR relies on other work or configuration to function,
  spell it out and cross-reference it (Ex 4).
- **`## Verification`** — when CI does not already cover it. Matt narrates how *he*
  tested it, in first person, then lists the concrete, copy-pasteable steps: "I tested
  that the send and verify functionalities work by:" (Ex 4), "We do not yet have the
  tests running in CI, so I verified the tests still run on my local by running:" (Ex 5).
  Give the exact `curl`, `psql`, `docker compose`, and `go test` invocations — not vague
  instructions.

## Anti-tells — never do these

These are the marks of generic AI-generated PRs. Their absence is the point.

- No generic boilerplate headings — `## Summary`, `## Overview`, `## Changes`,
  `## Additional information`. If a section earns a heading, name it for what it is
  (`## Dependencies`, `## Verification`).
- No checklists or status checkmarks (`✅ Tests pass`, `✅ Lint clean`) — CI owns those.
- No file-by-file enumeration and no restating the diff. Describe behavior and outcomes,
  and name only the specifics that matter.
- Don't narrate interim decisions made during the branch's development that were later
  reversed; describe what is actually being committed.
- No tangential future-work notes beyond the deliberate "comes in a future PR" deferrals
  that scope the current change.
- No "🤖 Generated with Claude Code" footer on the description. (The `Co-Authored-By`
  trailer on commits is kept; the PR/MR description byline is not.)
