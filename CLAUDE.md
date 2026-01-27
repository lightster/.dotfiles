# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Setup Commands

```bash
make configs    # Symlink all config files to home directory
make pretty     # Run additional Mac setup scripts
make all        # Full setup: git-pull, configs, app-store, pretty, done
```

## Repository Structure

- `zshrc` - Main zsh configuration, sources `shell/common`
- `shell/` - Shared shell config: `common` sources `path`, `env`, `aliases`
- `git/config` - Git configuration with per-organization includes (atticus, kelvin, tinyprint)
- `git/bin/` - Git helper scripts (git-prompt.sh, git-completion.sh)
- `claude/` - Claude Code settings and global CLAUDE.md (symlinked to ~/.claude/)
- `osx/bin/` - Mac setup scripts (install.sh, init-minimal.sh, init-mac.sh)

## Key Aliases

- `g` = git (via hub)
- `g go <name>` = checkout or create branch (auto-prefixes in some repos)
- `g po` = push with upstream tracking
- `to <project>` = cd to ~/github/*/<project>

## Shell Script Style

- Use `source` instead of `.` for sourcing files
- Use conditional checks with silent failures for optional tools:
  ```bash
  if command -v tool &>/dev/null; then
    eval "$(tool init)"
  fi
  ```

## Configuration Philosophy

- Remove configuration for tools you're not actively using - add back only when needed
- When a tool might not be installed on all machines, check for its existence before loading
- Prefer silent failures over error messages for optional tools
- Deduplicate configuration before adding new entries - check if similar config already exists
