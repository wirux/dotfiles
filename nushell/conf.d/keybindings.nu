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
