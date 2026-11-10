# Claude Code plugins and skills. Each install is independent, so if one
# fails, don't stop. Needs `claude` on PATH (installed in editors.sh).
echo
echo "Installing Claude Code plugins"

# ribbon: usage-left and prompt-cache band above the Claude Code prompt
claude plugin install ribbon --marketplace robonuggets/ribbon

# neo4j-skills: Neo4j's public agent skills (cypher, drivers, mcp, cli, aura)
claude plugin marketplace add https://github.com/neo4j-contrib/neo4j-skills.git
claude plugin install neo4j-skills@neo4j-skills-marketplace

# claude-code-plugins-plus: community catalogue. Only plugins with no hooks and
# no MCP server are installed here; read a plugin's hooks, scripts and
# .mcp.json before adding it below.
claude plugin marketplace add jeremylongshore/claude-code-plugins
for plugin in \
  linear-pack \
  cli-ux-tester \
  contract-test-validator \
  api-fuzzer \
  api-test-automation \
  code-cleanup
do
  claude plugin install "${plugin}@claude-code-plugins-plus"
done
# Not installed: pr-to-spec (bundled MCP server that receives GITHUB_TOKEN),
# conversational-api-debugger and project-health-auditor (bundled MCP servers).

# agent-skills: personal skills and agents, symlinked into ~/.claude. Every
# category under skills/ is linked except those in AGENT_SKILLS_SKIP
# (space-separated, default: gaming). `git pull` in the repo updates them.
echo
echo "Linking skills and agents from agent-skills"

AGENT_SKILLS="$HOME/repos/agent-skills"
AGENT_SKILLS_SKIP="${AGENT_SKILLS_SKIP:-gaming}"

if [ ! -d "$AGENT_SKILLS" ]; then
  git clone git@github.com:acke/agent-skills.git "$AGENT_SKILLS" ||
    echo "agents-skill-setup: could not clone agent-skills, skipping" >&2
fi

# link_claude <src> <dst>: symlink, backing up anything already at <dst>
link_claude() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    return
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    cp -R "$dst" "$dst.bak.$(date +%Y.%m.%d_%H-%M-%S)" 2>/dev/null
    rm -rf "$dst"
  fi
  ln -s "$src" "$dst"
  echo "agents-skill-setup: linked $dst -> $src"
}

# The brain and reflect skills and the SessionStart hook read ~/.claude/brain.
if [ -d "$HOME/repos/brain" ] && [ ! -e "$HOME/.claude/brain" ]; then
  link_claude "$HOME/repos/brain" "$HOME/.claude/brain"
fi

if [ -d "$AGENT_SKILLS" ]; then
  for category in "$AGENT_SKILLS"/skills/*/; do
    category="${category%/}"
    case " $AGENT_SKILLS_SKIP " in
      *" $(basename "$category") "*) continue ;;
    esac
    for skill in "$category"/*/; do
      skill="${skill%/}"
      link_claude "$skill" "$HOME/.claude/skills/$(basename "$skill")"
    done
  done
  for agent in "$AGENT_SKILLS"/agents/*.md; do
    link_claude "$agent" "$HOME/.claude/agents/$(basename "$agent")"
  done
fi

# skills-and-agents: skills, agents and workflows (reflect, brain, unslop, ...)
# synced by scripts/custom/sync/skills-and-agents-sync, which skips Snyk-bound
# items and never links hooks. The shell also runs it daily (files/zshrc).
echo
echo "Syncing skills-and-agents"

SKILLS_AND_AGENTS="$HOME/repos/skills-and-agents"

if [ ! -d "$SKILLS_AND_AGENTS" ]; then
  git clone git@github.com:acke/skills-and-agents.git "$SKILLS_AND_AGENTS" ||
    echo "agents-skill-setup: could not clone skills-and-agents, skipping" >&2
fi

if [ -d "$SKILLS_AND_AGENTS" ]; then
  bash "${WORK_DIR}/scripts/custom/sync/skills-and-agents-sync"

  # Hooks are linked one by one after review, and registered in
  # files/claude-settings.json. Add a name here only after reading the hook.
  for hook in \
    block-gh-admin.sh \
    block-no-verify.sh \
    no-deflection.py \
    post-push-reflect-trigger.sh \
    session-start-load-unslop.sh \
    warn-no-test-evidence.py
  do
    link_claude "$SKILLS_AND_AGENTS/hooks/$hook" "$HOME/.claude/hooks/$hook"
  done
fi
