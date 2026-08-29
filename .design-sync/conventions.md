# Catppuccin (nvim) — how to build with this system

A plain-CSS design system derived from a Neovim theme: Catppuccin as the engine,
Gruvbox Material as the palette. **There are no React components and no JS bundle.**
Build with ordinary HTML/JSX elements and style them with the `ds-*` classes and
`--ds-*` custom properties below. Do not invent new class names — every class you
need is enumerated here.

## Setup — no provider, one stylesheet

There is no wrapper component. Import `_ds/<folder>/styles.css` (it `@import`s
`tokens/theme.css` then `_ds_bundle.css`) and put `class="ds-page"` on `<body>`
or the outermost element. Without `ds-page` the background stays the host's and
the whole system reads wrong.

```jsx
<body className="ds-page">
  <h1 className="ds-title">Format buffer</h1>
  <p className="ds-sub">Runs stylua on save.</p>
  <div className="ds-row">
    <button className="ds-btn ds-btn--primary">Run</button>
    <button className="ds-btn ds-btn--ghost">Cancel</button>
  </div>
</body>
```

## Light and dark

Tokens are **ambient** — they follow `prefers-color-scheme` with no attribute or
class needed. To pin a subtree (side-by-side comparisons only), add `scheme-light`
or `scheme-dark`. Never hardcode a hex; always go through a token, or the pinned
subtree and dark mode both break.

## Class vocabulary — the complete list

| Family | Classes |
| --- | --- |
| Page & layout | `ds-page` `ds-head` `ds-title` `ds-sub` `ds-section` `ds-label` `ds-row` `ds-stack` `ds-grid` `ds-split` `ds-pane` `ds-note` |
| Buttons | `ds-btn` + `ds-btn--primary` `ds-btn--secondary` `ds-btn--ghost` `ds-btn--danger` `ds-btn--sm` `ds-btn--lg`; `ds-kbd` |
| Forms | `ds-field` `ds-input` `ds-input--error` `ds-select` `ds-textarea` `ds-help` `ds-help--error` `ds-check` `ds-switch` |
| Surfaces | `ds-card` `ds-card__title` `ds-card__body`; `ds-float` `ds-float__title` `ds-float__body` `ds-float__item` |
| Status | `ds-badge` + `ds-badge--success` `--attention` `--warning` `--danger` `--info` `--hint` `--neutral`; `ds-alert` `ds-alert__icon` + `ds-alert--success` `--warning` `--danger` `--info`; `ds-progress` |
| Chrome | `ds-statusline` `ds-sl-mode` `ds-sl-mode--i` `ds-sl-mode--v` `ds-sl-branch` `ds-sl-spacer` `ds-sl-noice`; `ds-tabs` `ds-tab` |
| Code | `ds-code` + token spans `tok-kw` `tok-fn` `tok-ty` `tok-str` `tok-num` `tok-prop` `tok-op` `tok-com` `tok-var` `tok-punct`; `ln` for gutter numbers |
| Swatches | `ds-swatch` `ds-swatch__chip` `ds-swatch__meta` `ds-swatch__name` `ds-swatch__hex` |

State is expressed with **attributes, not classes**: `aria-selected="true"` on
`ds-tab` and `ds-float__item`, `aria-checked` on `ds-switch`, `disabled` on
`ds-btn`.

## Tokens — for your own layout glue

Surfaces `--ds-bg` `--ds-bg-sunken` `--ds-bg-deep` `--ds-surface`
`--ds-surface-raised` `--ds-surface-high` · lines `--ds-line` `--ds-line-strong` ·
text `--ds-text` `--ds-text-muted` `--ds-text-subtle` `--ds-text-faint`
`--ds-text-on-accent` · palette `--ds-red` `--ds-orange` `--ds-yellow`
`--ds-green` `--ds-aqua` `--ds-blue` `--ds-purple` · semantic `--ds-accent`
`--ds-success` `--ds-attention` `--ds-warning` `--ds-danger` `--ds-info`
`--ds-hint` · space `--ds-1`…`--ds-7` (4/8/12/16/24/32/48px) · radius
`--ds-r-sm` `--ds-r-md` `--ds-r-lg` `--ds-r-full` · type `--ds-font-mono`
`--ds-font-ui` `--ds-fs-xs`…`--ds-fs-3xl` · `--ds-border` `--ds-focus-ring`
`--ds-shadow-card` `--ds-shadow-float` `--ds-motion` `--ds-motion-fast`.

## Rules that carry the character

- **Monospace is the display face.** Headings, labels, buttons, data, and form
  values all use `--ds-font-mono`; `--ds-font-ui` is for prose only.
- **Weights are 400 and 700.** Bold is the only emphasis in headings.
- **Chrome steps down, not up.** Sidebars and tab strips use `--ds-bg-sunken` or
  `--ds-bg-deep`; content stays on `--ds-bg`. Never a lighter gray than the page.
- **Borders are blue.** `--ds-accent` at 1px — never a darker shade of the surface.
- **Three elevation levels only:** flush, `ds-card`, `ds-float`. Overlays are
  translucent and blurred rather than heavily shadowed.
- **One primary button per view.** Green is the only large accent fill.
- **Semantic color is fixed:** red fails, orange changed, green added or passing,
  yellow warns, blue informs, aqua hints.

## Where the truth lives

`_ds/<folder>/styles.css` → `tokens/theme.css` (all tokens, both modes) and
`_ds_bundle.css` (every class above). Read them before styling. The
`components/` previews are working examples of each family.
