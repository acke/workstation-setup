#!/usr/bin/env bash
# install-dotfiles.sh: symlink files/<path> -> $HOME/<target>, idempotently.
#
# Re-running is safe. Existing real files (not our symlinks) are backed up to
# <target>.bak.<timestamp> before being replaced. Already-correct symlinks are
# left alone.
#
# To track a new dotfile: drop it under files/ and add a "src:dst" entry to
# LINKS below.

set -u

REPO_ABS="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$REPO_ABS/files"
NOW="$(date +%Y.%m.%d_%H-%M-%S)"

# format: "<files/ subpath>:<$HOME-relative target>"
LINKS=(
  "zshrc:.zshrc"
  "claude.md:.claude/CLAUDE.md"
  "claude-settings.json:.claude/settings.json"
  "claude-pre-push.sh:.claude/hooks/pre-push.sh"
)

for pair in "${LINKS[@]}"; do
  src="$SRC/${pair%%:*}"
  dst="$HOME/${pair##*:}"
  if [ ! -e "$src" ]; then
    echo "install-dotfiles: missing source $src" >&2
    continue
  fi
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    continue
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    cp -R "$dst" "$dst.bak.$NOW" 2>/dev/null
    rm -rf "$dst"
  fi
  ln -s "$src" "$dst"
  echo "install-dotfiles: linked $dst -> $src"
done
