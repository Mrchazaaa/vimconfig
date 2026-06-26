#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# shellcheck source=../scripts/lib/install-helpers.sh
source "$REPO_ROOT/scripts/lib/install-helpers.sh"

VIMRC="${VIMRC:-$HOME/.vimrc}"

main() {
  local vim_content

  ensure_command vim vim "Would you like to install Vim now?"

  vim_content="source $REPO_ROOT/vim/.vimrc

source $REPO_ROOT/vim/VimSpecific.vim"

  write_file_if_changed "$VIMRC" "$vim_content"
  log "Vim will load $VIMRC."
}

main "$@"

