# Dotfiles

Personal configuration managed as a bare Git repository with `$HOME` as its
work tree.

## Lightweight server install

Installs only Zsh and Neovim configuration:

```sh
curl -fsSL https://raw.githubusercontent.com/williamrice/dotfiles/main/install-lite.sh | sh
```

## Full install

Installs every tracked home configuration file:

```sh
curl -fsSL https://raw.githubusercontent.com/williamrice/dotfiles/main/install.sh | sh
```

Existing tracked paths are copied to `~/.dotfiles-backup/` before replacement.
Machine-local secrets are not installed.

## Git alias

After opening a new Zsh session, use `dotfiles` in place of `git`:

```sh
dotfiles status
dotfiles add ~/.config/nvim
dotfiles commit -m "Update Neovim configuration"
dotfiles push
```
