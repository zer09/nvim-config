# Neovim 0.12 Migration Runbook

This runbook records the config changes and host-level checks needed when upgrading this Neovim config from 0.11 to 0.12 on another device.

For general machine setup, local assumptions, tool ownership, and optional host dependencies, see [`docs/setup.md`](./setup.md).

Target host profile:

- Distribution: openSUSE Tumbleweed
- Package manager: `zypper`
- Available toolchains: `cargo`, `uv`, `npm`, `ty`, `go`

## Config changes already applied

### LSP config files under `after/lsp/`

Neovim 0.12 loads `after/lsp/<server>.lua` files as runtime LSP config fragments. These files must return a table.

Use this shape:

```lua
return {
  settings = {},
}
```

Do not use this shape inside `after/lsp/<server>.lua`:

```lua
vim.lsp.config("server", {
  settings = {},
})
```

Applied files:

- `after/lsp/basedpyright.lua`
- `after/lsp/jsonls.lua`
- `after/lsp/lua_ls.lua`
- `after/lsp/ruff.lua`
- `after/lsp/tailwindcss.lua`
- `after/lsp/ts_ls.lua`
- `after/lsp/ty.lua`
- `after/lsp/vue_ls.lua`
- `after/lsp/yamlls.lua`

### Replace deprecated `vim.loop`

Neovim 0.12 uses `vim.uv`.

Applied change in `init.lua`:

```lua
if not vim.uv.fs_stat(lazypath) then
```

## Copy-paste setup for a new openSUSE machine

Run these after installing this config and syncing plugins:

```sh
cargo install tree-sitter-cli --version 0.25.10 --locked --force
uv tool install pylatexenc
nvim --headless -c "TSInstallSync latex" -c qa
nvim --headless +qa
nvim --headless -c "checkhealth" -c qa
```

Do not install Ruby, PHP, Java, Julia, or Mercurial just to silence health warnings. Install those only when the device actually needs the related ecosystem.

If `~/.local/share/nvim/site/pack/core` exists and is empty, remove it:

```sh
rm -rf ~/.local/share/nvim/site/pack/core
```

It should not be recreated by this config because Catppuccin `auto_integrations` is disabled and explicit integrations are configured instead.

## Validate after upgrading

Run:

```sh
nvim --headless +qa
nvim --headless -c "checkhealth" -c qa
```

Expected result:

- No startup error from `mason-lspconfig.nvim`.
- No `after/lsp/<server>.lua: not a table` error.
- Health warnings may remain for optional external tools.

## Troubleshooting and handoff notes

If startup or file-open errors return, inspect these logs first:

- `~/.local/state/nvim/nvim.log`
- `~/.local/state/nvim/lsp.log`
- `:messages`

For a verbose startup trace, run:

```sh
nvim -V3~/.local/state/nvim/startup.log
```

Migration commits in this config:

- `81c74bd chore: migrate neovim config to 0.12`
- `fb051ca fix: handle treesitter injection captures on nvim 0.12`

The `nvim-treesitter` markdown `range` nil error is handled by the local directive compatibility patch in `lua/plugins/lsp.lua`; do not remove that patch while this config stays on the frozen `nvim-treesitter` `master` branch.

## Migration scope

Actively fix Neovim 0.12 compatibility issues in this config or plugin setup. Document optional host dependencies, but do not install or require runtimes for ecosystems that are not used on the device.

Keep `nvim-treesitter` on the frozen `master` branch for this migration. The `main` branch is a full incompatible rewrite and should be treated as a separate future migration. With `master`, pin `tree-sitter-cli` to `0.25.10` for parser generation compatibility.

In scope for config changes:

- Neovim 0.12 API migrations.
- Plugin setup changes needed to avoid 0.12 deprecations.
- Optional markdown math rendering setup if desired.

Out of scope unless explicitly needed:

- Installing Ruby, PHP, Java, Julia, or Mercurial only to silence health warnings.
- Fixing `vim.pack` warnings while plugins are managed by `lazy.nvim`.
- Registering every upstream LSP filetype warning preemptively.

## Current health warnings and likely fixes

### External command dependencies

These are host-level dependencies, not Neovim config errors. Install only the ecosystems you actually use on the device.

