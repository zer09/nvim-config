---
name: No Build or Test Step
description: This repo has no build or test workflow
type: feedback
---

This is a Neovim config repo — there is no build step, no test suite, and no CI.

**Why:** Changes take effect by restarting Neovim or sourcing the relevant file.

**How to apply:** Never suggest running tests, builds, or linting pipelines. To verify changes, the user restarts Neovim or uses `:source %`.
