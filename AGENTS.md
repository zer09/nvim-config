# Agent Instructions for this Neovim Config

## Project scope

This repository is a personal Neovim configuration targeting Neovim 0.12 on Linux workstations. The current workstation is summarized in `docs/setup.md`.

Current workstation assumptions live in `docs/setup.md`; keep that file as the source of truth for distro, package manager, and available toolchains.

Plugin manager: `lazy.nvim`

## Working style

- Read `CONTEXT.md` for glossary and workflow language before changing behavior or documentation.
- Read `docs/setup.md` for local assumptions, tool ownership, and host setup guidance before changing setup, tooling, or dependency behavior.
- Preserve the existing file and folder structure.
- Make small, surgical changes that match the current Lua style.
- Read existing config before editing.
- Do not edit installed plugin files under `~/.local/share/nvim/lazy/`; fix config locally or document upstream issues instead.
- Do not install optional runtimes just to silence healthcheck warnings.
- Never commit API keys, tokens, or local credentials. Use environment variable names in config and docs.

## Neovim 0.12 migration constraints

See `docs/neovim-0.12-migration.md` before changing 0.12-related behavior.

Important decisions already made:

- `after/lsp/<server>.lua` files must return config tables. Do not use `vim.lsp.config("server", ...)` inside those files.
- Use `vim.uv`, not deprecated `vim.loop`.
- Keep `nvim-treesitter` on the frozen `master` branch for now. Treat the `main` rewrite as a separate future migration.
- Pin `tree-sitter-cli` to `0.25.10` when installing or rebuilding parsers for this setup.
- Keep the local Tree-sitter injection directive compatibility patch in `lua/plugins/lsp.lua` while using frozen `nvim-treesitter` `master` with Neovim 0.12.
- Keep Catppuccin `auto_integrations` disabled unless there is a specific reason to re-enable it.

## Healthcheck warning policy

Document optional host dependencies, but do not install or require them unless the device actually uses that ecosystem.

Warnings that are usually safe to ignore:

- Missing Mercurial if the device does not use Mercurial repos.
- Missing Ruby, PHP, Java, Julia, or Composer unless Mason should manage tools for those ecosystems.
- Missing standalone Lua 5.1 executable if no plugin build actually requires it. Neovim's embedded LuaJIT is expected and is not the same thing.
- `vim.pack` warnings when all plugins are managed by `lazy.nvim`.
- `vim.lsp` unknown filetype warnings such as `typescript.tsx`, `javascript.jsx`, `gotmpl`, or `yaml.docker-compose` unless an LSP fails to attach for files actually used on the device.
- Upstream plugin deprecation warnings such as `wrapping.nvim` using deprecated `vim.validate{<table>}`.

## Validation commands

Run these after config changes that affect startup, plugins, LSP, Tree-sitter, or healthchecks:

```sh
nvim --headless +qa
nvim --headless -c "checkhealth" -c qa
```

For markdown and Tree-sitter injection regressions, also open a markdown file headlessly and inspect logs if needed.

Key reproducible setup commands from the migration:

```sh
cargo install tree-sitter-cli --version 0.25.10 --locked --force
uv tool install pylatexenc
nvim --headless -c "TSInstallSync latex" -c qa
```

## Troubleshooting

Check these first when startup or file-open errors return:

- `~/.local/state/nvim/nvim.log`
- `~/.local/state/nvim/lsp.log`
- `:messages`

Verbose startup trace:

```sh
nvim -V3~/.local/state/nvim/startup.log
```

## Plugin integration notes

- Configure plugins through files under `lua/plugins/`.
- For `blink.cmp`, this config is currently pinned to v1 via `version = "1.*"`.
- `blink.compat` is configured for `blink.cmp` v1. Verify compatibility before moving to `blink.cmp` v2.

## Git notes

- Keep migration notes in `docs/neovim-0.12-migration.md` when adding reproducible fixes.
- Commit only intentional config or documentation changes.
- Before committing, verify the staged diff does not contain secrets.
