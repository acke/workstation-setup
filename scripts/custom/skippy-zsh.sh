echo "Installing oh-my-zsh"
OH_DIR=~/.oh-my-zsh

# install oh-my-zsh, but respect existing installation
if [[ ! -d $OH_DIR ]]
then
  git clone https://github.com/ohmyzsh/ohmyzsh.git $OH_DIR
fi

if [[ ! $(basename "$SHELL") == "zsh" ]]
then
  chsh -s "$(which zsh)"
fi

cp "$WORK_DIR"/files/dircolors.ansi-dark "$HOME"/.dircolors

echo "Installing zsh-autosuggestions"
brew install zsh-autosuggestions

# Custom theme is available if you want it (set ZSH_THEME="skippy" in zshrc).
cp "${WORK_DIR}"/scripts/custom/skippy.zsh-theme "${OH_DIR}"/themes/

# Symlink tracked dotfiles (files/zshrc, ...) into $HOME. Idempotent.
bash "${WORK_DIR}"/scripts/install-dotfiles.sh

echo "Dotfiles are symlinked from $(cd "${WORK_DIR}" && pwd)/files/."
echo "Edit them there (or via the symlinks in \$HOME) to sync across machines."
