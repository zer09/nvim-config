---
name: lazy-lock.json Handling
description: How to handle the plugin lock file
type: feedback
---

Never manually edit `lazy-lock.json`. It is only updated intentionally via `:Lazy update` inside Neovim.

**Why:** Manual edits can corrupt plugin state or cause version mismatches.

**How to apply:** If a plugin version change is needed, instruct the user to run `:Lazy update` in Neovim, not to edit the file directly.
