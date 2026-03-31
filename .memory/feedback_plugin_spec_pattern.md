---
name: Plugin Spec Pattern
description: When to use opts vs config in lazy.nvim specs
type: feedback
---

Use `opts = {}` for simple key-value configuration. Use `config = function() ... end` when you need to call setup functions or do any imperative work.

**Why:** Keeps specs clean and consistent; lazy.nvim handles `opts` automatically by calling `require("plugin").setup(opts)`.

**How to apply:** Default to `opts`. Only reach for `config` when setup requires logic beyond passing a table.
