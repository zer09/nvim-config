# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A personal Neovim configuration using lazy.nvim as the plugin manager, targeting Neovim 0.10+. No build step, no tests — changes take effect by restarting Neovim or sourcing the relevant file.

## Architecture

**Entry point:** `init.lua` — bootstraps lazy.nvim, sets leader keys (`<space>`), configures rocks.nvim, and imports the four core modules and the plugin specs.

**Core modules in `lua/`:**
- `options.lua` — vim options (tabs, clipboard, line numbers, etc.)
- `cmd.lua` — autocmds (comment prevention, yank highlight, spell check triggers, terminal behavior)
- `map.lua` — global keymaps using helpers from `helper.lua`
- `helper.lua` — mapping utilities (`nnoremap`, `vnoremap`, etc.) and icon constants used across plugins

**Plugin specs in `lua/plugins/`** — each file returns a lazy.nvim spec table. Files are loosely grouped by concern:
- `lsp.lua` — treesitter, LSP config, mason, mason-lspconfig, flutter-tools
- `blink.lua` — completion (blink.cmp) with LSP/snippet/path/buffer/dictionary sources
- `conform.lua` — formatters via conform.nvim
- `telescope.lua` — fuzzy finder with fzf-native, file browser, egrepify
- `git.lua` — neogit, gitsigns, gitgraph, vim-fugitive
- `colorscheme.lua` — catppuccin with extensive highlight overrides (~370 lines)
- `ui.lua` — autopairs, noice, leap, rainbow delimiters, icons, mini modules
- `common.lua` — small utilities: suda.vim, mini.surround, Comment.nvim

**Per-server LSP overrides** live in `after/lsp/<server>.lua` (e.g., `basedpyright.lua`, `ts_ls.lua`). These are loaded automatically by Neovim's `after/` mechanism.

**Snippets** are in `lua/plugins/snippets/` (one file per language) and loaded by blink.cmp.

## Key Conventions

- All keymaps go through helper functions from `helper.lua`, not `vim.keymap.set` directly.
- Plugin-specific keymaps are defined inside the plugin's `config` or `keys` field, not in `map.lua`.
- lazy.nvim specs use inline `opts = {}` for simple configs and `config = function() ... end` for anything that needs setup calls.
- `lazy-lock.json` pins exact plugin commits — update it intentionally with `:Lazy update`.

## Environment Notes

- Running on WSL2; clipboard is wired to `wl-clipboard` (`wl-copy`/`wl-paste`) in `options.lua`.
- Catppuccin auto-detects dark/light mode at startup; colors are heavily overridden in `colorscheme.lua`.
- LSP servers installed via mason: angularls, basedpyright, bashls, cssls, eslint, gopls, html, jsonls, lua_ls, rust_analyzer, svelte, tailwindcss, ts_ls, vue_ls, yamlls.
