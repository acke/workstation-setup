# All these applications are independent, so if one
# fails to install, don't stop.
echo
echo "Installing editors"
echo "Only installing Visual Studio Code and Vim by default"
echo "Uncomment other editors and rerun if you want them"

brew install --cask visual-studio-code
brew install vim
brew install hx
brew install --cask claude-code
# ribbon: usage-left and prompt-cache band above the Claude Code prompt
claude plugin install ribbon --marketplace robonuggets/ribbon
# neo4j-skills: Neo4j's public agent skills (cypher, drivers, mcp, cli, aura)
claude plugin marketplace add https://github.com/neo4j-contrib/neo4j-skills.git
claude plugin install neo4j-skills@neo4j-skills-marketplace
# claude-code-plugins-plus: community catalogue, marketplace only. Install
# individual plugins by hand after reading their hooks and scripts.
claude plugin marketplace add jeremylongshore/claude-code-plugins

echo
echo "Other editors are available in this script."
echo "Uncomment what you want."
# brew install --cask macdown
# brew install --cask sublime-text
# brew install --cask textmate
# brew install --cask macvim
# brew install --cask jetbrains-toolbox --force # guard against pre-installed jetbrains-toolbox
# brew install --cask atom
