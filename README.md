# Dotfiles

Personal configuration managed as a bare Git repository with `$HOME` as its
work tree.

## Lightweight server install

Installs only Zsh and Neovim configuration:

```sh
curl -fsSL https://raw.githubusercontent.com/williamrice/dotfiles/main/install-lite.sh | sh
```

## Full install

Installs tracked home configuration files, scripts in `~/.local/bin`, and assets
in `~/Pictures`:

```sh
curl -fsSL https://raw.githubusercontent.com/williamrice/dotfiles/main/install.sh | sh
```

Existing tracked paths are copied to `~/.dotfiles-backup/` before replacement.
Only Git-tracked files are installed; unrelated scripts, pictures, and
machine-local secrets are not installed.

Both installers warn when tools used by the configuration are missing from the
current `PATH`, including Zsh, Neovim, eza, fzf, ripgrep (`rg`), fd, lazygit,
git-delta (`delta`), Node/npm, and native plugin build/download tools. The full
installer also checks Oh My Posh and, on Linux, desktop tools such as Hyprland, Hyprlock,
Hypridle, Hyprpaper, Waybar, and the screenshot utilities. These warnings do not block
installation or install packages; install the tools for the features you use.
Git and tar remain mandatory for the installer itself. These are availability
checks, not version or complete plugin dependency checks. Shell plugins also
need Antidote, and language tooling may need runtimes such as Python, Go, PHP,
or .NET. A Nerd Font is recommended for the configured icons.

## Git alias

After opening a new Zsh session, use `dotfiles` in place of `git`:

```sh
dotfiles status
dotfiles add ~/.config/nvim
dotfiles commit -m "Update Neovim configuration"
dotfiles push
```

## Hyprland desktop

Native Lua configuration lives in `~/.config/hypr/hyprland.lua`, with separate
modules for monitors, input, appearance, keybindings, and startup. The master
layout puts the main window on the left and stacks other windows on the right.
Waybar retains the existing styling and the workspace split: 1–5 on DP-1,
6–10 on DP-2. Hyprlock, Hypridle, Hyprpaper, Hyprpicker, Hyprpolkitagent, and the
Hyprland portal provide locking, idle handling, wallpaper, color picking,
authentication dialogs, and screen sharing. Rofi, Mako, and CopyQ remain in use.

Select the plain **Hyprland** session at login, or run `start-hyprland` from a
TTY. The configuration starts its desktop helpers itself. See
`.config/hypr/README.txt` for researched versions, sources, shortcuts, and
validation instructions. The Lua configuration targets stable Hyprland 0.56.2.
