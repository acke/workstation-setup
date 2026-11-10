echo
echo "Installing pm-claude-skills into Claude Code"
# --agent claude skips the interactive tool picker
npx --yes pm-claude-skills add --agent claude ||
  echo "pm-claude-skills: install failed, skipping" >&2
