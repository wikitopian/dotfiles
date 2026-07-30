#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
expected_nvim_version=$(tr -d "[:space:]" < "$SCRIPT_DIR/nvim.version")
expected_tree_sitter_version=$(tr -d "[:space:]" < "$SCRIPT_DIR/tree-sitter.version")

if ! command -v nvim >/dev/null 2>&1; then
  printf "%s\n" "Neovim is not available." >&2
  exit 127
fi

actual_nvim_version=$(nvim --version | awk 'NR == 1 { print $2 }')
if [[ "$actual_nvim_version" != "$expected_nvim_version" ]]; then
  printf "Expected Neovim %s, got %s from %s.\n" \
    "$expected_nvim_version" "$actual_nvim_version" "$(command -v nvim)" >&2
  exit 1
fi

if ! command -v tree-sitter >/dev/null 2>&1; then
  printf "%s\n" "tree-sitter-cli is not available." >&2
  exit 127
fi

actual_tree_sitter_version=$(tree-sitter --version | awk '{ print $2 }')
if [[ "$actual_tree_sitter_version" != "$expected_tree_sitter_version" ]]; then
  printf "Expected tree-sitter-cli %s, got %s.\n" \
    "$expected_tree_sitter_version" "$actual_tree_sitter_version" >&2
  exit 1
fi

run_nvim_check() {
  local check_name=$1
  shift
  local output

  if ! output=$(nvim --headless "$@" 2>&1); then
    printf "%s failed:\n%s\n" "$check_name" "$output" >&2
    exit 1
  fi

  if [[ -n "$output" ]]; then
    printf "%s emitted unexpected output:\n%s\n" "$check_name" "$output" >&2
    exit 1
  fi
}

run_nvim_check "Neovim startup" \
  "+lua assert(vim.fn.has('nvim-0.12') == 1, 'Neovim 0.12+ is required')" \
  "+lua assert(vim.lsp.config and vim.lsp.enable, 'Native LSP configuration is unavailable')" \
  "+lua assert(require('telescope'), 'Telescope failed to load')" \
  +qa

run_nvim_check "Tree-sitter attachment" \
  "+enew" \
  "+setfiletype lua" \
  "+lua assert(vim.wait(5000, function() return vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] ~= nil end), 'Tree-sitter did not attach')" \
  +qa

run_nvim_check "vtsls attachment" \
  "+enew" \
  "+setfiletype javascript" \
  "+lua assert(vim.wait(15000, function() return #vim.lsp.get_clients({ bufnr = 0, name = 'vtsls' }) == 1 end, 100), 'vtsls did not attach')" \
  +qa

node --test "$SCRIPT_DIR/git-hooks/_hooks.test.mjs"
tmux -L dotfiles-check -f /dev/null \
  start-server \; \
  source-file "$SCRIPT_DIR/tmux.conf" \; \
  kill-server

printf "Dotfiles checks passed with Neovim %s.\n" "$actual_nvim_version"
