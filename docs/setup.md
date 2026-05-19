# Setup Notes

This document records local assumptions and setup guidance for this personal Neovim configuration. It is broader than the Neovim 0.12 migration runbook and should be updated when the config is used on another Linux workstation.

## Current workstation

- Distribution: openSUSE Tumbleweed
- Package manager: `zypper`
- Available toolchains: `cargo`, `uv`, `npm`, `ty`, `go`

## Local assumptions

- This config is a daily driver, not a reusable Neovim distribution.
- The current workstation is Linux. Another Linux distribution is acceptable, but record it here when used.
- Document distro packages and available toolchains here instead of hiding them in plugin config logic.
- Do not document secrets, credential values, private keys, tokens, or machine-local overrides that should stay outside Git.

## Active language workflow

Current first-class language support is for:

- Python
- TypeScript and JavaScript
- Lua
- SQL
- Web and frontend files

Other languages are possible when there is an actual project or use case. Do not treat this list as a permanent boundary.

## Tool ownership

- Lazy manages editor plugins.
- Mason manages editor-facing LSP, debug, formatter, or linter binaries when appropriate.
- Language managers such as `uv`, `cargo`, `npm`, and `go` manage broader developer tools.
- The distro package manager provides system packages and optional host dependencies when the current workstation actually needs them.

## Optional host dependencies

Install optional host dependencies only when the related ecosystem is used on the current workstation. Missing Ruby, PHP, Java, Julia, Mercurial, Composer, or standalone Lua 5.1 may appear in healthcheck output without breaking the working daily workflow.

## Validation

After changes that affect startup, plugins, LSP, Tree-sitter, or healthchecks, run:

```sh
nvim --headless +qa
nvim --headless -c "checkhealth" -c qa
```

For Neovim 0.12-specific migration notes, see `docs/neovim-0.12-migration.md`.
