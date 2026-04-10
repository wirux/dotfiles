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
