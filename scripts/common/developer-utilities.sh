#!/usr/bin/env bash
echo

# Don't exit if any of these fail
set +e
  brew install rust
  brew install lazygit
  brew install --cask lm-studio
  brew install --cask dash # api browser
  brew install --cask postman # api interaction tool
  brew install --cask quicklook-json # OSX tool for viewing JSON
  brew install fzf
  "$(brew --prefix)/opt/fzf/install" --all --no-bash --no-fish
  brew install zoxide
  brew install asdf
  brew install zsh-autosuggestions
  brew install tmux
  brew install autojump
  brew install mcfly
  curl -fsSL https://openclaw.ai/install.sh | bash
set -e
