# Replace the Makefile with mise tasks — design

Status: designed, not implemented.

## Goal

Retire the `Makefile` in favor of mise tasks, and restructure the machine bootstrap
into named phases that can be re-run individually, resumed after a failure, and
extended to Linux without inventing Linux's flow up front.

The Makefile has four problems that motivated this:

- `make all` has never worked. It depends on an `app-store` target that does not
  exist, so the target dies after `configs` and before `pretty` and `done`. The README
  works around it by telling you to run the tail end by hand.
- Bootstrap logic is split between the Makefile and `macos/bin/*.sh` with no clear
  rule for which lives where.
- The automated and manual steps of a fresh-machine setup are interleaved in the
  README with no way to run "everything automatic up to the next manual step".
- mise already owns the tool layer, so `make` is a second runner earning its keep on
  one target.

## Decisions (settled during brainstorming)

1. **`mise/tasks/` holds file tasks.** Verified discovered by mise 2026.7.2, alongside
   `.mise/tasks/` and `.config/mise/tasks/`. `mise-tasks/` is *not* discovered by this
   version. `mise/tasks/` keeps everything mise-related under the existing `mise/`
   folder rather than adding a top-level dot-directory.
2. **File tasks use a `.sh` extension.** mise strips known extensions when deriving the
   task name (`configs.sh` → `configs`), so the extension is free and buys editor
   highlighting and shellcheck discovery.
3. **Subdirectories namespace tasks.** `mise/tasks/macos/defaults.sh` becomes the task
   `macos:defaults`. Platform separation is therefore structural, not a pile of `uname`
   branches inside one script, and `mise tasks` displays it grouped.
4. **Split by weight, not uniformly.** Tasks with real logic become files under
   `mise/tasks/`. One-liners and thin wrappers stay inline in `mise.toml` under
   `[tasks]`. Neither "everything in TOML" (shell trapped in a config file) nor
   "everything a file" (a three-line file to run `git pull`) is worth the trade.
5. **Phases are idempotent; retry is stateless.** No completed-phase state file. Every
   phase is safe to re-run, so a bare re-run is always correct, and there is no
   recorded state that can drift from reality. `--from <phase>` skips ahead manually.
6. **Prompted, not TUI.** Plain `read` for the computer name and bundle. A `gum`-style
   picker would add a dependency that must be installed during the exact window when
   the machine has the least installed and is hardest to debug.
7. **Answers persist.** The computer name already lands in
   `config/env.d/hostname.local.sh`; the bundle name joins it. Re-runs skip the prompts
   unless `--reconfigure` is passed.
8. **Linux gets the cross-platform subset today, and an empty slot for the rest.**
   `bob` does not consume this repo yet. Bootstrap on Linux runs what genuinely works
   and states plainly which phases are undefined, rather than half-failing through
   `brew` commands. Linux phases land in `mise/tasks/linux/` when that flow is designed.

## Idempotency audit

Decision 5 rests on the existing scripts already being re-runnable. Every mutating
operation in the current bootstrap was checked:

| operation | source | re-runnable |
|---|---|---|
| `ln -sfn`, `mkdir -p` | `Makefile: configs` | yes — `-f` overwrites |
| `git submodule update --init --recursive` | `Makefile: submodules` | yes |
| `go build -o` | `Makefile: build-hooks` | yes |
| `claude mcp remove \|\| true` then `add` | `Makefile: claude-mcp` | yes — remove-then-add |
| `brew bundle` | `init-mac.sh` | yes — no-op when satisfied |
| `mise install` | `init-mac.sh` | yes |
| `softwareupdate --install-rosetta` | `init-mac.sh` | yes — no-op when present |
| `git clone` (tpm) | `init-mac.sh` | yes — guarded on directory |
| `vim +PlugInstall`, tpm `install_plugins` | `init-mac.sh` | yes |
| `dscl . -create UserShell`, `chown /usr/local/bin` | `init-mac.sh` | yes |
| `scutil --set`, `echo >` hostname | `init-minimal.sh` | yes — single `>` |
| `defaults write`, `dockutil --remove all` | `init-mac-more.sh` | yes — Terminal profile guarded |
| `git remote set-url` | `make-done.sh` | yes |

No non-idempotent step was found. If one is introduced later, the retry model breaks
silently — new phases must preserve this property.

## Task inventory

Eleven make targets become nine tasks. `macos:minimal`, `macos:packages`,
`macos:dev-env`, and `bootstrap` are new, arising from the `init-mac.sh` split and the
orchestrator rather than from any make target.

| make target | becomes | form | note |
|---|---|---|---|
| `configs` | `configs` | file | the 20-line symlink block |
| `claude-mcp` | `macos:claude-mcp` | file | Bear is macOS-only; already self-guards |
| `submodules` | `submodules` | inline | one-liner |
| `build-hooks` | `build-hooks` | inline | one-liner |
| `pretty` | `macos:defaults` | inline | renamed — it is Terminal/iTerm2/dock defaults |
| `done` | `finalize` | inline | renamed — names the phase, not the one action it does today |
| `ssh` | `ssh-setup` | inline | `ssh/bin/ssh-setup.sh` already handles both platforms |
| `install` | `setup` | inline | `depends = [submodules, configs, build-hooks]` |
| `all` | `update` | inline | redefined: `git pull`, then `configs`, `submodules`, `mise install` |
| `mise` | dropped | — | it only ran `mise install`; that command already exists |
| `git-pull` | dropped | — | folded into `update` |
| `app-store` | dropped | — | never existed; nothing regresses |

