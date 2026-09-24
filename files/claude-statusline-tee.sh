#!/usr/bin/env bash
# statusLine — snapshots claude.ai rate_limits for usage-guard.sh on every
# status line render, then hands the same JSON to ccstatusline unchanged.
# Snapshot: $CLAUDE_CONFIG_DIR/usage-snapshot.json (default ~/.claude).
# Only written when rate_limits is present, so API-key sessions never wipe it.

input=$(cat)
snap="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/usage-snapshot.json"

if out=$(printf '%s' "$input" | jq -ce 'select(.rate_limits) | {ts: (now | floor), rate_limits}' 2>/dev/null); then
  printf '%s\n' "$out" > "$snap.tmp" && mv "$snap.tmp" "$snap"
fi

printf '%s' "$input" | npx -y ccstatusline@latest
