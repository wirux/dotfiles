# 📝 Neovim Configuration

> A fast, extensible, and feature-rich Neovim IDE experience based on LazyVim.

![Neovim](https://img.shields.io/badge/Neovim-v0.9+-57A143?style=for-the-badge&logo=neovim&logoColor=white)
![LazyVim](https://img.shields.io/badge/LazyVim-Powered-blue?style=for-the-badge&logo=neovim)
![Lua](https://img.shields.io/badge/Config-Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white)

This configuration builds upon the excellent [LazyVim](https://github.com/LazyVim/LazyVim) distribution, customizing it with specific keymaps, language supports, and productivity plugins tailored to my workflow.

## 🏗️ Architecture

- **Base**: LazyVim provides the sensible defaults, autocmds, and a robust plugin ecosystem out-of-the-box.
- **Package Manager**: `lazy.nvim` for blazing fast plugin loading.
- **Theme**: Catppuccin (integrated across plugins like Telescope, Neo-tree, Noice, and Alpha).
- **Clipboard**: Explicitly configured to use `pbcopy/pbpaste` natively on macOS with UTF-8 encoding.

## 🔌 Core Plugins & Extensions

I utilize a mix of built-in LazyVim modules and custom additions:

### Integrated LazyVim Extras
- `lang.typescript`, `lang.json`, `lang.tailwind`, `lang.terraform`
- `ui.mini-animate` (smooth animations)
- `coding.yanky` (advanced yank ring)

### Custom Plugin Additions
- **[Harpoon 2](https://github.com/ThePrimeagen/harpoon)**: Fast, project-specific file navigation (`<leader>ha` to add, `<leader>h1-4` to jump).
- **[vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)**: Move between Neovim splits and Tmux panes seamlessly (`<C-h/j/k/l>`).
- **[Obsidian.nvim](https://github.com/epwalsh/obsidian.nvim)**: Note-taking and knowledge graph management right in the editor.
- **Language Support**: Enhanced configurations for Go, Python, CSS, Markdown, and Terraform.

## ⌨️ Custom Keybindings

In addition to the standard LazyVim keymaps (spacebar as `<leader>`), I have defined several custom maps:

### Window Management
*   `<C-\>`: Vertical split.
*   `<C-_>`: Horizontal split.
*   `<C-w>`: Quit current window.

### Editing & Visual Mode
*   `J` / `K` (Visual mode): Move selected lines up or down.
*   `<leader>p` (Visual mode): Paste over selection without yanking the replaced text into the default register (`"_dP`).
*   `<r>` (Normal mode): Redo (maps to `<cmd>redo<cr>`).

### Harpoon
*   `<leader>ha`: Add file to Harpoon list.
*   `<leader>h1-4`: Jump to Harpoon files 1 through 4.
*   `<leader>hp` / `<leader>hn`: Prev/Next Harpoon buffer.
*   `<leader>hh`: Open Harpoon UI in Telescope.

## ⚙️ Configuration Structure

```text
nvim/
├── init.lua                 # Entry point
├── lazy-lock.json           # Plugin lockfile
└── lua/
    ├── config/              # Core configs
    │   ├── autocmds.lua     # Custom auto-commands
    │   ├── keymaps.lua      # Custom key mappings
    │   ├── lazy.lua         # Plugin manager setup & extras
    │   └── options.lua      # Core vim options (clipboard, encoding)
    └── plugins/             # Custom plugin specifications
        ├── colorscheme.lua
        ├── harpoon.lua
        ├── tmux.lua
        └── ...
```
