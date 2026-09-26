def prompt-directory [] {
    let directory = if $env.PWD == $env.HOME {
        "~"
    } else if ($env.PWD | str starts-with $"($env.HOME)/") {
        $"~/($env.PWD | path relative-to $env.HOME)"
    } else {
        $env.PWD
    }
    let parts = $directory | split row "/" | where $it != ""
    if ($parts | length) > 2 { $parts | last 2 | str join "/" } else { $directory }
}

def prompt-segment [value: string] {
    $"(ansi magenta)\((ansi green)($value)(ansi magenta)\) "
}

let prompt_user = $env.USER? | default "?"
let prompt_host = sys host | get hostname | split row "." | first
$env.PROMPT_COMMAND = {||
    let branch = if (which git | is-not-empty) {
        let result = ^git rev-parse --abbrev-ref HEAD | complete
        if $result.exit_code == 0 { prompt-segment ($result.stdout | str trim) } else { "" }
    } else { "" }
    let context = if (which kubectl | is-not-empty) {
        let result = ^kubectl config current-context | complete
        if $result.exit_code == 0 and ($result.stdout | str trim | is-not-empty) {
            prompt-segment ($result.stdout | str trim)
        } else { "" }
    } else { "" }
    $"(ansi magenta)[(ansi cyan)($prompt_user)(ansi magenta)@(ansi cyan)($prompt_host) (ansi green)(prompt-directory)(ansi magenta)] ($branch)($context)(ansi reset)"
}
$env.PROMPT_COMMAND_RIGHT = ""
$env.PROMPT_INDICATOR = "$ "
$env.PROMPT_INDICATOR_VI_INSERT = "$ "
$env.PROMPT_INDICATOR_VI_NORMAL = "> "
$env.PROMPT_MULTILINE_INDICATOR = "... "
