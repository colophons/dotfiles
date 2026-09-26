# Local date, matching the effective (last) definition in .aliases.
def datestamp [] {
    date now | format date "%Y-%m-%d"
}

alias gits = ^git status

# Print status before staging. Forward flags and filenames as separate args.
def --wrapped gita [...args: string] {
    ^git status
    if $env.LAST_EXIT_CODE == 0 {
        ^git add ...$args
    }
}

# Usage: gitm "commit message" [additional git commit flags]
def --wrapped gitm [message: string, ...args: string] {
    ^git status
    if $env.LAST_EXIT_CODE == 0 {
        ^git commit -m $message ...$args
    }
}

def duckduckgo [...words: string] {
    let query = $words | str join " " | url encode --all
    let url = $"https://lite.duckduckgo.com/lite/?kp=-1&kd=-1&q=($query)"
    print $url
    ^cha $url
}
