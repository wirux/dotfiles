# 🔧 .dotfiles

> A modern, complex, and highly opinionated configuration repository for macOS.

![Neovim](https://img.shields.io/badge/Neovim-v0.9+-57A143?style=for-the-badge&logo=neovim&logoColor=white)
![Tmux](https://img.shields.io/badge/Tmux-3.3+-1BB91F?style=for-the-badge&logo=tmux&logoColor=white)
![Zsh](https://img.shields.io/badge/Zsh-5.9+-F1502F?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Lua](https://img.shields.io/badge/Lua-Config-2C2D72?style=for-the-badge&logo=lua&logoColor=white)

## 📖 About

This repository hosts my personal configuration files (dotfiles), meticulously crafted to provide a highly efficient, aesthetically pleasing, and keyboard-centric development environment. It leverages the power of modern CLI tools to maximize productivity.

## ✨ Features

### ⚡ Core Tools
*   **Shell**: Zsh configured with Powerlevel10k for a fast and informative prompt. ([See details](home/README.md))
*   **Terminal**: Ghostty modern and fast.
*   **Input**: Karabiner-Elements for advanced key mapping modifications.
*   **Navigation**: `zoxide` for smarter directory jumping.
*   **Search**: `fzf`, `ripgrep`, and `fd` for blazing fast fuzzy finding and searching.

### 📝 Neovim (LazyVim)
A fully-featured Neovim setup powered by **LazyVim**. ([See details](nvim/README.md))
*   **Package Manager**: `lazy.nvim`
*   **LSP & Formatting**: Built-in support for various languages (Lua, Python, Go, Terraform, etc.).
*   **File Explorer**: Neo-tree.
*   **UI**: Catppuccin theme for a cohesive look.
*   **Key Plugins**: Telescope, Treesitter, Which-key, Harpoon, and more.

### 🖥️ Tmux
A robust terminal multiplexer configuration. ([See details](tmux/README.md))
*   **Manager**: TPM (Tmux Plugin Manager).
*   **Theme**: Catppuccin (Mocha/Frappe).
*   **Navigation**: `vim-tmux-navigator` for seamless transitions between Vim and Tmux panes.
*   **Utilities**: `tmux-sensible`, `tmux-yank`, `sessionx`, `extrakto`.

## 🛠️ Prerequisites

Ensure you have the following installed on your macOS system:

*   [Homebrew](https://brew.sh/)
*   [Nerd Fonts](https://www.nerdfonts.com/) (Recommended: JetBrainsMono Nerd Font)
*   Git

## 🚀 Installation

### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/dotfiles.git ~/.config
```

### 2. Install Dependencies
```bash
# Core utils
brew install ripgrep fd fzf bat zoxide imagemagick
```

### 3. Link Configuration
Symlink the configuration files to their respective locations.

**Home Directory Configs:**
```bash
ln -s ~/.config/home/.zshrc ~/.zshrc
ln -s ~/.config/home/.p10k.zsh ~/.p10k.zsh
```

**Application Configs:**
Most folders in this repo (nvim, tmux, iterm2, karabiner) map directly to `~/.config/`.

### 4. Setup Tmux Plugins
Open tmux and press `prefix` + `I` to install plugins via TPM.

## 📂 Structure

Click on the links below to view the detailed documentation for each core component:

```text
.config/
├── home/              # 🔗 [Zsh & Shell Config](home/README.md) (.zshrc, .p10k.zsh)
├── nvim/              # 🔗 [Neovim Config](nvim/README.md) (LazyVim setup)
├── tmux/              # 🔗 [Tmux Config](tmux/README.md) (TPM, Catppuccin)
├── iterm2/            # iTerm2 support files
├── karabiner/         # Keyboard mapping rules
├── terraform/         # Terraform configurations
└── opencode/          # Opencode specific settings
```

## 🎨 Themes
*   **Global**: Catppuccin (Mocha)
*   **Shell**: Powerlevel10k

