---
name: Session Start — Check Memory
description: At session start, load MEMORY.md index then proactively read relevant memory files — don't wait for the user to ask
type: feedback
---

When a session starts and the MEMORY.md index is injected by the load-repo-memory hook, proactively read the individual memory files — especially feedback entries — without waiting for the user to ask.

**Why:** The MEMORY.md index alone doesn't provide file content. The user expects Claude to arrive already briefed, not needing to be explicitly prompted to "load memory."

**How to apply:** At session start, after receiving the MEMORY.md index, read all feedback files. Project and reference memories are lower priority unless the task clearly touches them (they can be derived from code/git history).
