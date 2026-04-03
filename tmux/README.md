# 🪟 Tmux Configuration

> A modern, keyboard-driven terminal multiplexer setup built for efficiency.

![Tmux](https://img.shields.io/badge/Tmux-3.3+-1BB91F?style=for-the-badge&logo=tmux&logoColor=white)
![Catppuccin](https://img.shields.io/badge/Theme-Catppuccin_Mocha-F5C2E7?style=for-the-badge)

My Tmux configuration is tailored to make pane and window management effortless, fully leveraging true colors, vim-like navigation, and modern session management plugins.

## 🔑 Keybindings

The default prefix has been remapped for ergonomic access.

*   **Prefix Key**: `Ctrl + Space`

### Pane Navigation
*   `Prefix` + `h/j/k/l`: Vim-style navigation.
*   `Alt + Arrow Keys` (without Prefix): Quick pane switching.
*   `Prefix` + `r`: Enters resize mode, use `h/j/k/l` to resize panes by 5 columns/rows.

### Window Management
*   `Prefix` + `-`: Vertical split (retains current path).
*   `Prefix` + `\` or `|`: Horizontal split (retains current path).
*   `Prefix` + `q`: Kill pane.
*   Windows and panes are indexed starting at `1` instead of `0` for easier keyboard access.

### Copy Mode
*   `Prefix` + `v`: Enter vi copy mode.
*   `v`: Begin selection.
*   `Ctrl-v`: Rectangle toggle.
*   `y`: Copy selection and cancel.

## 🔌 Plugins

Managed via **TPM** (Tmux Plugin Manager). Press `Prefix` + `I` to install.

| Plugin | Keybinding / Trigger | Description |
| :--- | :--- | :--- |
| **vim-tmux-navigator** | `Ctrl + h/j/k/l` | Seamless navigation between Tmux panes and Neovim splits. |
| **catppuccin-tmux** | - | Beautiful Mocha theme for the status bar. |
| **tmux-resurrect** & **continuum** | Auto | Automatically saves and restores tmux sessions across restarts. |
| **tmux-fzf** | `Prefix` + `a` | FZF integration for managing tmux components. |
| **extrakto** | `Prefix` + `Space` | Fuzzy find and copy text directly from the current pane. |
| **tmux-sessionx** | `Prefix` + `s` | Advanced session manager with `zoxide` integration. |
| **tmux-thumbs** | `Prefix` + `Tab` | Quick, hint-based copy and paste of URLs, hashes, etc. |

## ⚙️ Core Options

*   **True Color**: Enabled via `terminal-overrides ",xterm*:Tc"`.
*   **Mouse**: Fully enabled for scrolling and pane selection.
*   **Renumbering**: Windows automatically renumber when one is closed.
