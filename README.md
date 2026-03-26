Index: README.md
===================================================================
--- README.md	old
+++ README.md	new
@@ -2,5 +2,129 @@
 a lean, defaults-oriented configuration for a commandline jumpbox development environment
 ========
 
-a lean, defaults-oriented configuration for a commandline jumpbox development environment
+# Command Line Jumpbox Environment
+
+A lean, defaults-oriented configuration for a commandline jumpbox development environment.
+=======
+# Jumpbox Environment
+
+> A lean, defaults-oriented configuration for a command-line jumpbox development environment.
+
+This repository provides a minimal yet powerful setup for developers who work primarily from the terminal. It focuses on essential tools with sensible defaults, ensuring a distraction-free workflow across different machines.
+
+## 🛠️ Tech Stack
+
+- **Editor**: [Neovim](https://neovim.io/) (Lua-based configuration)
+- **Terminal Multiplexer**: [Tmux](https://tmux.github.io/) (Mouse support, custom styles)
+- **Shell**: [Bash](https://www.gnu.org/software/bash/) (Optimized aliases and prompts)
+- **Version Control**: [Git](https://git-scm.com/) (Automated hooks and linting)
+- **Runtime**: [Node.js](https://nodejs.org/) (For linting and scripts)
+
+## 🚀 Features
+
+- **Neovim**: Clean Lua configuration with basic keybindings and navigation.
+- **Tmux**: Pre-configured with mouse support and customizable pane styles.
+- **Git Hooks**:
+  - `commit-msg`: Validates commit messages via `.commitlintrc.js`.
+  - `pre-push`: Ensures tests or checks pass before pushing.
+  - `post-checkout`: Automates environment updates when switching branches.
+- **Branch Protection**: Regex validation for branch naming conventions (`git-hooks/_branch-regex.sh`).
+- **Issue Templates**: Standardized GitHub issue templates for consistent reporting.
+
+## 🛠️ Installation
+
+1. **Clone the repository**:
+   ```bash
+   git clone https://github.com/yourusername/jumpbox-env.git
+   cd jumpbox-env
+   ```
+
+2. **Run the installation script**:
+   ```bash
+   chmod +x install.sh
+   ./install.sh
+   ```
+   > **Note**: Ensure `git`, `tmux`, `neovim`, `node`, and `bash` are installed before running `install.sh`.
+
+3. **Verify installation**:
+   ```bash
+   nvim --version
+   tmux -V
+   node --version
+   ```
+
+## 📁 Project Structure
+
+```
+.
+├── .commitlintrc.js    # Commit linting configuration
+├── .github/
+│   └── ISSUE_TEMPLATE/ # Standardized issue templates
+├── git-hooks/
+│   ├── _branch-regex.sh   # Branch naming validation
+│   ├── commit-msg         # Pre-commit hook
+│   ├── post-checkout      # Post-checkout hook
+│   └── pre-push           # Pre-push hook
+├── init.lua              # Neovim initialization script
+├── tmux.conf             # Tmux configuration file
+├── install.sh            # Setup script
+└── README.md             # This file
+```
+
+## 📝 Configuration
+
+### Neovim (`init.lua`)
+- **Language Detection**: `ft_to_lang(ft)` mapping for language-specific settings.
+- **Options**: Custom `opts()` for plugin management and UI tweaks.
+- **Callbacks**: Modular `callback()` structure for extensibility.
+
+### Tmux (`tmux.conf`)
+- **Mouse Support**: Enabled by default for better usability.
+- **Styling**:
+  - Custom background (`style bg`) and foreground (`style fg`) colors.
+  - Pane splitting logic optimized for clarity.
+- **Status Bar**: Minimalistic design with essential info.
+
+### Git Hooks
+- **`.commitlintrc.js`**: Enforces commit message standards.
+- **`_branch-regex.sh`**: Validates branch names against a regex pattern.
+- **`pre-push`**: Runs automated checks before pushing to remote.
+- **`post-checkout`**: Updates environment variables or setup files after switching branches.
+
+## 🔧 Usage
+
+### Neovim
+```bash
+nvim [file]
+```
+
+### Tmux
+```bash
+tmux          # Start new session
+tmux attach   # Attach to existing session
+```
+
+### Git
+```bash
+git commit -m "feat: add new feature"  # Auto-linted by hooks
+git push                                 # Auto-checked by hooks
+```
+
+## 🤝 Contributing
+
+Contributions are welcome! Please ensure your commits follow the linting rules and branch naming conventions.
+
+1. Fork the repository.
+2. Create a feature branch (`git checkout -b feature/amazing-feature`).
+3. Commit your changes (`git commit -m 'feat: add amazing feature'`).
+4. Push to the branch (`git push origin feature/amazing-feature`).
+5. Open a Pull Request.
+
+## 📜 License
+
+This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
+
+## 📞 Support
+
+If you have any questions or issues, please open an issue on the [GitHub repository](https://github.com/yourusername/jumpbox-env).
 

