# Dotfiles contract

## Scope

This repository owns the user-level configuration for a command-line jumpbox:
Neovim, tmux, Git defaults and hooks, commitlint, and Markdown preview
generation. Operating-system packages, project-local tooling, and PossumTech
service infrastructure remain outside this repository.

## Neovim

- Bob owns Neovim installation and version selection.
- `nvim.version` is the exact accepted upstream stable release.
- `tree-sitter.version` is the exact CLI version required by the locked
  Tree-sitter plugin.
- `tree-sitter.sha256` authenticates the official Linux x86_64 CLI artifact.
- `lazy-lock.json` is the accepted plugin graph.
- Mason's configured language-server versions are exact and share one
  representation with the enabled LSP configurations.
- `update-neovim.sh` is the sole procedure for advancing the selected stable
  Neovim release.
- `install.sh` converges the installed runtime to the tracked versions.

Neovim startup must be silent in headless mode. LSP configuration uses the
native current-stable API. Each buffer has at most one automatic formatter:
Biome when attached, otherwise vtsls. ESLint remains a diagnostics and
explicit-fix provider.

## Installation

`install.sh` is idempotent for paths already installed as symlinks to this
repository. It fails rather than replacing an existing regular file. The
tracked Neovim runtime, plugin graph, language servers, and Tree-sitter
toolchain must not silently select floating versions.

## Acceptance

`check.sh` verifies the tracked Neovim and Tree-sitter versions, real configured
Neovim startup, Telescope loading, Git hook behavior, and tmux configuration
parsing. A zero process status does not by itself establish clean Neovim
startup; emitted startup errors are failures.
