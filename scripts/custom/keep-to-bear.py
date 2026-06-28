#!/usr/bin/env python3
"""
Convert a Google Takeout Keep export into Bear notes.

Usage:
  python3 keep-to-bear.py /path/to/Takeout/Keep

Bear must be running. Each note is imported via the bear:// URL scheme.
Trashed notes are skipped. Keep labels become Bear tags.
"""

import json
import os
import subprocess
import sys
import time
import urllib.parse
from pathlib import Path


def list_to_markdown(items):
    lines = []
    for item in items:
        checked = "x" if item.get("isChecked") else " "
        lines.append(f"- [{checked}] {item['text']}")
    return "\n".join(lines)


def note_to_markdown(note):
    if "listContent" in note:
        return list_to_markdown(note["listContent"])
    return note.get("textContent", "")


def import_note(title, body, tags):
    params = urllib.parse.urlencode({
        "title": title,
        "text": body,
        "tags": ",".join(tags),
        "open_note": "no",
    })
    url = f"bear://x-callback-url/create?{params}"
    subprocess.run(["open", url], check=True)
    # Bear needs a moment between imports to avoid dropping notes
    time.sleep(0.15)


def main():
    if len(sys.argv) < 2:
        print("Usage: keep-to-bear.py <path/to/Takeout/Keep>", file=sys.stderr)
        sys.exit(1)

    keep_dir = Path(sys.argv[1])
    if not keep_dir.is_dir():
        print(f"Not a directory: {keep_dir}", file=sys.stderr)
        sys.exit(1)

    json_files = sorted(keep_dir.glob("*.json"))
    if not json_files:
        print("No .json files found in that directory.", file=sys.stderr)
        sys.exit(1)

    skipped = 0
    imported = 0

    for path in json_files:
        note = json.loads(path.read_text())

        if note.get("isTrashed"):
            skipped += 1
            continue

        title = note.get("title", "").strip()
        body  = note_to_markdown(note).strip()
        tags  = [label["name"] for label in note.get("labels", [])]

        if note.get("isArchived"):
            tags.append("archived")

        if not title and not body:
            skipped += 1
            continue

        import_note(title, body, tags)
        imported += 1
        print(f"  [{imported:>4}] {title or '(untitled)'}")

    print(f"\nDone — {imported} imported, {skipped} skipped (trashed/empty).")


if __name__ == "__main__":
    main()
