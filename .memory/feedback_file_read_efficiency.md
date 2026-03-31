---
name: File Read Efficiency
description: How to efficiently read files using offset and limit parameters
type: feedback
---

Always use `offset` and `limit` parameters on the Read tool to read only the sections needed.

**Why:** Reading entire large files multiple times wastes significant context tokens.

**How to apply:**
- Before reading a file, consider which section is relevant and target it with `offset` + `limit`
- Only read the full file on first encounter or when the relevant section is unknown
- Re-reading an entire file to find a few lines is not acceptable
