# Configuration shared by Linux and macOS.

typeset -U path PATH
path=(
  "$HOME/.config/composer/vendor/bin"
  "$HOME/.symfony5/bin"
  "$HOME/.local/share/nvim/mason/bin"
  "$HOME/.local/bin"
  $path
)

export EDITOR='nvim'

export NVM_DIR="$HOME/.nvm"
if (( ! $+functions[nvm] )); then
  [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
  [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
fi

(( $+functions[antidote] )) && antidote load

autoload -Uz compinit
compinit

alias ls='eza -la --icons --git --mounts'
alias ll='eza -l --icons --git'
alias lt='eza --tree --level=2 --icons'
alias lg='lazygit'
alias dotfiles='git --git-dir="$HOME/.dotfiles" --work-tree="$HOME"'

HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY

if (( $+commands[oh-my-posh] )) && [[ "$TERM_PROGRAM" != Apple_Terminal ]]; then
  eval "$(oh-my-posh init zsh --config "$HOME/.config/oh-my-posh/warice.omp.json")"
fi
