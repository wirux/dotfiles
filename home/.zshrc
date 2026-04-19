# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =============================================================================
# ENVIRONMENT VARIABLES
# =============================================================================

export LANG=en_US.UTF-8
export REPO="$HOME/Documents/repos"

# Ruby
if [ -d "/opt/homebrew/opt/ruby/bin" ]; then
  export PATH=/opt/homebrew/opt/ruby/bin:$PATH
  if command -v gem &> /dev/null; then
      export PATH="$(gem environment gemdir)/bin:$PATH"
  fi
fi

# Bun
export BUN_INSTALL="$HOME/.bun"
if [ -d "$BUN_INSTALL/bin" ]; then
  export PATH="$BUN_INSTALL/bin:$PATH"
fi

# DuckDB
if [ -d "$HOME/.duckdb/cli/latest" ]; then
  export PATH="$HOME/.duckdb/cli/latest:$PATH"
fi

# AI Chat CLI
if command -v aichat &> /dev/null; then
  export AICHAT_CONFIG_DIR="$HOME/.config/aichat"
fi

 # =============================================================================
# THEME (Powerlevel10k)
# =============================================================================

if [ -f "$(brew --prefix)/opt/powerlevel10k/share/powerlevel10k/powerlevel10k.zsh-theme" ]; then
    source "$(brew --prefix)/opt/powerlevel10k/share/powerlevel10k/powerlevel10k.zsh-theme"
fi

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# =============================================================================
# ZSH OPTIONS & HISTORY
# =============================================================================

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt share_history          # Useful with tmux — shared history across panes
setopt complete_aliases

# =============================================================================
# COMPLETION SYSTEM
# =============================================================================

autoload -U +X bashcompinit && bashcompinit
autoload -Uz compinit && compinit

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no                            # Disabled — fzf-tab takes over
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' group-name ''

# fzf-tab preview rules
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons $realpath'
zstyle ':fzf-tab:complete:ls:*' fzf-preview 'eza -1 --color=always --icons $realpath'
zstyle ':fzf-tab:complete:cat:*' fzf-preview 'bat --color=always --style=numbers --line-range=:50 $realpath 2>/dev/null || eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:bat:*' fzf-preview 'bat --color=always --style=numbers --line-range=:50 $realpath 2>/dev/null || eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:nvim:*' fzf-preview 'bat --color=always --style=numbers --line-range=:50 $realpath 2>/dev/null || eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:n:*' fzf-preview 'bat --color=always --style=numbers --line-range=:50 $realpath 2>/dev/null || eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:kill:argument-rest' fzf-preview 'ps -p $word -o pid,user,%cpu,%mem,command'
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

# fzf-tab appearance
zstyle ':fzf-tab:*' fzf-flags --height=40% --layout=reverse --border --info=inline
zstyle ':fzf-tab:*' switch-group '<' '>'

# =============================================================================
# PLUGINS & EXTENSIONS
# =============================================================================

plugins=( 
  git
  terraform
  macos
  # ruby
  # rails
  bundler
)

# Docker Desktop
if [ -f "/Users/adamwilczek/.docker/init-zsh.sh" ]; then
    source /Users/adamwilczek/.docker/init-zsh.sh || true
fi

# Zsh Autosuggestions
if [ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
fi

# fzf-tab (must load AFTER compinit and autosuggestions)
if [ -f "$(brew --prefix)/share/fzf-tab/fzf-tab.plugin.zsh" ]; then
    source "$(brew --prefix)/share/fzf-tab/fzf-tab.plugin.zsh"
fi

# Zsh Syntax Highlighting (should be loaded last)
if [ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# Bun Completions
if [ -s "/Users/adamwilczek/.bun/_bun" ]; then
    source "/Users/adamwilczek/.bun/_bun"
fi

# =============================================================================
# TOOL INITIALIZATIONS
# =============================================================================

if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi

if command -v fzf &> /dev/null; then
    source <(fzf --zsh)
fi

if command -v direnv &> /dev/null; then
    eval "$(direnv hook zsh)"
fi

# atuin — modern shell history with SQLite backend and fuzzy search
if command -v atuin &> /dev/null; then
    export ATUIN_DB_PATH="$HOME/.local/share/atuin/history-zsh.db"
    eval "$(atuin init zsh --disable-up-arrow)"
fi

# =============================================================================
# APPLICATION SPECIFIC CONFIG
# =============================================================================

if [ -f ~/.zsh/autocompletion_addons/az.completion ]; then
    source ~/.zsh/autocompletion_addons/az.completion
fi

if command -v terraform &> /dev/null; then
    complete -o nospace -C /opt/homebrew/bin/terraform terraform
fi

if command -v kubectl &> /dev/null; then
    source <(kubectl completion zsh)
fi

if [ -f "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc" ]; then
    source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
fi
if [ -f "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc" ]; then
    source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"
fi

# =============================================================================
# ALIASES
# =============================================================================

alias l="ls -lah"
alias ll="ls -la"

if command -v eza &> /dev/null; then
    alias ls="eza --icons --group-directories-first"
    alias tree="eza --tree --icons --group-directories-first"
    alias la="eza -la --icons --group-directories-first --git"
    alias lt="eza -la --icons --sort=modified --reverse"
fi

if command -v bat &> /dev/null; then
    alias cat="bat"
fi

# Git
alias gs="git status"
alias gc="git commit -a -m"
alias gp="git push"
alias ga="git add ."
alias gd="git diff"
alias gl="git log --oneline --graph --decorate -20"

# Applications
alias nv="nvim"
alias n="nvim"
alias cd="z"
alias k="kubectl"
alias o="open"
alias oc="opencode"
alias cl="claude"

# =============================================================================
# PYTHON (Pyenv)
# =============================================================================

if command -v pyenv &> /dev/null; then
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
fi

# =============================================================================
# FUNCTIONS
# =============================================================================

fnv() {
  local find="$1"
  if command -v fd &> /dev/null && command -v fzf &> /dev/null && command -v nvim &> /dev/null; then
      fd --hidden --exclude .git "$find" | fzf --preview='bat --color=always --style=numbers {}' | xargs nvim
  else
      echo "Error: fnv requires fd, fzf, and nvim to be installed."
  fi
}

peek() {
  if [ -z "$1" ]; then
    echo "Usage: peek <file>"
    return 1
  fi
  bat --color=always --style=numbers,header,grid "$@"
}

mkcd() {
  mkdir -p "$1" && cd "$1"
}

# =============================================================================
# KEY BINDINGS
# =============================================================================
KEYTIMEOUT=15
# Tab = fzf-tab completion (handled by plugin automatically)
bindkey '^I'   complete-word
bindkey '^I^I' autosuggest-accept
# Delete (forward delete) — accept autosuggestion (inline ghost from history)
bindkey '\e[3~' autosuggest-accept
# =============================================================================
# SECRETS
# =============================================================================

if [ -f "$HOME/.secretsrc" ]; then
    source "$HOME/.secretsrc"
fi

# opencode
export PATH=/Users/adamwilczek/.opencode/bin:$PATH

# Disable oh-my-opencode telemetry
export OMO_SEND_ANONYMOUS_TELEMETRY=0
export OMO_DISABLE_POSTHOG=1