`all` → `update` is a redefinition rather than a rename. `all` currently chains
`pretty` and `done`, which are one-time bootstrap steps — reapplying macOS defaults and
rewriting the git remote on every dotfiles sync is wrong. `update` is the honest
version: pull, re-link, refresh.

`configs` deliberately declares no `depends`. Re-linking dotfiles after an edit is the
most frequently run task and must stay a sub-second operation.

## Layout

```
mise.toml                      # [tools] + inline [tasks]
mise/
  global.toml                  # unchanged
  try-me.toml                  # unchanged
  conf.d/                      # unchanged
  tasks/
    bootstrap.sh               # -> bootstrap   (orchestrator)
    configs.sh                 # -> configs
    macos/
      minimal.sh               # -> macos:minimal
      packages.sh              # -> macos:packages
      dev-env.sh               # -> macos:dev-env
      defaults.sh              # -> macos:defaults
      claude-mcp.sh            # -> macos:claude-mcp
    linux/                     # empty; bob's phases land here
macos/bin/
  install.sh                   # trimmed: clone, ensure mise, run bootstrap
  init-minimal.sh              # absorbed by macos:minimal
  init-mac.sh                  # split into macos:packages and macos:dev-env
  init-mac-more.sh             # unchanged; macos:defaults wraps it
  make-done.sh                 # unchanged; finalize wraps it
Makefile                       # deleted
```

`init-mac.sh` is split because it currently does brew bundles *and* tpm/vim/shell setup
in one script. Separating them is what makes "re-run just the vim plugins" or "re-run
just the brew bundles" possible.

## Bootstrap phases

`bootstrap` selects its phase list from `uname -s`.

### macOS

| # | phase | kind | what |
|---|---|---|---|
| 1 | `configs` | auto | symlink dotfiles into `$HOME` |
| 2 | `macos:minimal` | auto | Homebrew, `minimal.brewfile`, computer name |
| 3 | `signin-core` | manual | 1Password, Mac App Store login |
| 4 | `macos:packages` | auto | rosetta, `core.brewfile` + bundle brewfile, link the bundle's `conf.d`/`rules.d`, `mise install` |
| 5 | `macos:dev-env` | auto | submodules, build-hooks, tpm, vim plugins, login shell, `macos:claude-mcp` |
| 6 | `signin-apps` | manual | Dropbox, Chrome, `gh auth login` |
| 7 | `ssh-setup` | auto | `ssh/bin/ssh-setup.sh` |
| 8 | `macos:defaults` | auto | Terminal/iTerm2/dock defaults (sudo) |
| 9 | `system-prefs` | manual | System Preferences, Alfred, Amphetamine, Magnet, Sublime, Finder |
| 10 | `finalize` | auto | git remote → ssh |

### Linux

`configs`, `submodules`, `build-hooks`, `ssh-setup`, `finalize`. Bootstrap reports that
package installation and dev-env phases are not yet defined for Linux.

### Manual phases

`signin-core`, `signin-apps`, and `system-prefs` exist only as phases inside
`bootstrap`; they are not standalone tasks and do not appear in `mise tasks`. They are
valid `--from` targets, which is how you resume at the automated phase that follows one.

A manual phase prints its checklist and waits for Enter. The checklist points at the
relevant README section rather than restating it, so the two cannot drift apart.

## Retry model

- `set -e`, with a trap that names the failed phase and prints the resume command:

  ```
  ✗ phase 4/10 (macos:packages) failed
    fix it, then:  mise run bootstrap --from macos:packages
  ```

- `--from <phase>` starts at a named phase and skips the prompts, reading cached
  answers from `config/env.d/`.
- `--reconfigure` re-asks for the computer name and bundle.
- Any phase is independently runnable as its own task (`mise run macos:defaults`),
  bypassing the orchestrator entirely.

## Files touched

- `mise.toml` — add `[tasks]`
- `mise/tasks/**` — new
- `macos/bin/install.sh` — trim to clone, ensure mise, run bootstrap
- `macos/bin/init-minimal.sh`, `macos/bin/init-mac.sh` — absorbed into tasks
- `README.md` — replace `make …` invocations; the manual checklists stay and become
  what the manual phases reference
- `windows/install.ps1`, `windows/CLAUDE.md` — comments referring to `make configs`
- `Makefile` — deleted

## Out of scope

- Designing bob's Linux bootstrap. Only the empty `mise/tasks/linux/` slot and the
  honest "not defined yet" report are in scope.
- Restoring `app-store`. If wanted later it is a `brew-bundle` task, which needs the
  per-machine bundle-name question resolved first.
- Making `macos/bin/init-mac-more.sh` or `make-done.sh` platform-aware. They stay
  macOS-only and are reached only through macOS phases.
- Windows. `windows/install.ps1` remains the separate entry point; only its stale
  references to `make` are corrected.
