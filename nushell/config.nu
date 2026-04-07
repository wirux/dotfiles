# Nushell Config File
#
# version = "0.111.0"

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

# =============================================================================
# MENUS
# =============================================================================

# IDE-style completion menu — selections apply immediately (no Enter needed)
$env.config.menus = [
    {
        name: completion_menu
        only_buffer_difference: false   # key: inserts completion as you navigate, no Enter needed
        marker: ""
        type: {
            layout: ide
            min_completion_width: 0
            max_completion_width: 50
            max_completion_height: 10
            padding: 0
            border: true
            cursor_offset: 0
            description_mode: "prefer_right"
            min_description_width: 0
            max_description_width: 50
            max_description_height: 10
            description_offset: 1
        }
        style: {
            text: green
            selected_text: { attr: r }
            description_text: yellow
        }
    }
    {
        name: history_menu
        only_buffer_difference: true
        marker: "? "
        type: {
            layout: list
            page_size: 10
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }
    }
]

# =============================================================================
# KEYBINDINGS
# =============================================================================

$env.config.keybindings = [
    # Tab — open completion menu → cycle next
    {
        name: tab_complete
        modifier: none
        keycode: tab
        mode: [emacs vi_insert]
        event: {
            until: [
                { send: menu, name: completion_menu }
                { send: menunext }
            ]
        }
    }
    # Right Arrow — accept full history hint (like zsh right arrow)
    {
        name: history_hint_complete
        modifier: none
        keycode: right
        mode: [emacs vi_insert]
        event: {
            until: [
                { send: historyhintcomplete }
                { edit: moveright }
            ]
        }
    }
    # Shift+Tab — previous completion match
    {
        name: completion_previous
        modifier: shift
        keycode: backtab
        mode: [emacs vi_insert]
        event: { send: menuprevious }
    }
    # Ctrl+F — accept full history hint (like zsh autosuggest-accept)
    {
        name: accept_suggestion_ctrl_f
        modifier: control
        keycode: char_f
        mode: [emacs vi_insert]
        event: { send: historyhintcomplete }
    }
    # Ctrl+T — fzf file finder
    {
        name: fzf_file_finder
        modifier: control
        keycode: char_t
        mode: [emacs vi_normal vi_insert]
        event: {
            send: executehostcommand
            cmd: "commandline edit --insert (fd --hidden --exclude .git --type f | fzf --height 40% --reverse --border | str trim)"
        }
    }
    # Alt+C — fzf directory cd
    {
        name: fzf_cd
        modifier: alt
        keycode: char_c
        mode: [emacs vi_normal vi_insert]
        event: {
            send: executehostcommand
            cmd: "cd (fd --type d --hidden --exclude .git | fzf --height 40% --reverse --border | str trim)"
        }
    }
    # Alt+. — insert last argument from previous command
    {
        name: insert_last_arg
        modifier: alt
        keycode: char_.
        mode: [emacs vi_insert]
        event: [
            { edit: insertstring, value: "!$" }
        ]
    }
    # Delete (forward delete) — accept inline history ghost suggestion
    {
        name: history_hint_delete
        modifier: none
        keycode: delete
        mode: [emacs vi_insert]
        event: { send: historyhintcomplete }
    }
]

# =============================================================================
# THEME / COLORS
# =============================================================================

