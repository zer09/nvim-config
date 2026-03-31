---
name: Colorscheme Edit Caution
description: How to safely edit the large colorscheme.lua file
type: feedback
---

`colorscheme.lua` is ~370 lines of dense highlight overrides. Always read the specific section using `offset`/`limit` before editing — never rewrite or re-read the whole file.

**Why:** The file is large and easily broken; targeted reads prevent context waste and accidental overwrites.

**How to apply:** Use Grep to locate the relevant highlight group first, then Read with offset/limit to get just that section before editing.
