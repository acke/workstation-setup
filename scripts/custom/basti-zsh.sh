echo "Installing oh-my-zsh"
OH_DIR=~/.oh-my-zsh
NOW=$(date +"%Y.%m.%d_%H-%M-%S")

# backup local config
cp ~/.zshrc.local ~/.zshrc.local."$NOW"

# install oh-my-zsh, but respect existing installation
if [[ ! -d $OH_DIR ]]
then
  git clone https://github.com/ohmyzsh/ohmyzsh.git $OH_DIR
  cp ~/.zshrc ~/.zshrc.orig."$NOW"
  cp $OH_DIR/templates/zshrc.zsh-template ~/.zshrc
fi

if [[ ! $(basename "$SHELL") == "zsh" ]]
then
  chsh -s "$(which zsh)"
fi

cp "$WORK_DIR"/files/dircolors.ansi-dark "$HOME"/.dircolors

echo "Installing zsh-autosuggestions"
brew install zsh-autosuggestions

# configure zsh plugins
PLUGINS="plugins=(git gitfast git-extras github pip kubectl docker golang gradle helm iterm2 mercurial mvn nmap npm python rust aws cloudfoundry common-aliases brew vscode gcloud)"
rg --passthru -N "^plugins=.*" -r "$PLUGINS" ~/.zshrc > /tmp/.zshrc && mv /tmp/.zshrc ~/.zshrc


# avoid duplicate sourcing of .zshrc.local and ensure it is last
grep -v .zshrc.local ~/.zshrc > /tmp/zshrc.tmp && mv /tmp/zshrc.tmp ~/.zshrc
echo "source ~/.zshrc.local" >> ~/.zshrc


cat <<EOF > ~/.zshrc.local
DISABLE_UPDATE_PROMPT=true
GOPATH=\$HOME/workspace/go
GOROOT="\$(brew --prefix golang)/libexec"
PATH=\$HOME/.cargo/bin:$HOME/bin:/usr/local/bin:\${PATH}
PATH=\$GOROOT/bin:$PATH:$GOPATH/bin:\$HOME/pact/bin
EDITOR='nvim'

ASPATH=/usr/local/share/zsh-autosuggestions
if [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  ASPATH=/usr/share/zsh-autosuggestions
fi
source \$ASPATH/zsh-autosuggestions.zsh

export EDITOR
export GITHUB_TOKEN
export GOPATH
export GOROOT
export PATH

alias git='git-together'
alias git-pull-all='find . -type d -depth 1 -exec git -C {} pull \;'
alias gpa=git-pull-all
alias ls='lsd'
alias dir='ls -lah'
alias z="zoxide"
alias vi=nvim
alias cat='bat -p'

# disable FZF keybinding for history (ctrl-r) even if initialized in other file in favor for mcfly
bindkey -r "^R"
rg --passthru -N "bindkey '\^R' fzf-history-widget" -r "# bindkey '^R' fzf-history-widget" \$HOME/.fzf/shell/key-bindings.zsh > \$HOME/.fzf/shell/key-bindings.without-history.zsh

[ -f \$HOME/.fzf/shell/key-bindings.without-history.zsh ] && source \$HOME/.fzf/shell/key-bindings.without-history.zsh
eval "\$(direnv hook zsh)"
eval "\$(zoxide init zsh)"
eval "\$(mcfly init zsh)"
eval "\$(fnm env)"

# add git-together pairing credentials to prompt
function pairing_initials {
  if [[ \$(git rev-parse --is-inside-work-tree 2>/dev/null) == "true" ]]
  then
    GIT_TOGETHER=\$(git config git-together.active)
    if [[ \$GIT_TOGETHER != "" ]]
    then
      echo -e "[\$GIT_TOGETHER] "
    else
      echo -e ""
    fi
  fi
}
export PAIRING_INITIALS='%{%F{2}%}\$(pairing_initials)%{\${reset_color}%}'
export PROMPT="\$PAIRING_INITIALS\$PROMPT"

source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

test -d "\${GOPATH}" || mkdir "\${GOPATH}"
test -d "\${GOPATH}/src/github.com" || mkdir -p "\${GOPATH}/src/github.com"

# git commit signing
export GPG_TTY=\$(tty)
SECRET_KEY=\$(gpg --list-secret-keys --keyid-format=long|head -4|tail -1|xargs)
CONFIGURED_SIGNING_KEY=\$(git config --global user.signingkey)
cd ~/workspace/workstation-setup/
if [[ \$SECRET_KEY != \$CONFIGURED_SIGNING_KEY ]]
then
  echo "Configuring git signing key"
  git config --global user.signingkey \$SECRET_KEY
fi
cd -
EOF
cp "${WORK_DIR}"/scripts/custom/basti.zsh-theme "${OH_DIR}"/themes/
sed -i '' -e "s/ZSH_THEME=\".*$/ZSH_THEME=\"basti\"/g" ~/.zshrc
echo "You can find your custom zsh config in ~/.zshrc.local"
