# Memory Index

- [Memory Save and Sync Behavior](feedback_memory_sync.md) — always save to both project root .memory/ and global, keep in sync
- [File Read Efficiency](feedback_file_read_efficiency.md) — use offset and limit on Read tool, avoid re-reading full files
- [Keymap Convention](feedback_keymap_convention.md) — use `local keymap = vim.keymap.set`; helper.lua wrappers are being deprecated
- [Plugin Keymap Placement](feedback_plugin_keymap_placement.md) — plugin keymaps go in the plugin's keys/config field, not map.lua
- [Plugin Spec Pattern](feedback_plugin_spec_pattern.md) — use opts={} for simple config, config=function() for imperative setup
- [LSP Server Config Location](feedback_lsp_server_config.md) — per-server overrides go in after/lsp/<server>.lua
- [Adding a New LSP Server](feedback_adding_lsp_server.md) — add to ensure_installed in lsp.lua, then create after/lsp/<server>.lua
- [Snippet Location](feedback_snippet_location.md) — one file per language in lua/plugins/snippets/, loaded by blink.cmp
- [No Build or Test Step](feedback_no_build_test.md) — config repo, no CI; changes verified by restarting Neovim
- [lazy-lock.json Handling](feedback_lazy_lock.md) — never manually edit; only update via :Lazy update
- [WSL2 Clipboard](feedback_wsl2_clipboard.md) — clipboard uses wl-clipboard, not xclip/pbcopy
- [Colorscheme Edit Caution](feedback_colorscheme_caution.md) — ~370 lines; use Grep + offset/limit before editing, never rewrite
- [Rocks.nvim Awareness](feedback_rocks_nvim_awareness.md) — config uses both lazy.nvim and rocks.nvim; check which manages a plugin
- [Session Start — Check Memory](feedback_session_start.md) — read .memory/MEMORY.md at the start of each session
- [Project Session Init](project_session_init.md) — what was set up on 2026-03-31 (CLAUDE.md, .memory/, skills)
