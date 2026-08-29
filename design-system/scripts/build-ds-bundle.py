#!/usr/bin/env python3
"""Assemble ds-bundle/ — the upload layout for claude.ai/design.

This repo has no JS build, so /design-sync's converter doesn't apply; this script
is the deterministic path to the same output contract. Style-guide-only scope:
tokens + component CSS + preview cards + README. No _ds_bundle.js.

Run from repo root:  python3 design-system/scripts/build-ds-bundle.py
"""

import re
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent.parent
SRC = ROOT / "design-system"
OUT = ROOT / "ds-bundle"
HEADER = ROOT / ".design-sync" / "conventions.md"

# preview source -> (group dir, component name)
PREVIEWS = [
    ("foundations/colors.html", "foundations", "Color"),
    ("foundations/typography.html", "foundations", "Typography"),
    ("foundations/space-shape.html", "foundations", "SpaceAndShape"),
    ("foundations/syntax.html", "foundations", "SyntaxRoles"),
    ("components/buttons.html", "components", "Buttons"),
    ("components/forms.html", "components", "Forms"),
    ("components/surfaces.html", "components", "Surfaces"),
    ("components/status.html", "components", "Status"),
]

STYLES_CSS = """/* Entry point. Rendered designs receive only this file's @import closure,
   so every stylesheet the system needs must be reachable from here. */
@import "./tokens/theme.css";
@import "./_ds_bundle.css";
"""


def card_meta(html: str) -> dict:
    """Parse the first-line <!-- @dsCard ... --> marker."""
    first = html.split("\n", 1)[0]
    return dict(re.findall(r'(\w+)="([^"]*)"', first))


def main() -> int:
    if OUT.exists():
        shutil.rmtree(OUT)
    (OUT / "tokens").mkdir(parents=True)

    shutil.copy(SRC / "tokens/theme.css", OUT / "tokens/theme.css")
    shutil.copy(SRC / "styles/ds.css", OUT / "_ds_bundle.css")
    (OUT / "styles.css").write_text(STYLES_CSS, encoding="utf-8")

    rows = []
    for rel, group, name in PREVIEWS:
        html = (SRC / rel).read_text(encoding="utf-8")
        meta = card_meta(html)
        dest = OUT / "components" / group / name
        dest.mkdir(parents=True)
        (dest / f"{name}.html").write_text(html, encoding="utf-8")
        rows.append(
            f"| `components/{group}/{name}/{name}.html` | {meta.get('group', '')} "
            f"| {meta.get('name', name)} | {meta.get('subtitle', '')} |"
        )

    readme = [HEADER.read_text(encoding="utf-8").rstrip(), "", "---", ""]
    readme += [
        "## Component index",
        "",
        "Every preview is self-contained (the shared CSS is inlined) so cards render",
        "standalone. The canonical sources are `tokens/theme.css` and `_ds_bundle.css`.",
        "",
        "| Path | Group | Card | Contents |",
        "| --- | --- | --- | --- |",
        *rows,
        "",
        "## Provenance",
        "",
        "Generated from `design-system/` in the user's Neovim config by",
        "`design-system/scripts/build-ds-bundle.py`. The palette is the",
        "`color_overrides` block of `lua/plugins/colorscheme.lua`; light/dark",
        "switching mirrors `auto-dark-mode.nvim` with `flavour = \"auto\"`.",
        "",
    ]
    (OUT / "README.md").write_text("\n".join(readme), encoding="utf-8")

    files = sorted(p.relative_to(OUT).as_posix() for p in OUT.rglob("*") if p.is_file())
    for f in files:
        print(f)
    print(f"{len(files)} file(s) -> {OUT}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