$env.config.color_config = {
    separator: default
    leading_trailing_space_bg: { attr: n }
    header: green_bold
    empty: blue
    bool: light_cyan
    int: default
    filesize: cyan
    duration: default
    datetime: purple
    range: default
    float: default
    string: default
    nothing: default
    binary: default
    cell-path: default
    row_index: green_bold
    record: default
    list: default
    closure: green_bold
    glob:cyan_bold
    block: default
    hints: dark_gray
    search_result: { bg: red fg: default }
    shape_binary: purple_bold
    shape_block: blue_bold
    shape_bool: light_cyan
    shape_closure: green_bold
    shape_custom: green
    shape_datetime: cyan_bold
    shape_directory: cyan
    shape_external: cyan
    shape_externalarg: green_bold
    shape_external_resolved: light_yellow_bold
    shape_filepath: cyan
    shape_flag: blue_bold
    shape_float: purple_bold
    shape_glob_interpolation: cyan_bold
    shape_globpattern: cyan_bold
    shape_int: purple_bold
    shape_internalcall: cyan_bold
    shape_keyword: cyan_bold
    shape_list: cyan_bold
    shape_literal: blue
    shape_match_pattern: green
    shape_matching_brackets: { attr: u }
    shape_nothing: light_cyan
    shape_operator: yellow
    shape_pipe: purple_bold
    shape_range: yellow_bold
    shape_record: cyan_bold
    shape_redirection: purple_bold
    shape_signature: green_bold
    shape_string: green
    shape_string_interpolation: cyan_bold
    shape_table: blue_bold
    shape_variable: purple
    shape_vardecl: purple
    shape_raw_string: light_purple
    shape_garbage: {
        fg: default
        bg: red
        attr: b
    }
}

# =============================================================================
# ALIASES
# =============================================================================

alias l = ls -la
alias ll = ls -la

# Alias tree, la, lt to eza directly. We avoid aliasing 'ls' to 'eza'
# because it breaks Nushell's native structured data pipelines (like `ls | get name`).
alias tree = eza --tree --icons --group-directories-first
alias la = eza -la --icons --group-directories-first --git
alias lt = eza -la --icons --sort=modified --reverse

alias cat = bat

# Git
alias gs = git status
alias gc = git commit -a -m
alias gp = git push
alias ga = git add .
alias gd = git diff
alias gl = git log --oneline --graph --decorate -20

# Applications
alias nv = nvim
alias n = nvim
alias k = kubectl
alias o = open
alias oc = opencode
alias cl = claude

# =============================================================================
# FUNCTIONS
# =============================================================================

def fnv [find?: string] {
    if ($find == null) {
        print "Usage: fnv <search_term>"
        return
    }

    if (which fd | is-empty) or (which fzf | is-empty) or (which nvim | is-empty) {
        print "Error: fnv requires fd, fzf, and nvim to be installed."
        return
    }

    let selected = (fd --hidden --exclude .git $find | fzf --preview 'bat --color=always --style=numbers {}' | str trim)
    if ($selected | is-not-empty) {
        nvim $selected
    }
}

def peek [...args: string] {
    if ($args | is-empty) {
        print "Usage: peek <file>"
        return
    }
    bat --color=always --style=numbers,header,grid ...$args
}

def mkcd [dir: string] {
    mkdir $dir
    cd $dir
}

# =============================================================================
# EXTENSIONS & TOOLS
# =============================================================================

# Direnv
if ($env.config.hooks.env_change.PWD? | is-empty) {
    $env.config.hooks.env_change.PWD = []
}

$env.config.hooks.env_change.PWD = (
    $env.config.hooks.env_change.PWD | append { |before, after|
        if (which direnv | is-empty) { return }
        let direnv_output = (do -i { direnv export json | from json })
        if ($direnv_output | is-empty) { return }
        $direnv_output | load-env
    }
)

# Source tool initializations (generated in env.nu)
source ~/.cache/nushell/zoxide.nu
source ~/.cache/nushell/atuin.nu
source ~/.cache/nushell/carapace.nu


# Secrets — loads export KEY=VALUE from ~/.secretsrc (zsh-compatible)
let secrets_file = ($env.HOME | path join ".secretsrc")
if ($secrets_file | path exists) {
    open $secrets_file
    | lines
    | where {|l| ($l | str trim) =~ '^export \w+='}
    | parse --regex 'export (?P<key>\w+)=(?P<value>.*)'
    | each {|r| {($r.key): ($r.value | str trim | str replace -r '^["'']' '' | str replace -r '["'']$' '')}}
    | reduce -f {} {|it, acc| $acc | merge $it}
    | load-env
}
