# macOS-specific configuration.

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

export NVM_DIR="$HOME/.nvm"
if [[ -s /opt/homebrew/opt/nvm/nvm.sh ]]; then
  source /opt/homebrew/opt/nvm/nvm.sh
fi
if [[ -s /opt/homebrew/opt/nvm/etc/bash_completion.d/nvm ]]; then
  source /opt/homebrew/opt/nvm/etc/bash_completion.d/nvm
fi

path=(
  "/opt/homebrew/opt/libpq/bin"
  "$HOME/.lando/bin"
  "$HOME/.dotnet/tools"
  "$HOME/.composer/vendor/bin"
  "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
  $path
)

export COMPOSER_HOME="$HOME/.composer"
export TERMINUS_ALLOW_UNSUPPORTED_NEWER_PHP=1
export DOTNET_CLI_TELEMETRY_OPTOUT=true
export OPENCODE_ENABLE_EXA=1

alias nvc='nvim ~/.config/nvim'
alias python='python3'
alias pip='pip3'
alias flushdns='sudo killall -HUP mDNSResponder'

if (( $+commands[brew] )); then
  antidote_init="$(brew --prefix)/opt/antidote/share/antidote/antidote.zsh"
  [[ -r "$antidote_init" ]] && source "$antidote_init"
  unset antidote_init
fi
