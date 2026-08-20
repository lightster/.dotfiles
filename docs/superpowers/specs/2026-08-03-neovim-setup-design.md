# Neovim Setup — Design

## Goal

Add a Neovim configuration to the dotfiles that provides real code intelligence
(LSP, treesitter, fuzzy finding) while keeping the existing Vim setup intact and
untouched. The configuration must behave identically on every machine and must
not interfere with per-project tool versions managed by mise.

## Decisions

| Area | Decision |
|---|---|
| Relationship to Vim | Coexist. `vim/vimrc` and the `~/.vimrc` symlink are unchanged. No `vim`→`nvim` alias. |
| Plugin manager | lazy.nvim, with `lazy-lock.json` committed |
| Plugin philosophy | mini.nvim suite over individually-sourced plugins |
| Language servers | gopls, lua_ls, yamlls, jsonls, bashls — installed via mise, no Mason |
| Completion | Built-in `vim.lsp.completion` (Neovim 0.11+), no completion plugin |
| Git | mini.diff for signs; lazygit for everything else |
| Colorscheme | tokyonight (storm) |
| Clipboard | OSC 52 on yank only |

## Layout

The configuration lives in `nvim/` and is symlinked into place by
`mise/tasks/configs.sh`:

```bash
ln -sfn "$DOTFILES"/nvim ~/.config/nvim
mise trust "$DOTFILES"/nvim
```

The `mise trust` call is required because `nvim/mise.toml` (below) will not be
loaded by mise until the config file is trusted. It targets the repository path
rather than the symlink so that trust does not depend on how mise resolves
symlinked config directories.

```
nvim/
  init.lua
  mise.toml              # editor tool environment; see below
  lazy-lock.json         # committed: pins plugin commits across machines
  lua/
    config/options.lua
    config/keymaps.lua
    config/autocmds.lua
    plugins/mini.lua
    plugins/lsp.lua
    plugins/treesitter.lua
    plugins/format.lua
    plugins/colorscheme.lua
```

`lazy-lock.json` is committed so that every machine resolves identical plugin
commits. Without it, plugin versions drift independently per machine.

## Tool management

Language servers are installed by mise. Mason is not used: it installs a single
global version of each tool into `~/.local/share/nvim/mason/bin` and prepends
that directory to `PATH` for spawned servers, which would shadow mise's
per-directory tool resolution.

Tools are split across two mise configs according to one rule:

> A language server goes in the editor environment when its runtime must be
> stable. It goes on the global `PATH` when it must track the project's own
> toolchain.

### Editor environment — `nvim/mise.toml`

```toml
[tools]
node = "24.18.0"
"npm:yaml-language-server" = "latest"
"npm:vscode-langservers-extracted" = "latest"   # provides jsonls
"npm:bash-language-server" = "latest"
```

Language servers distributed as npm packages are executed through shims whose
final line is `exec node …`, resolving `node` from `PATH` at run time. A project
that pins an older Node would therefore run these servers under that older Node,
breaking them in that project only — a failure that surfaces as a server which
silently fails to attach.

Invoking them through mise's `-C` flag pins their runtime independently of the
project:

```lua
cmd = { 'mise', 'exec', '-C', vim.fn.expand('~/.config/nvim'), '--',
        'yaml-language-server', '--stdio' }
```

`mise exec -C DIR` replaces the environment rather than layering onto it: tools
resolved from the caller's directory are removed, and only tools from `DIR`'s
config chain are present. This isolation is what makes the approach work.

Because `node` is declared here, it does not need to be added to
`mise/global.toml`; it remains in the `personal` bundle for interactive use.

### Global — `mise/global.toml`

```toml
"go:golang.org/x/tools/gopls" = "latest"
lua-language-server = "latest"
stylua = "latest"
shfmt = "latest"
tree-sitter = "latest"
```

`tree-sitter` is the parser compiler, not a language server. nvim-treesitter's
maintained branch builds parsers from source with the CLI instead of shipping
prebuilt ones, and its documentation requires installing it from a package
manager rather than npm — which suits the same reasoning as the servers above.

These are statically linked binaries with no runtime dependency. `gopls` in
particular must be reached through the ordinary `PATH` so that it inherits the
Go toolchain of whichever project is open — mise already pins `go` per
directory, and gopls reads it from `PATH`. Running gopls inside the editor
environment would strip the project's Go entirely.

Per-project overrides need no additional work. `mise activate` rewrites `PATH`
on directory change, and language servers spawned by Neovim inherit its
environment, so tool versions resolve per nvim session.

## Plugins

- **mini.nvim** — `mini.pick` + `mini.extra` (fuzzy finding), `mini.surround`,
  `mini.pairs`, `mini.align`, `mini.statusline`, `mini.diff`
- **nvim-treesitter**
- **nvim-lspconfig** — used only as a source of server defaults; servers are
  enabled through the native `vim.lsp.config` / `vim.lsp.enable` API
- **conform.nvim**
- **tokyonight.nvim**

The mini.nvim suite replaces `auto-pairs`, `vim-surround`, `tabular`, and
`vim-airline` + `vim-airline-themes`. `vim-commentary` is dropped because
Neovim provides `gc` natively.

