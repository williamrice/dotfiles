# Linux-specific configuration.

export GTK_THEME=Adwaita:dark

if [[ -r /usr/share/zsh-antidote/antidote.zsh ]]; then
  source /usr/share/zsh-antidote/antidote.zsh
fi

# Show window titles and app IDs when configuring window rules.
getwindows() {
  swaymsg -t get_tree | grep -E '"app_id"|"name"'
}

alias update='yay -Syu'
