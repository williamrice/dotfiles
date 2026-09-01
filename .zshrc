# Interactive Zsh entry point. Most configuration lives in ~/.config/zsh.
ZSH_CONFIG_DIR="$HOME/.config/zsh"

case "$OSTYPE" in
  darwin*) source "$ZSH_CONFIG_DIR/macos.zsh" ;;
  linux*)  source "$ZSH_CONFIG_DIR/linux.zsh" ;;
esac

source "$ZSH_CONFIG_DIR/common.zsh"

# Machine-local secrets and private commands.
[[ -r "$ZSH_CONFIG_DIR/local.zsh" ]] && source "$ZSH_CONFIG_DIR/local.zsh"
