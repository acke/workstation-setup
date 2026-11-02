#!/usr/bin/env bash
# install-dotfiles.sh: symlink files/<path> -> $HOME/<target>, idempotently.
#
# Re-running is safe. Existing real files (not our symlinks) are backed up to
# <target>.bak.<timestamp> before being replaced. Already-correct symlinks are
# left alone.
#
# To track a new dotfile: drop it under files/ and add a "src:dst" entry to
# LINKS below.
#
# Also clones acke/agent-skills to ~/repos/agent-skills (if missing) and links
# its skills/<category>/<skill>/ into ~/.claude/skills and agents/*.md into
# ~/.claude/agents. `git pull` in that repo updates them.

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
  "claude-statusline-tee.sh:.claude/hooks/statusline-tee.sh"
  "claude-usage-guard.sh:.claude/hooks/usage-guard.sh"
  "omniwm:.config/omniwm"
  "omniwm-shortcuts.md:omniwm-shortcuts.md"
)

# link <src> <dst>: symlink, backing up any real file already at <dst>
link() {
  local src="$1" dst="$2"
  if [ ! -e "$src" ]; then
    echo "install-dotfiles: missing source $src" >&2
    return
  fi
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    return
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    cp -R "$dst" "$dst.bak.$NOW" 2>/dev/null
    rm -rf "$dst"
  fi
  ln -s "$src" "$dst"
  echo "install-dotfiles: linked $dst -> $src"
}

for pair in "${LINKS[@]}"; do
  link "$SRC/${pair%%:*}" "$HOME/${pair##*:}"
done

AGENT_SKILLS="$HOME/repos/agent-skills"
if [ ! -d "$AGENT_SKILLS" ]; then
  git clone git@github.com:acke/agent-skills.git "$AGENT_SKILLS" ||
    echo "install-dotfiles: could not clone agent-skills, skipping" >&2
fi
if [ -d "$AGENT_SKILLS" ]; then
  for d in "$AGENT_SKILLS"/skills/*/*/; do
    d="${d%/}"
    link "$d" "$HOME/.claude/skills/$(basename "$d")"
  done
  for f in "$AGENT_SKILLS"/agents/*.md; do
    link "$f" "$HOME/.claude/agents/$(basename "$f")"
  done
fi