| Health source | Warning | openSUSE Tumbleweed fix |
| --- | --- | --- |
| `diffview` | `hg_cmd` is not executable: `hg` | `sudo zypper install mercurial` if you use Diffview with Mercurial repos. Otherwise ignore. |
| `lazy` | Lua 5.1 executable missing | No standalone Lua 5.1 package was found in the current zypper repos. `luajit` and `luajit-luarocks` are the practical openSUSE path; ignore unless a plugin build explicitly requires a `lua5.1` executable. |
| `mason` | Ruby and RubyGem unavailable | `sudo zypper install ruby` if Mason should manage Ruby tools. Otherwise ignore. |
| `mason` | Composer and PHP unavailable | `sudo zypper install php8 php8-cli php-composer2` if Mason should manage PHP tools. Otherwise ignore. |
| `mason` | `javac` unavailable | `sudo zypper install java-21-openjdk-devel` if Mason should manage Java tools. Use `java-17-openjdk-devel` instead only when a project requires Java 17. |
| `mason` | Julia unavailable | `sudo zypper install juliaup` if Mason should manage Julia tools. Otherwise ignore. |
| `render-markdown` | `utftex` or `latex2text` missing | This config explicitly prefers `latex2text`. Install it with Python: `uv tool install pylatexenc`. Use `utftex` only if you intentionally build or install `libtexprintf`; no zypper package was found in the current repos. |
| `render-markdown` | Tree-sitter `latex` parser missing or ABI unknown | This config includes `latex` in the nvim-treesitter `ensure_installed` list. Because this config uses frozen `nvim-treesitter` `master`, pin the CLI before installing the parser: `cargo install tree-sitter-cli --version 0.25.10 --locked --force`, then run `nvim --headless -c "TSInstallSync latex" -c qa`. Do not use `tree-sitter-cli` 0.26.x with the current `master` setup; it removed the `--no-bindings` flag still used by this branch. |

### Local state warnings

| Health source | Warning | Reproducible fix |
| --- | --- | --- |
| `lazy` | Existing packages under `~/.local/share/nvim/site/pack/core` | Inspect the directory first. If it is empty and keeps being recreated on startup, check for plugins calling `vim.pack.get()`. In this config, Catppuccin `auto_integrations` was disabled because explicit integrations are already configured. |
| `vim.pack` | Lockfile absent while plugin directory exists | Usually irrelevant when using `lazy.nvim`. If this appears with an empty `site/pack/core/opt`, remove the empty directory and avoid plugin code that probes `vim.pack` when not using it. |

### Plugin compatibility warnings

| Health source | Warning | Reproducible fix |
| --- | --- | --- |
| `vim.deprecated` | `vim.validate{<table>}` is deprecated | Comes from `wrapping.nvim`. Do not patch the installed plugin directory locally; that would be brittle across devices. Leave documented until upstream fixes it, or switch to a fork only if the warning becomes a real failure. |
| `flutter-tools` | `lsp.color` is deprecated | Remove the deprecated `flutter-tools` `lsp.color` block and enable native document colors for `dartls` in `LspAttach`: `vim.lsp.document_color.enable(true, { bufnr = ev.buf, client_id = client.id }, { style = "background" })`. |
| `nvim-treesitter` | `decor_provider_error` with `attempt to call method 'range' (a nil value)` when opening markdown code fences | Neovim 0.12 can pass quantified captures as node lists while frozen `nvim-treesitter` `master` predicates expect a single node. This config re-registers the affected injection directives and unwraps the first node. |
| `vim.lsp` | Unknown filetypes such as `typescript.tsx`, `javascript.jsx`, `gotmpl`, `yaml.docker-compose` with `Hint: filename extension != filetype` | Mostly generated by upstream LSP configs. The hint means an LSP config may be using an extension-like name where Vim expects a filetype, for example `typescriptreact` instead of `typescript.tsx`. Leave documented as healthcheck noise unless the affected language server fails to attach for files you actually use. Add explicit filetype registrations only when a project needs one of those filetypes. |

## Safe-to-ignore warnings

Ignore these unless the related workflow is used:

- Mercurial warning if you do not use Mercurial repos.
- Mason missing runtimes for languages you do not develop on that device.
- `vim.pack` warning if all plugins are managed by `lazy.nvim`.
- Unknown LSP filetypes for languages or templates you never open.
