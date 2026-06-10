#!/usr/bin/env bash
# PreToolUse hook for `git push`. Runs `make pre-push` from the repo root.
# Skips silently when Makefile or `pre-push` target is missing — repos opt in.
# Blocks the push and feeds failure output back to the model on non-zero exit.

set -u

repo=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0

mf=""
for cand in "$repo/Makefile" "$repo/makefile" "$repo/GNUmakefile"; do
  [ -f "$cand" ] && mf="$cand" && break
done
[ -n "$mf" ] || exit 0
grep -qE '^pre-push[[:space:]]*:' "$mf" || exit 0

out=$(cd "$repo" && make pre-push 2>&1)
status=$?
[ "$status" -eq 0 ] && exit 0

truncated=$(printf '%s\n' "$out" | tail -n 60)
jq -n --arg reason "make pre-push failed (exit $status). Last 60 lines:

$truncated" '{
  hookSpecificOutput: {
    hookEventName: "PreToolUse",
    permissionDecision: "deny",
    permissionDecisionReason: $reason
  }
}'
exit 0
