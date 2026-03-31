---
name: Keymap Convention
description: How to define keymaps in this config
type: feedback
---

The helper.lua functions (`nnoremap`, `vnoremap`, etc.) are being deprecated. Use `local keymap = vim.keymap.set` instead (already set up at the top of `lsp.lua`).

**Why:** User is migrating away from the old helper wrappers toward the standard `vim.keymap.set` aliased as `keymap`.

**How to apply:** When adding new keymaps anywhere in the config, use `local keymap = vim.keymap.set` pattern. Do not add new usages of `nnoremap`/`vnoremap`/etc from `helper.lua`.
