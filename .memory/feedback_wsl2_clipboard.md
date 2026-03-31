---
name: WSL2 Clipboard
description: Clipboard environment is WSL2 with wl-clipboard
type: feedback
---

The environment is WSL2; clipboard integration uses `wl-copy`/`wl-paste` via `wl-clipboard`.

**Why:** Native Linux and macOS clipboard solutions (xclip, pbcopy, etc.) do not work in this environment.

**How to apply:** Any clipboard-related suggestions or configs must account for WSL2 + wl-clipboard, not xclip/xsel/pbcopy.
