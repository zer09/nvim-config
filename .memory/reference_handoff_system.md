---
name: Handoff System (Claude ↔ Gemini)
description: How Claude Code and Gemini CLI communicate via .memory/handoff/ files when Gilbert relays work between them
type: reference
---

## Purpose

Claude Code and Gemini CLI cannot talk to each other directly. Gilbert is the relay. Handoff files are the shared scratchpad — written by one assistant, read by the other when Gilbert points to it.

## Directory layout

| What | Path |
|------|------|
| Active roster | `.memory/handoff/index.md` |
| Per-topic file | `.memory/handoff/handoff-{topic}.md` |

## Handoff file format

Every `handoff-{topic}.md` must start with:

```
Last updated: YYYY-MM-DD
Status: <in-progress | needs-review | blocked | done>

## Summary
<one or two lines: what this topic is about>

## What was done
<bullet list of completed work>

## What's next
<bullet list of remaining work or decisions needed>

## Files touched (Optional)
<skip if git status/diff is sufficient; use only for files not obvious from git>

## Open questions / decisions for Gilbert
<anything that needs human input>
```

## Conventions

- **Naming:** Short kebab-case (e.g. `handoff-lsp-refactor.md`, `handoff-colorscheme.md`)
- **Roster:** Maintain `.memory/handoff/index.md` as a status-at-a-glance view for Gilbert. Add a row when opening a topic; remove or mark archived when closing.
- **Ephemeral:** Handoff files are NOT listed in `MEMORY.md` and NOT dual-written to Claude auto-memory.
- **Cleanup:** Delete or rename with `-archived` suffix when the topic is done.

## Source of truth

- **Git** (`git status`, `git diff HEAD`) is the source of truth for *what files changed*.
- **Handoff file** is the source of truth for *why* (intent) and *what's next* (strategy).
- Don't duplicate file lists in the handoff if `git status` already makes it obvious.

## Operating habit (The Gilbert Relay)

- **The Human Trigger (Primary):** Gilbert will say when he's switching assistants. The outgoing assistant must update the relevant handoff file(s) and the index.
- **Trigger phrases:**
  - `"update the handoff"` — outgoing assistant writes their update
  - `"read the handoff for [topic]"` — incoming assistant reads and continues
  - `"take over from [assistant]"` — incoming assistant checks index and picks up in-progress topics
- **Smart Auto-Detection (Backup):** If the git tree is dirty, check `index.md` first. Only open handoff files marked `in-progress`. Don't scan the directory blindly — archived or done files are noise.
- Keep updates short and factual — the next assistant needs enough to continue, not a full retelling.
