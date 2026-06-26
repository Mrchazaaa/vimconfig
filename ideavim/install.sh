#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# shellcheck source=../scripts/lib/install-helpers.sh
source "$REPO_ROOT/scripts/lib/install-helpers.sh"

IDEAVIMRC="${IDEAVIMRC:-$HOME/.ideavimrc}"

main() {
  write_file_if_changed "$IDEAVIMRC" "source $REPO_ROOT/ideavim/.ideavimrc"
  log "IdeaVim will load $IDEAVIMRC."
}

main "$@"

