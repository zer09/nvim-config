---
name: Plugin Keymap Placement
description: Where plugin-specific keymaps should be defined
type: feedback
---

Plugin-specific keymaps belong in the plugin's `keys` or `config` field inside its lazy.nvim spec — not in `map.lua`.

**Why:** Keeps keymaps co-located with the plugin they control, making it easier to manage and lazy-load.

**How to apply:** When adding keymaps for a plugin, put them inside that plugin's file in `lua/plugins/`, not in `lua/map.lua`.
