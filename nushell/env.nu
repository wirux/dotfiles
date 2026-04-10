# Default Nushell Environment Config File
# These "sensible defaults" are set before the user's `env.nu` is loaded
#
# version = "0.111.0"

$env.PROMPT_COMMAND = {||
    let dir = match (do -i { $env.PWD | path relative-to $nu.home-dir }) {
        null => $env.PWD
        '' => '~'
        $relative_pwd => ([~ $relative_pwd] | path join)
    }

    let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
    let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
    let path_segment = $"($path_color)($dir)(ansi reset)"

    $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"
}

$env.PROMPT_COMMAND_RIGHT = {||
    # create a right prompt in magenta with green separators and am/pm underlined
    let time_segment = ([
        (ansi reset)
        (ansi magenta)
        (date now | format date '%x %X') # try to respect user's locale
    ] | str join | str replace --regex --all "([/:])" $"(ansi green)${1}(ansi magenta)" |
        str replace --regex --all "([AP]M)" $"(ansi magenta_underline)${1}")

    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
        (ansi rb)
        ($env.LAST_EXIT_CODE)
    ] | str join)
    } else { "" }

    ([$last_exit_code, (char space), $time_segment] | str join)
}
# =============================================================================
# ENVIRONMENT VARIABLES
# =============================================================================

$env.LANG = "en_US.UTF-8"
$env.REPO = ($env.HOME | path join "Documents/repos")
$env.BUN_INSTALL = ($env.HOME | path join ".bun")

$env.PATH = (
    $env.PATH
    | prepend '/opt/homebrew/opt/ruby/bin'
    | prepend '/opt/homebrew/lib/ruby/gems/3.4.0/bin'
    | prepend ($env.HOME | path join '.bun' 'bin')
    | prepend ($env.HOME | path join '.duckdb' 'cli' 'latest')
    | prepend ($env.HOME | path join '.pyenv' 'shims')
    | prepend ($env.HOME | path join '.pyenv' 'bin')
    | where { |p| $p | path exists }
    | uniq
)

# =============================================================================
# TOOL INITIALIZATIONS
# =============================================================================

let cache_dir = ($env.HOME | path join ".cache" "nushell")
if not ($cache_dir | path exists) { mkdir $cache_dir }

if (which zoxide | is-not-empty) {
    zoxide init nushell --cmd cd | save -f ($cache_dir | path join "zoxide.nu")
} else {
    "" | save -f ($cache_dir | path join "zoxide.nu")
}

if (which atuin | is-not-empty) {
    $env.ATUIN_DB_PATH = ($env.HOME | path join ".local/share/atuin/history-nu.db")
    atuin init nu --disable-up-arrow | save -f ($cache_dir | path join "atuin.nu")
} else {
    "" | save -f ($cache_dir | path join "atuin.nu")
}

if (which carapace | is-not-empty) {
    $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
    mkdir ($env.HOME | path join ".cache/carapace")
    carapace _carapace nushell | save -f ($cache_dir | path join "carapace.nu")
} else {
    "" | save -f ($cache_dir | path join "carapace.nu")
}

$env.EDITOR = "nvim"
$env.VISUAL = "nvim"
$env.AICHAT_CONFIG_DIR = ($env.HOME | path join ".config/aichat")

# Starship Prompt
$env.TRANSIENT_PROMPT_COMMAND_RIGHT = null
$env.STARSHIP_CONFIG = ($env.HOME | path join ".config/starship/starship.toml")
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
