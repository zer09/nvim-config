#!/usr/bin/env python3
"""Inline tokens/theme.css and styles/ds.css into every preview HTML.

Preview files must be self-contained (the Design System pane and Artifacts both
block external stylesheets), so the shared CSS is injected between markers:

    /* @ds:start */ ... /* @ds:end */

Edit the source CSS, run this, commit. Never hand-edit inside the markers.
"""

from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
START = "/* @ds:start */"
END = "/* @ds:end */"


def main() -> int:
    css = "\n".join(
        (ROOT / name).read_text(encoding="utf-8").strip()
        for name in ("tokens/theme.css", "styles/ds.css")
    )
    block = f"{START}\n{css}\n{END}"

    changed = []
    for html in sorted(ROOT.rglob("*.html")):
        text = html.read_text(encoding="utf-8")
        if START not in text or END not in text:
            print(f"skip (no markers): {html.relative_to(ROOT)}")
            continue
        head, rest = text.split(START, 1)
        _, tail = rest.split(END, 1)
        updated = head + block + tail
        if updated != text:
            html.write_text(updated, encoding="utf-8")
            changed.append(html.relative_to(ROOT))

    for path in changed:
        print(f"updated: {path}")
    print(f"{len(changed)} file(s) updated")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
