#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VERSION_LINK="$HOME/.config/nvim/nvim.version"

if ! command -v bob >/dev/null 2>&1; then
  printf "%s\n" "bob is required to update Neovim." >&2
  exit 127
fi

if [[ ! -L "$VERSION_LINK" ]] ||
   [[ "$(readlink -f "$VERSION_LINK")" != "$SCRIPT_DIR/nvim.version" ]]; then
  printf "%s\n" "Run ./install.sh before updating Neovim." >&2
  exit 73
fi

BOB_CONFIG="$SCRIPT_DIR/bob.json" bob use stable

expected_version=$(tr -d "[:space:]" < "$SCRIPT_DIR/nvim.version")
actual_version=$("$HOME/.local/share/bob/nvim-bin/nvim" --version | awk 'NR == 1 { print $2 }')

if [[ "$actual_version" != "$expected_version" ]]; then
  printf "Expected Neovim %s, got %s.\n" "$expected_version" "$actual_version" >&2
  exit 1
fi

printf "Neovim %s is selected; review and commit nvim.version if it changed.\n" "$actual_version"
