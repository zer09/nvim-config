---
name: Rocks.nvim Awareness
description: This config uses both lazy.nvim and rocks.nvim as plugin managers
type: feedback
---

The config uses both `lazy.nvim` and `rocks.nvim`. They manage different packages.

**Why:** Some packages are better suited for rocks.nvim (luarocks packages), while most Neovim plugins go through lazy.nvim.

**How to apply:** When adding a plugin, check which manager is appropriate. Do not assume all plugins go through lazy.nvim.
