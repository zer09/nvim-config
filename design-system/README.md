# Gruvbox Material — design system

A web design system derived from this config's active editor theme:
Catppuccin as the engine, **Gruvbox Material** as the actual palette
(`lua/plugins/colorscheme.lua` overrides every color in both flavours), with
`auto-dark-mode.nvim` switching between them.

## What the theme dictates

| Editor fact | Design rule |
| --- | --- |
| `flavour = "auto"` + auto-dark-mode | Every surface ships light *and* dark; ambient by default |
| latte base `#f9f5d7`, mocha base `#1d2021` | Warm paper / warm near-black — no pure white or black |
| 7 gruvbox accents, nothing else | One hue per meaning; no extra brand color |
| `Function` green bold, `Type` yellow bold | Bold is the only weight emphasis; green = action, yellow = shape |
| `border = "rounded"`, 1px | 4/6/10px radii, hairline borders |
| `winblend = 10` on floats | Overlays are ~92% opaque + blurred, not solid |
| lualine `component_separators = ""` | Flat segments, no decorative chrome |
| Borders set to `lavender` (= blue) | Blue is the border/focus color, not a shade of gray |

## Layout

```
tokens/theme.css      canonical tokens (light + dark + semantic + syntax roles)
styles/ds.css         component layer — reads tokens only
foundations/*.html    color, typography, space & shape, syntax roles
components/*.html     buttons, forms, surfaces & overlays, status & feedback
scripts/sync-tokens.py inlines the two CSS files into every preview
```

Preview files must be self-contained (no external stylesheets), so the shared CSS
is inlined between `/* @ds:start */` and `/* @ds:end */`.

**Edit `tokens/theme.css` or `styles/ds.css`, never the marker block:**

```sh
python3 design-system/scripts/sync-tokens.py
```

## Forcing a mode

Tokens are ambient (`prefers-color-scheme`) by default. Add `.scheme-light` or
`.scheme-dark` to any element to pin that subtree — that's how the previews show
both modes side by side.

## Design-sync

Each preview carries a first-line `<!-- @dsCard group="…" -->` marker, so the
Design System pane builds its card index automatically. Push with `/design-sync`
from this directory.
