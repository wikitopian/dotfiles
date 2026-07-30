# Dotfiles

A lean, defaults-oriented configuration for a command-line jumpbox development
environment.

The GitHub repository is a downstream public distribution. Canonical
development occurs in the authenticated project workspace.

## Install

The installer requires Git, Bob, curl, gzip, SHA-256 tooling, Node.js with npm,
tmux, Pandoc, and ripgrep. It installs user-level symlinks, selects the accepted
Neovim release, installs the matching Tree-sitter CLI and parsers, and
configures Git:

```bash
./install.sh
./check.sh
```

The installer refuses to replace regular files or unrelated symlinks. Move any
pre-existing target out of the way after reviewing it, then rerun the
installer.

## Neovim release updates

[`nvim.version`](nvim.version) records the exact upstream stable release
accepted by this repository. Update it and Bob's selected runtime together:

```bash
./update-neovim.sh
./install.sh
./check.sh
```

`update-neovim.sh` resolves Bob's current `stable` channel and leaves any
version-file change in the worktree for review.
