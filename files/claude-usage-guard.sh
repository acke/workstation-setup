#!/usr/bin/env bash
# PreToolUse/* — denies every tool call once the claude.ai 5-hour or 7-day
# usage window passes its threshold, so unattended runs (loops, reviews,
# overnight implementation) stop before the window is spent.
#
# Source: usage-snapshot.json written by statusline-tee.sh on each status line
# render. A snapshot older than 30 min is ignored (fail-open), so headless
# sessions that never render a status line are not guarded.
#
# Env:
#   CLAUDE_USAGE_GUARD=off   disable
#   CLAUDE_USAGE_GUARD_5H    5-hour threshold in percent (default 80)
#   CLAUDE_USAGE_GUARD_7D    7-day threshold in percent (default 90)

[ "${CLAUDE_USAGE_GUARD:-on}" = "off" ] && exit 0
command -v jq >/dev/null || exit 0

snap="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/usage-snapshot.json"
[ -f "$snap" ] || exit 0

reason=$(jq -r \
  --argjson max5 "${CLAUDE_USAGE_GUARD_5H:-80}" \
  --argjson max7 "${CLAUDE_USAGE_GUARD_7D:-90}" '
  def when: if type == "number" then localtime | strftime("%Y-%m-%d %H:%M") else "unknown" end;
  if (now - .ts) > 1800 then empty else
    (.rate_limits.five_hour // {}) as $h
    | (.rate_limits.seven_day // {}) as $d
    | if ($h.used_percentage // 0) >= $max5 then
        "5-hour window at \($h.used_percentage)% (limit \($max5)%), resets \($h.resets_at | when)"
      elif ($d.used_percentage // 0) >= $max7 then
        "7-day window at \($d.used_percentage)% (limit \($max7)%), resets \($d.resets_at | when)"
      else empty end
  end' "$snap" 2>/dev/null)

[ -n "$reason" ] || exit 0

jq -n --arg r "$reason" '{
  hookSpecificOutput: {
    hookEventName: "PreToolUse",
    permissionDecision: "deny",
    permissionDecisionReason: ("USAGE GUARD: " + $r + ". Stop all work now. Do not retry, use another tool, or work around this. Report where you stopped so the user can resume after the window resets.")
  }
}'
exit 0
