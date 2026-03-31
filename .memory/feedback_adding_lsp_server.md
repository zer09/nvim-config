---
name: Adding a New LSP Server
description: The pattern for adding a new LSP server to this config
type: feedback
---

To add a new LSP server:
1. Add it to `ensure_installed` in `mason-lspconfig` inside `lua/plugins/lsp.lua`
2. Create `after/lsp/<server>.lua` for any server-specific settings/overrides

**Why:** This is the established two-step pattern — mason installs, after/lsp/ configures.

**How to apply:** Never configure a server inline in lsp.lua's main setup block; always use the after/lsp/ file for per-server config.
