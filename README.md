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

## Git alias

After opening a new Zsh session, use `dotfiles` in place of `git`:

```sh
dotfiles status
dotfiles add ~/.config/nvim
dotfiles commit -m "Update Neovim configuration"
dotfiles push
```
