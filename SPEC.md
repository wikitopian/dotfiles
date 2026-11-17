# Dotfiles contract

## Scope

This repository owns the user-level configuration for a command-line jumpbox:
Neovim, tmux, Git defaults and hooks, commitlint, and Markdown preview
generation. Operating-system packages, project-local tooling, and PossumTech
service infrastructure remain outside this repository.

## Neovim

- Bob owns Neovim installation and version selection; no competing OS
  `/usr/bin/nvim` package may remain installed.
- `nvim.version` is the exact accepted upstream stable release.
- `tree-sitter.version` is the exact CLI version required by the locked
  Tree-sitter plugin, authenticated by `tree-sitter.sha256`.
- Built-in `vim.pack` owns plugin installation and locking via
  `nvim-pack-lock.json` (`nvim-treesitter`, `mini.pick`, `minuet-ai.nvim`, and
  `which-key.nvim` — four plugins total, with no third-party plugin manager, LSP
  wrapper plugin, statusline/tabline plugin, or external colorscheme).
- `lsp/package.json` and `lsp/package-lock.json` lock the exact npm language
  server versions (`vtsls`, `biome`, and `vscode-langservers-extracted`),
  converged deterministically into `~/.local/share/nvim/lsp` by `install.sh`
  without Mason.
- `update-neovim.sh` is the sole procedure for advancing the selected stable
  Neovim release.
- `install.sh` converges the installed runtime, plugins, parsers, and language
  servers to the tracked versions.

Neovim startup must be silent in headless mode. Appearance uses Neovim's
built-in dark `default` scheme with a transparent terminal background and a
native Lua statusline. LSP configuration uses native `vim.lsp.config` and
`vim.lsp.enable`. Each buffer has at most one automatic formatter: Biome when
attached, otherwise vtsls. ESLint remains a diagnostics and explicit-fix
provider (`:LspEslintFixAll`). Native LSP completion is explicitly invoked
(`<C-Space>`). Automatic predictive completion is one Gemini 3.5 Flash-Lite
(`thinkingLevel = "minimal"`) request at a time, rendered as ghost text and
inserted only on explicit acceptance (`<C-y>` when no completion popup is open).

## Installation

`install.sh` is idempotent for paths already installed as symlinks to this
repository. It fails rather than replacing an existing regular file. The
tracked Neovim runtime, plugin graph, language servers, and Tree-sitter
toolchain must not silently select floating versions.

## Acceptance

`check.sh` verifies the tracked Neovim and Tree-sitter versions, absence of a
competing `/usr/bin/nvim`, real configured Neovim startup (`vim.pack`,
`mini.pick`, `minuet`, and `which-key`), Tree-sitter attachment, native `vtsls`
attachment, Git hook behavior, and tmux configuration parsing. A zero process
status does not by itself establish clean Neovim startup; emitted startup errors
are failures.
