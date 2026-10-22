# Linux-specific configuration.

export BROWSER=firefox-developer-edition

if [[ -r /usr/share/zsh-antidote/antidote.zsh ]]; then
  source /usr/share/zsh-antidote/antidote.zsh
fi

# Show window titles and app IDs when configuring window rules.
getwindows() {
  hyprctl clients
}

alias update='yay -Syu'
