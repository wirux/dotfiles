# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =============================================================================
# ENVIRONMENT VARIABLES
# =============================================================================

# Set language
export LANG=en_US.UTF-8

# REPO Directory
export REPO="$HOME/Documents/repos"

# Ruby
if [ -d "/opt/homebrew/opt/ruby/bin" ]; then
  export PATH=/opt/homebrew/opt/ruby/bin:$PATH
  # Check if gem is available before running it to avoid errors
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

# =============================================================================
# THEME (Powerlevel10k)
# =============================================================================

if [ -f "$(brew --prefix)/opt/powerlevel10k/share/powerlevel10k/powerlevel10k.zsh-theme" ]; then
    source "$(brew --prefix)/opt/powerlevel10k/share/powerlevel10k/powerlevel10k.zsh-theme"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Config for p10k
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# =============================================================================
# ZSH OPTIONS & HISTORY
# =============================================================================

# History config
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Options
setopt complete_aliases

# =============================================================================
# COMPLETION SYSTEM
# =============================================================================

autoload -U +X bashcompinit && bashcompinit
autoload -Uz compinit && compinit

# =============================================================================
# PLUGINS & EXTENSIONS
# =============================================================================

# Define plugins list (Note: This array is typically used by Oh My Zsh, 
# but defined here for reference or if OMZ is loaded later/manually)
plugins=( 
  git
  terraform
  macos
  ruby
  rails
  bundler
)

# Docker Desktop Init
if [ -f "/Users/adamwilczek/.docker/init-zsh.sh" ]; then
    source /Users/adamwilczek/.docker/init-zsh.sh || true
fi

# Zsh Autosuggestions
if [ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    ZSH_AUTOSUGGEST_STRATEGY=(history completion) 
fi

# Zsh Autocomplete
if [ -f "$(brew --prefix)/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh" ]; then
    source "$(brew --prefix)/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
fi

# Zsh Syntax Highlighting
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

# zoxide (cd replacement)
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi

# fzf (fuzzy finder)
if command -v fzf &> /dev/null; then
    source <(fzf --zsh)
fi

# direnv
if command -v direnv &> /dev/null; then
    eval "$(direnv hook zsh)"
fi

# =============================================================================
# APPLICATION SPECIFIC CONFIG
# =============================================================================

# Azure
if [ -f ~/.zsh/autocompletion_addons/az.completion ]; then
    source ~/.zsh/autocompletion_addons/az.completion
fi

# Terraform
if command -v terraform &> /dev/null; then
    complete -o nospace -C /opt/homebrew/bin/terraform terraform
fi

# Kubectl
if command -v kubectl &> /dev/null; then
    source <(kubectl completion zsh)
fi

# Google Cloud SDK
if [ -f "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc" ]; then
    source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
fi
if [ -f "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc" ]; then
    source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"
fi

# =============================================================================
# ALIASES
# =============================================================================

# General
alias l="ls -lah"
alias ll="ls -la"
# Check if lsd is installed for enhanced ls
if command -v lsd &> /dev/null; then
    alias ls="lsd"
    alias tree="lsd --tree"
fi
alias cat="bat" # Ensure bat is installed, otherwise this might fail if not handled. 
                # Ideally: if command -v bat &> /dev/null; then alias cat="bat"; fi

# Git
alias gs="git status"
alias gc="git commit -a -m"
alias gp="git push"
alias ga="git add ."

# Applications
alias nv="nvim"
alias n="nvim"
alias cd="z"
alias k="kubectl"
alias o="opencode"

# Python (Pyenv)
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
# if command -v pyenv &> /dev/null; then
#   export PATH="$HOME/.pyenv/bin:$PATH"
#   eval "$(pyenv init -)"
    # alias python="$(pyenv which python)"
    # alias pip="$(pyenv which pip)"
# fi

# =============================================================================
# FUNCTIONS
# =============================================================================

# Find file and run nvim on it
# Requires: fd, fzf, bat, nvim
fnv() {
  local find="$1"
  if command -v fd &> /dev/null && command -v fzf &> /dev/null && command -v nvim &> /dev/null; then
      fd --hidden --exclude .git  "$find" | fzf --preview='bat {}' | xargs nvim
  else
      echo "Error: fnv requires fd, fzf, and nvim to be installed."
  fi
}

# =============================================================================
# KEY BINDINGS
# =============================================================================

# Autosuggest
bindkey '^I'   complete-word 
bindkey '^I^I' autosuggest-accept

# Cursor movement
bindkey -M menuselect  '^[[D' .backward-char  '^[OD' .backward-char
bindkey -M menuselect  '^[[C'  .forward-char  '^[OC'  .forward-char

# =============================================================================
# SECRETS
# =============================================================================

if [ -f "$HOME/.secretsrc" ]; then
    source "$HOME/.secretsrc"
fi
