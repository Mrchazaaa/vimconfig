#!/usr/bin/env bash

set -euo pipefail

REPO_URL="${VIMCONFIG_REPO_URL:-https://github.com/Mrchazaaa/vimconfig.git}"
INSTALL_DIR="${VIMCONFIG_INSTALL_DIR:-$HOME/.config/nvim/vimconfig}"
NVIM_CONFIG_DIR="$HOME/.config/nvim"
NVIM_INIT="$NVIM_CONFIG_DIR/init.vim"
VIMRC="$HOME/.vimrc"

log() {
  printf '%s\n' "$*"
}

die() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

ask_yes_no() {
  local prompt="$1"
  local default="${2:-n}"
  local reply
  local suffix

  if [[ "$default" == "y" ]]; then
    suffix="[Y/n]"
  else
    suffix="[y/N]"
  fi

  while true; do
    read -r -p "$prompt $suffix " reply || return 1
    reply="${reply:-$default}"
    case "$reply" in
      [Yy]|[Yy][Ee][Ss]) return 0 ;;
      [Nn]|[Nn][Oo]) return 1 ;;
      *) log "Please answer yes or no." ;;
    esac
  done
}

run_with_sudo() {
  if [[ "$(id -u)" -eq 0 ]]; then
    "$@"
  elif command -v sudo >/dev/null 2>&1; then
    sudo "$@"
  else
    die "This command needs root privileges, but sudo is not installed: $*"
  fi
}

install_packages() {
  local packages=("$@")

  if command -v apt-get >/dev/null 2>&1; then
    run_with_sudo apt-get update
    run_with_sudo apt-get install -y "${packages[@]}"
  elif command -v dnf >/dev/null 2>&1; then
    run_with_sudo dnf install -y "${packages[@]}"
  elif command -v yum >/dev/null 2>&1; then
    run_with_sudo yum install -y "${packages[@]}"
  elif command -v pacman >/dev/null 2>&1; then
    run_with_sudo pacman -Sy --needed --noconfirm "${packages[@]}"
  elif command -v zypper >/dev/null 2>&1; then
    run_with_sudo zypper install -y "${packages[@]}"
  elif command -v brew >/dev/null 2>&1; then
    brew install "${packages[@]}"
  else
    die "No supported package manager found. Please install: ${packages[*]}"
  fi
}

ensure_command() {
  local command_name="$1"
  local package_name="${2:-$1}"
  local prompt="$3"

  if command -v "$command_name" >/dev/null 2>&1; then
    return 0
  fi

  log "$command_name is not installed."
  if ask_yes_no "$prompt"; then
    install_packages "$package_name"
  else
    die "$command_name is required to continue."
  fi

  command -v "$command_name" >/dev/null 2>&1 || die "$command_name installation did not complete successfully."
}

backup_file() {
  local path="$1"
  local timestamp

  if [[ ! -e "$path" && ! -L "$path" ]]; then
    return 0
  fi

  timestamp="$(date +%Y%m%d%H%M%S)"
  mv "$path" "$path.backup.$timestamp"
  log "Backed up $path to $path.backup.$timestamp"
}

write_file_if_changed() {
  local path="$1"
  local content="$2"
  local tmp

  tmp="$(mktemp)"
  trap 'rm -f "$tmp"' RETURN
  printf '%s\n' "$content" > "$tmp"

  if [[ -f "$path" ]] && cmp -s "$tmp" "$path"; then
    log "$path is already up to date."
    return 0
  fi

  backup_file "$path"
  mkdir -p "$(dirname "$path")"
  mv "$tmp" "$path"
  trap - RETURN
  log "Wrote $path"
}

install_or_update_repo() {
  mkdir -p "$(dirname "$INSTALL_DIR")"

  if [[ -d "$INSTALL_DIR/.git" ]]; then
    log "Existing vimconfig Git checkout found at $INSTALL_DIR."
    if ask_yes_no "Pull the latest changes for the deployed vim config?"; then
      git -C "$INSTALL_DIR" pull --ff-only
    else
      log "Leaving existing checkout unchanged."
    fi
    return 0
  fi

  if [[ -e "$INSTALL_DIR" ]]; then
    die "$INSTALL_DIR already exists but is not a Git checkout. Move it aside or set VIMCONFIG_INSTALL_DIR to another path."
  fi

  log "Cloning vimconfig into $INSTALL_DIR"
  git clone "$REPO_URL" "$INSTALL_DIR"
}

write_shims() {
  local nvim_content
  local vim_content

  nvim_content='source ~/.config/nvim/vimconfig/vim/.vimrc

lua dofile(vim.fn.stdpath("config") .. "/vimconfig/nvim/init.lua")'

  vim_content='source ~/.config/nvim/vimconfig/vim/.vimrc

source ~/.config/nvim/vimconfig/vim/VimSpecific.vim'

  write_file_if_changed "$NVIM_INIT" "$nvim_content"
  write_file_if_changed "$VIMRC" "$vim_content"
}

main() {
  log "Installing vimconfig from $REPO_URL"
  log "Target checkout: $INSTALL_DIR"

  ensure_command git git "Would you like to install git now?"
  ensure_command nvim neovim "Would you like to install Neovim now?"

  install_or_update_repo
  write_shims

  log "Installation complete."
  log "Neovim will load $NVIM_INIT."
  log "Vim will load $VIMRC."
}

main "$@"
