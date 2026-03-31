---
name: LSP Server Config Location
description: Where per-server LSP overrides go
type: feedback
---

Per-server LSP configuration overrides go in `after/lsp/<server>.lua`, not inside `lua/plugins/lsp.lua`.

**Why:** Neovim's `after/` mechanism loads these automatically per server, keeping lsp.lua clean.

**How to apply:** When tweaking settings for a specific LSP server (e.g., basedpyright, ts_ls), create or edit `after/lsp/<server>.lua`.
