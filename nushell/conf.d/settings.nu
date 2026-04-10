# =============================================================================
# GENERAL
# =============================================================================

$env.config.hooks.display_output = "table --icons"
$env.config.show_banner = false
$env.config.rm.always_trash = true
$env.config.buffer_editor = "nvim"
$env.config.edit_mode = "emacs"  # change to "vi" for vi-mode

# =============================================================================
# HISTORY (zsh equivalent: HISTSIZE/share_history/dedup)
# =============================================================================

$env.config.history = {
    max_size: 10_000
    sync_on_enter: true         # sync on every ENTER — like zsh share_history (tmux panes)
    file_format: "sqlite"       # sqlite > plaintext (faster search, atuin-friendly)
    isolation: false             # shared history across sessions
}

# =============================================================================
# COMPLETIONS (zsh equivalent: fzf-tab + case-insensitive)
# =============================================================================

$env.config.completions = {
    case_sensitive: false        # like zsh matcher-list 'm:{a-z}={A-Z}'
    quick: true                  # auto-select on single match
    partial: true                # partial word matching
    algorithm: "fuzzy"           # fuzzy > prefix (closer to fzf-tab)
    external: {
        enable: true
        max_results: 100
        completer: null          # carapace init will set this
    }
}

# =============================================================================
# TABLE DISPLAY
# =============================================================================

$env.config.table = {
    mode: rounded
    index_mode: auto
    show_empty: true
    padding: { left: 1, right: 1 }
    trim: {
        methodology: wrapping
        wrapping_try_keep_words: true
    }
    header_on_separator: false
}

$env.config.footer_mode = 25     # show footer headers when >25 rows

# =============================================================================
# SHELL INTEGRATION (important for tmux)
# =============================================================================

$env.config.shell_integration = {
    osc2: true                   # terminal title
    osc7: true                   # cwd reporting
    osc8: true                   # clickable links
    osc9_9: false
    osc133: true                 # command boundaries (scroll-to-prompt in tmux)
    osc633: true                 # VS Code terminal integration
    reset_application_mode: true
}

# =============================================================================
# CURSOR SHAPE
# =============================================================================

$env.config.cursor_shape = {
    emacs: block
    vi_insert: block
    vi_normal: block
}
