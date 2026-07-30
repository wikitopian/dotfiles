#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

link_file() {
  local source=$1
  local target=$2

  if [[ -L "$target" ]]; then
    if [[ "$(readlink -f "$target")" == "$(readlink -f "$source")" ]]; then
      return
    fi

    printf "Refusing to replace unrelated symlink: %s\n" "$target" >&2
    exit 73
  fi

  if [[ -e "$target" ]]; then
    printf "Refusing to replace non-symlink path: %s\n" "$target" >&2
    exit 73
  fi

  ln -s "$source" "$target"
}

# Ensure target directories exist
mkdir -p "$HOME/.config/nvim"
mkdir -p "$HOME/.config/bob"
mkdir -p "$HOME/.local/bin"

# Link tmux.conf
link_file "$SCRIPT_DIR/tmux.conf" "$HOME/.tmux.conf"

# Link .commitlintrc.js
link_file "$SCRIPT_DIR/.commitlintrc.js" "$HOME/.commitlintrc.js"

# Global npm packages for commitlint
if command -v npm >/dev/null 2>&1; then
  commitlint_path="$(npm prefix --global)/bin/commitlint"
  if [ ! -x "$commitlint_path" ]; then
    echo "Installing global npm packages..."
    npm install -g @commitlint/cli @commitlint/config-conventional
  fi
fi

# Set up git hooks via templates
mkdir -p "$HOME/.git/templates/hooks"
git config --global init.templatedir "$HOME/.git/templates"

# Link hooks from repo to templates
for hook in "$SCRIPT_DIR"/git-hooks/*; do
  hook_name=$(basename "$hook")
  # Skip shared helper files
  [[ "$hook_name" == _* ]] && continue
  link_file "$SCRIPT_DIR/git-hooks/$hook_name" "$HOME/.git/templates/hooks/$hook_name"

  # Also link into the current repo if we are in one
  if [ -d "$SCRIPT_DIR/.git/hooks" ]; then
    link_file "$SCRIPT_DIR/git-hooks/$hook_name" "$SCRIPT_DIR/.git/hooks/$hook_name"
  fi
done

# Install the tracked Neovim runtime contract.
link_file "$SCRIPT_DIR/bob.json" "$HOME/.config/bob/config.json"
link_file "$SCRIPT_DIR/nvim.version" "$HOME/.config/nvim/nvim.version"
link_file "$SCRIPT_DIR/lazy-lock.json" "$HOME/.config/nvim/lazy-lock.json"
link_file "$SCRIPT_DIR/init.lua" "$HOME/.config/nvim/init.lua"

if ! command -v bob >/dev/null 2>&1; then
  printf "%s\n" "bob is required to install the tracked Neovim version." >&2
  exit 127
fi

BOB_CONFIG="$HOME/.config/bob/config.json" bob sync
link_file "$HOME/.local/share/bob/nvim-bin/nvim" "$HOME/.local/bin/nvim"
export PATH="$HOME/.local/bin:$PATH"

tree_sitter_version=$(tr -d "[:space:]" < "$SCRIPT_DIR/tree-sitter.version")
installed_tree_sitter_version=""
if command -v tree-sitter >/dev/null 2>&1; then
  installed_tree_sitter_version=$(tree-sitter --version | awk '{ print $2 }')
fi

if [[ "$installed_tree_sitter_version" != "$tree_sitter_version" ]]; then
  for required_tool in curl gzip sha256sum; do
    if ! command -v "$required_tool" >/dev/null 2>&1; then
      printf "%s is required to install tree-sitter-cli.\n" "$required_tool" >&2
      exit 127
    fi
  done

  if [[ "$(uname -s)" != "Linux" ]] || [[ "$(uname -m)" != "x86_64" ]]; then
    printf "%s\n" "The tracked tree-sitter-cli artifact supports Linux x86_64 only." >&2
    exit 69
  fi

  tree_sitter_sha256=$(tr -d "[:space:]" < "$SCRIPT_DIR/tree-sitter.sha256")
  tree_sitter_url="https://github.com/tree-sitter/tree-sitter/releases/download/v${tree_sitter_version}/tree-sitter-linux-x64.gz"
  tree_sitter_temp_dir=$(mktemp -d)
  trap 'rm -rf "$tree_sitter_temp_dir"' EXIT

  curl -fsSL "$tree_sitter_url" -o "$tree_sitter_temp_dir/tree-sitter.gz"
  printf "%s  %s\n" "$tree_sitter_sha256" "$tree_sitter_temp_dir/tree-sitter.gz" |
    sha256sum --check --status
  gzip -dc "$tree_sitter_temp_dir/tree-sitter.gz" > "$tree_sitter_temp_dir/tree-sitter"
  install -m 0755 "$tree_sitter_temp_dir/tree-sitter" "$HOME/.local/bin/tree-sitter"

  trap - EXIT
  rm -rf "$tree_sitter_temp_dir"
fi

mkdir -p "$HOME/.cache/nvim/swap"

mkdir -p "$HOME/repo"

git config --global diff.tool vimdiff
git config --global merge.tool vimdiff

# Link pandoc mermaid filter
mkdir -p "$HOME/.local/share/pandoc/filters"
link_file "$SCRIPT_DIR/mermaid.lua" "$HOME/.local/share/pandoc/filters/mermaid.lua"

# Create preview directory
mkdir -p "$HOME/repo/preview"

git config --global core.editor "nvim"
git config --global user.name "wikitopian"
git config --global user.email "wikitopian@pm.me"

nvim --headless "+DotfilesSyncTreesitter" +qa
