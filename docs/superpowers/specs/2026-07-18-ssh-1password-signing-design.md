# SSH auth + commit signing via 1Password — design

Status: POC. Nothing here is committed automatically; the destructive GPG-retirement
steps are explicitly out of scope.

## Goal

Stand up a fresh `ssh/` folder in dotfiles that configures SSH client auth and Git
commit signing through per-device keys, served by the 1Password SSH agent on macOS and
a local `ssh-agent` on Linux. Replace nothing in the old `.ssh` / `.ssh-private` repos —
they are ignored entirely.

## Decisions (settled during brainstorming)

1. **One key per device**, registered at GitHub in both the authentication and signing
   slots. No per-purpose key split.
2. **The agent that serves the key lives where the key lives.** macOS → 1Password vault
   (private key never on disk). Linux/bob → local `ssh-agent` on a fixed socket, private
   key on disk.
3. **SSH signing replaces GPG signing** for commits/tags. GPG keys are left in place;
   flipping `gpg.format = ssh` simply stops Git from using GPG. Reversible. Actual GPG
   revocation/deletion and the work-machine (vecna) timing are a later operational
   checklist, not part of this POC.
4. **Fragment model, auto-selected by OS.** `~/.ssh/config` includes numbered fragments
   from `~/.ssh/config.d/`. Setup symlinks the enabled fragments in (available/enabled,
   nginx-style). The enabled set is chosen by platform, with a per-device override file.
5. **Public key filename is `id_ed25519.pub` on every device.** One key per device makes
   a generic name unambiguous, so `user.signingkey` is static committed config with no
   per-device path and no symlink indirection. Standardizing on ed25519 keeps the path
   identical everywhere.
6. **Never commit `.pub` files to dotfiles.** They are derivable (`op read`,
   `ssh-keygen -y`) and published (`github.com/<user>.keys`); a committed copy only
   drifts. The single exception is `allowed_signers`, which is authored config that
   happens to embed public keys.

## Layout

```
ssh/
  config                         # symlinked -> ~/.ssh/config; Include ~/.ssh/config.d/*.conf
  config.d/available/            # all fragments, committed
    10-defaults.conf             # shared, always enabled
    20-agent-1password.conf      # macOS: IdentityAgent -> 1Password socket
    20-agent-local.conf          # Linux: IdentityAgent -> local ssh-agent socket
  gitconfig/
    signing-1password            # full SSH-signing block WITH op-ssh-sign program line
    signing-local                # full SSH-signing block WITHOUT program line
  systemd/
    ssh-agent.service            # Linux user service: ssh-agent on %t/ssh-agent.sock
  allowed_signers                # committed; the one place pubkeys intentionally live in-repo
  bin/ssh-setup                  # idempotent setup script
  .gitignore                     # ignores device.local, enabled.local
```

`~/.ssh/config.d/` is a real directory; `ssh-setup` symlinks enabled fragments into it.
`~/.ssh/config` uses an **absolute** `Include ~/.ssh/config.d/*.conf` to avoid any
symlink-relative-path ambiguity.

## Fragments

`10-defaults.conf` (always on):

```
Host *
  AddKeysToAgent yes
```

`20-agent-1password.conf` (macOS):

```
Host *
  IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
```

`20-agent-local.conf` (Linux):

```
Host *
  IdentityAgent "${XDG_RUNTIME_DIR}/ssh-agent.sock"
```

No `ForwardAgent` anywhere — default off. `10` and `20` set different keywords, so
SSH first-match-wins is safe. The `2BUA8C4S2C` team ID is constant across macOS
installs.

The Linux fragment is a **reference template**: `ssh-setup` materializes it into
`~/.ssh/config.d/` with the concrete socket path rather than symlinking it. SSH's
`${XDG_RUNTIME_DIR}` expansion hard-fails *all* ssh when the variable is unset (cron,
non-login shells), so the runtime env dependency is resolved once, at setup time. The
macOS fragment uses a `~`-based path with no env dependency and stays a plain symlink.

## Per-device selection

`ssh-setup` derives the enabled set from `uname -s`:

- Darwin -> `10-defaults.conf`, `20-agent-1password.conf`
- Linux  -> `10-defaults.conf`, `20-agent-local.conf`

A gitignored `ssh/enabled.local` (one fragment name per line) overrides the auto set
when present. Setup adds symlinks for enabled fragments and removes stale symlinks for
disabled ones, so toggling a fragment off takes effect on re-run.

Device name comes from a gitignored `ssh/device.local`, never from `hostname` — a
rename must not silently mint a duplicate key. Setup errors out if the file is absent.

## Keys

- macOS: generated inside 1Password (`op item create --category ssh --ssh-generate-key`,
  guarded by an existence check). Public half written to `~/.ssh/id_ed25519.pub` via
  `op read`. Private half never on disk.
- Linux: `ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519`; private key stays local, loaded
  into the local agent.

## GitHub registration

Both slots, idempotent (guarded because `gh` rejects duplicate keys):

```
gh ssh-key add ~/.ssh/id_ed25519.pub --title <device>
gh ssh-key add ~/.ssh/id_ed25519.pub --title <device>-sign --type signing
```

`ssh-setup` confirms the `--type signing` flag against `gh ssh-key add --help` before
using it.

## Git signing

Two committed includes hold the full block (shared lines duplicated, not abstracted):

```
[gpg]
        format = ssh
[gpg "ssh"]
        program = ".../op-ssh-sign"          # 1password variant only
        allowedSignersFile = ~/.ssh/allowed_signers
[user]
        signingkey = ~/.ssh/id_ed25519.pub
[tag]
        gpgsign = true
```

`ssh-setup` symlinks `~/.ssh/gitconfig-signing` to the platform variant and
`~/.ssh/allowed_signers` to the committed file. `git/config` gains one include of
`~/.ssh/gitconfig-signing` and drops the dead `config-gpg` include. `commit.gpgsign`
is already true; with `format = ssh` it now signs via SSH. Setup appends the device's
principal line to `allowed_signers` if absent so `git log --show-signature` verifies
locally.

Caveat: this sets `format = ssh` globally. Work-org git includes load afterward and
could override it back to GPG if ever needed; vecna is being returned, so this is
accepted for now.

## Sandbox

Add the 1Password agent socket to `allowUnixSockets` in `claude/settings.json`
(alongside the existing gpg-agent sockets) so Claude Code can auth and sign from inside
the sandbox. This is the critical gate: the current allowlist only permits gpg-agent
sockets.

## Bootstrap

A dedicated `make ssh` target runs `ssh-setup`. It is not folded into `make configs`
because it needs `op` and `gh` interactively authenticated first. The pure-symlink
parts are safe to re-run anytime.

## Out of scope

GPG revocation/deletion; vecna work-key handling; the old `.ssh` / `.ssh-private`
repos; Windows machines; host-specific `Host` blocks.
