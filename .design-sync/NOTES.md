# design-sync notes

## This repo is outside the converter's envelope

It's a Neovim config: no `package.json`, no JS, no Storybook, no `dist/`. The
`/design-sync` converter (`package-build.mjs`) cannot run here, and neither can
`package-validate.mjs` or the screenshot-capture harness — they all assume a
compiled component bundle.

The upload layout is produced instead by
`design-system/scripts/build-ds-bundle.py`, which is deterministic and
re-runnable. Verification is a name-resolution gate rather than a render gate:
every class and `--ds-*` token named in `conventions.md` is checked to exist in
the built `_ds_bundle.css` / `tokens/theme.css` (113 names, all resolving as of
the first sync).

## Scope: style-guide-only (user's choice, 2026-08-09)

No `_ds_bundle.js` is uploaded — there are no React components to ship, and
authoring them would be invention rather than shipping what exists. The design
agent gets tokens, the `ds-*` class vocabulary, and the preview cards. If
importable components are wanted later, that's a separate build: author React
components from `_ds_bundle.css`, bundle with esbuild, emit `.d.ts` +
`.prompt.md` per component, then the normal converter path applies.

## No `_ds_sync.json` anchor

The sidecar's `keyRecipe` / `scriptsSha` describe the converter's own build; this
build doesn't use those scripts, so a hand-written anchor would vouch for
something that isn't true. Omitted deliberately — the consequence is that every
re-sync re-verifies and re-uploads all files, which is cheap at this size.

## Gotchas hit

- `finalize_plan`'s `localDir` resolves against the shell's *current* working
  directory, which persists across Bash calls. Pass an absolute path.
- The conventions validator must strip ``` fenced blocks before pairing inline
  backticks, or the fence desyncs the pairing and silently under-reports the
  claimed names (first run reported 7 instead of 113).
- Preview HTML must stay self-contained; shared CSS is inlined into each card by
  `design-system/scripts/sync-tokens.py`. Edit `tokens/theme.css` or
  `styles/ds.css`, never the `/* @ds:start */` block, then re-run both scripts.

## Re-sync procedure

```sh
python3 design-system/scripts/sync-tokens.py      # inline shared CSS into cards
python3 design-system/scripts/build-ds-bundle.py  # assemble ds-bundle/
```
Then upload `ds-bundle/` to project `163844d2-c715-4022-afd9-659a162a3d90`,
sentinel-first and sentinel-last.
