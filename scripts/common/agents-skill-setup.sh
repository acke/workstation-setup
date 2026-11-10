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
