---
name: Memory Save and Sync Behavior
description: How to handle memory saves when user asks to save memory or our work
type: feedback
---

When the user asks to save memory or "our work", always write to BOTH locations and keep them in sync:

1. **Project-level:** `/home/gc/.config/nvim/.memory/` — memory files + `MEMORY.md` index
2. **Global:** `/home/gc/.claude/projects/-home-gc--config-nvim/memory/` — same memory files + `MEMORY.md` index

**Why:** User wants memory accessible both alongside the repo and in the global Claude memory system, and both should reflect the same state.

**How to apply:**
- Write the memory file to both locations
- Update `MEMORY.md` index in both locations
- If a memory already exists in one location, update it in both
- Treat them as mirrors — no divergence between the two
