---
name: Snippet Location
description: Where snippets live and how they are loaded
type: feedback
---

Snippets live in `lua/plugins/snippets/`, one file per language. They are loaded automatically by blink.cmp.

**Why:** Keeps snippets co-located with the plugin that consumes them.

**How to apply:** When adding snippets for a new language, create `lua/plugins/snippets/<lang>.lua`. Do not place snippets elsewhere.
