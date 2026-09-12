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
installer also checks Oh My Posh and, on Linux, desktop tools such as GTKLock,
swayidle, Waybar, and the screenshot utilities. These warnings do not block
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
