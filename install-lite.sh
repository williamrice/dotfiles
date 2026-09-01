#!/bin/sh

set -eu

repo_url=${DOTFILES_REPO:-https://github.com/williamrice/dotfiles.git}
branch=${DOTFILES_BRANCH:-main}
dotfiles_dir=${DOTFILES_DIR:-"$HOME/.dotfiles"}
backup_dir="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

say() {
  printf '%s\n' "$*"
}

die() {
  printf 'dotfiles: %s\n' "$*" >&2
  exit 1
}

command -v git >/dev/null 2>&1 || die 'git is required'
command -v tar >/dev/null 2>&1 || die 'tar is required'

if [ -e "$dotfiles_dir" ]; then
  git --git-dir="$dotfiles_dir" rev-parse --is-bare-repository 2>/dev/null |
    grep -qx true || die "$dotfiles_dir exists but is not a bare Git repository"

  if git --git-dir="$dotfiles_dir" remote get-url origin >/dev/null 2>&1; then
    git --git-dir="$dotfiles_dir" remote set-url origin "$repo_url"
  else
    git --git-dir="$dotfiles_dir" remote add origin "$repo_url"
  fi

  say 'Updating dotfiles repository...'
  git --git-dir="$dotfiles_dir" fetch origin \
    "+refs/heads/$branch:refs/heads/$branch"
else
  say 'Cloning dotfiles repository...'
  git clone --bare --branch "$branch" "$repo_url" "$dotfiles_dir"
fi

git --git-dir="$dotfiles_dir" config status.showUntrackedFiles no

paths='.zshrc
.zsh_plugins.txt
.config/zsh
.config/nvim'

git --git-dir="$dotfiles_dir" ls-tree -r --name-only "$branch" -- $paths |
while IFS= read -r path; do
  if [ -e "$HOME/$path" ] || [ -L "$HOME/$path" ]; then
    mkdir -p "$backup_dir/$(dirname "$path")"
    cp -Pp "$HOME/$path" "$backup_dir/$path"
  fi
done

say 'Installing Zsh and Neovim configuration...'
git --git-dir="$dotfiles_dir" archive "$branch" -- $paths |
  tar -x -C "$HOME"

say 'Lightweight dotfiles installed.'
if [ -d "$backup_dir" ]; then
  say "Previous files were copied to $backup_dir"
fi
say 'Start a new Zsh session with: exec zsh'
