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

# Keep these checks in both standalone installers (curl | sh must still work).
# Missing config dependencies are advisory; only git/tar are needed to install.
warn_tool() {
  tool=$1
  reason=$2
  shift 2
  for candidate in "$tool" "$@"; do
    if command -v "$candidate" >/dev/null 2>&1; then
      return 0
    fi
  done
  printf '  Missing %s: %s\n' "$tool" "$reason" >&2
  missing_tools=1
}

warn_dependencies() {
  missing_tools=0
  printf '\nChecking tools used by the installed configuration (current PATH)...\n' >&2
  warn_tool zsh 'interactive shell'
  warn_tool nvim 'Neovim editor'
  warn_tool eza 'ls, ll, and lt aliases'
  warn_tool fzf 'Neovim fuzzy finder'
  warn_tool rg 'ripgrep: Neovim live grep and search'
  warn_tool fd 'fast file discovery (optional; find/ripgrep can be used instead)' fdfind
  warn_tool lazygit 'lg alias and Neovim Git interface'
  warn_tool delta 'git-delta: Neovim code-action previews and full-install Git pager'
  warn_tool node 'Node.js: Copilot and JavaScript language tools'
  warn_tool npm 'installation of Node-based language servers and formatters'
  warn_tool cargo 'Rust toolchain: Blink completion matcher build'
  warn_tool cc 'C compiler for native Neovim plugins and parsers' gcc clang
  warn_tool make 'native Neovim plugin builds'
  warn_tool tree-sitter 'Tree-sitter CLI for parser builds'
  warn_tool curl 'Neovim plugin/tool downloads'
  warn_tool unzip 'Neovim tool archive extraction'

  warn_tool oh-my-posh 'custom shell prompt (optional; shell still works without it)'
  if [ "$(uname -s)" = Linux ]; then
    printf '\nLinux desktop tools (needed only when using this desktop configuration):\n' >&2
    warn_tool mango 'Mango compositor'
    warn_tool ghostty 'terminal shortcut'
    warn_tool rofi 'application launcher'
    warn_tool waybar 'desktop bar'
    warn_tool copyq 'clipboard manager'
    warn_tool gtklock 'password lock screen'
    warn_tool swayidle 'automatic idle and suspend locking'
    warn_tool wlr-dpms 'monitor sleep and wake'
    warn_tool flock 'serialized lock-screen launches (util-linux)'
    warn_tool pgrep 'lock-screen process detection (procps-ng)'
    warn_tool wlogout 'power menu'
    warn_tool grim 'screenshot capture'
    warn_tool slurp 'screenshot region selection'
    warn_tool wl-copy 'screenshot clipboard support (wl-clipboard)'
    warn_tool notify-send 'screenshot notifications (libnotify)'
    warn_tool swappy 'screenshot markup'
    warn_tool wpctl 'volume controls (WirePlumber)'
    warn_tool playerctl 'media controls'
    warn_tool brightnessctl 'brightness controls'
    warn_tool pavucontrol 'audio settings'
    warn_tool thunar 'file-manager shortcut'
    warn_tool google-chrome-stable 'browser shortcut and work launcher'
    warn_tool wl-color-picker 'color-picker shortcut'
    warn_tool waybar-open-weather 'weather widget'
    warn_tool checkupdates 'Arch update widget (pacman-contrib)'
  fi

  if [ "$missing_tools" -eq 1 ]; then
    printf '\nWarning: some configured features need the tools listed above.\nInstall the ones you use with your package manager, or add existing installations to PATH.\nDotfiles installation will continue; this installer does not install these tools.\n\n' >&2
  else
    printf 'All checked tools were found in PATH.\n\n' >&2
  fi
  return 0
}

command -v git >/dev/null 2>&1 || die 'git is required'
command -v tar >/dev/null 2>&1 || die 'tar is required'

warn_dependencies

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
git --git-dir="$dotfiles_dir" read-tree "$branch"

paths='.zshrc
.zsh_plugins.txt
.gitconfig
.gtkrc-2.0
.config
.local/bin
Pictures'

git --git-dir="$dotfiles_dir" ls-tree -r --name-only "$branch" -- $paths |
while IFS= read -r path; do
  if [ -e "$HOME/$path" ] || [ -L "$HOME/$path" ]; then
    mkdir -p "$backup_dir/$(dirname "$path")"
    cp -Pp "$HOME/$path" "$backup_dir/$path"
  fi
done

say 'Installing all tracked dotfiles...'
git --git-dir="$dotfiles_dir" archive "$branch" -- $paths |
  tar -x -C "$HOME"

# Repository documentation and installers live at the repository root but are
# not home configuration. Their intentional absence must not appear as deletes.
for path in README.md install.sh install-lite.sh; do
  if git --git-dir="$dotfiles_dir" ls-files --error-unmatch "$path" >/dev/null 2>&1; then
    git --git-dir="$dotfiles_dir" --work-tree="$HOME" \
      update-index --skip-worktree -- "$path"
  fi
done

say 'Full dotfiles configuration installed.'
if [ -d "$backup_dir" ]; then
  say "Previous files were copied to $backup_dir"
fi
say 'Machine-local secrets still need to be configured separately.'
say 'Start a new Zsh session with: exec zsh'
