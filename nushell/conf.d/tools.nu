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