Not carried over: `fzf`/`fzf.vim` (replaced by mini.pick), `vim-fugitive`
(lazygit covers the workflow; mini.diff provides gutter signs),
`vim-visual-multi`, `vim-repeat` (mini.surround implements its own dot-repeat),
`dash.vim`, `nginx.vim`, `plasticboy/vim-markdown`, `vim-eunuch`.

## Completion

Neovim 0.11+ provides `vim.lsp.completion.enable()` with autotrigger, which is
sufficient here — the Vim configuration it replaces had no completion plugin at
all, only a Tab-mapping wrapper around `<c-p>`. A dedicated completion engine
can be added later if this proves limiting.

## Formatting

conform.nvim, resolving formatter binaries from `PATH`. Because `mise activate`
rewrites `PATH` per directory, a project's own pinned `golangci-lint` or its
`node_modules/.bin/prettier` automatically takes precedence over anything
installed globally. This is the desired behavior for formatters and linters,
which must match what CI runs.

Format-on-save for Go (`gofmt`/`goimports`), Lua (`stylua`), and shell
(`shfmt`), all installed globally. `prettier` is configured for JSON, YAML,
CSS, HTML, Markdown, and the JavaScript/TypeScript filetypes but is
deliberately *not* installed globally: conform skips a formatter whose binary
it cannot resolve, so prettier formats only in projects that ship it and
leaves every other repository untouched.

Language servers are not used as a formatting fallback (`lsp_format = 'never'`).
`jsonls` and `yamlls` both implement formatting, and allowing them to run on
save would reformat files in repositories that never adopted their conventions
— the same churn the per-project resolution above exists to avoid. Explicit
`vim.lsp.buf.format()` still works.

Filetypes without a resolvable formatter are left alone apart from the
trailing-whitespace trim described below.

## Clipboard

Yanks propagate to the local machine's clipboard through OSC 52, which survives
SSH, mosh, and zellij. Verified against the target setup: OSC 52 writes arrive,
OSC 52 reads do not — the terminal receives the query but its response never
travels back upstream, because mosh synchronizes screen state downstream and
keystrokes upstream, with no path for out-of-band terminal replies. Paste from
the local machine therefore remains an ordinary terminal paste.

The OSC 52 provider is configured explicitly rather than relying on Neovim's
automatic detection, which keys off `$SSH_TTY` — not reliably set by
mosh-server.

`clipboard` is deliberately left unset. Setting `unnamedplus` would route `d`,
`c`, and `x` through the system clipboard as well, so deleting a line would
overwrite the clipboard. Instead a `TextYankPost` autocommand pushes to OSC 52
only when `vim.v.event.operator == 'y'`.

## Carried over from `vim/vimrc`

Kept: `mapleader = Space`; `scrolloff`; the two-space indent family and
`listchars`; `number` + `relativenumber` + `numberwidth`; `colorcolumn`;
`grepprg=rg` and the search settings including `<leader>h`; `<leader>e`,
`<leader>o`, `<leader>O`, `<leader>=`;
markdown wrap/linebreak/spell; gitcommit `spell` and `textwidth=72`; per-filetype
indent rules for PHP, Go, and HTML/phtml; the zsh `commentstring`;
cursor-preserving trailing-whitespace trim on save.

Picker mappings keep their existing keys against mini.pick: `<c-p>` for files,
`<leader>p` for recent files, `\` for live grep. The `<leader>aa` /
`<leader>a:` alignment mappings are re-implemented against mini.align. The
`<leader>'` / `<leader>"` quote-swap mappings are dropped in favour of
mini.surround's own `sr`, whose `q` identifier matches any quote character and
so covers both mappings plus backticks.

Dropped: `lazyredraw`; `hidden`, `showcmd`, `history`, and `backspace` (Neovim
defaults); the manual `highlight` calls for `LineNr`, `ColorColumn`, and
`SpellBad` (the colorscheme's responsibility); `InsertTabWrapper`;
`<leader>so`, which re-sourced the vimrc: `require()` caches modules in
`package.loaded`, so re-running `init.lua` skips every `require`d module and
re-enters the plugin manager without applying any edit. `:restart` is the
working equivalent;
`runtime macros/matchit.vim` (built in); the ctags configuration and `<leader>.`
(LSP symbol search replaces it); the arrow-key nag mappings; markdown's
`set columns=80` and its `VimResized` companion, which resize the terminal
itself rather than soft-wrapping the buffer.

The backup and swap machinery — `set backup`, `backupdir`, the `silent !mkdir`
shell-out, and the `strftime` backup-extension autocommand — is replaced by
`undofile`, which provides persistent undo across sessions.

## Known caveats

- `mise exec -C DIR` sets the child process's working directory to `DIR`, so
  servers launched through the editor environment start with a working directory
  of `~/.config/nvim`. Language servers derive their workspace from the
  `rootUri` sent in the LSP `initialize` request, not from the working
  directory, so this is expected to be harmless. If a server proves sensitive to
  it, the fix is a wrapper script that captures the original working directory
  and restores it after `mise exec` has resolved the environment.
- OSC 52 payloads are size-limited by terminal emulators. Yanking a very large
  region may be truncated silently.

## Out of scope

- Windows support (`windows/install.ps1` is unchanged)
- Two-way clipboard sharing between machines, which would require an
  out-of-band channel rather than OSC 52
- Removing `tmux.conf`, which is no longer used
