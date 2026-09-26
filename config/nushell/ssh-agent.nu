# Invoked by config.nu under flock. stdout is a JSON environment record.
def agent-ready [] {
    let result = ^ssh-add -l | complete
    # ssh-add returns 1 for an accessible agent with no identities, 2 for no agent.
    $result.exit_code in [0 1]
}

def agent-vars [] {
    $in
    | parse --regex '(?m)^(?<name>SSH_AUTH_SOCK|SSH_AGENT_PID)=(?<value>.*); export (?:SSH_AUTH_SOCK|SSH_AGENT_PID);$'
    # OpenSSH double-quotes and escapes socket paths when shell quoting is needed.
    | update value { str trim --char '"' | str replace --all --regex '\\(["\\$`])' '$1' }
    | reduce --fold {} {|entry, vars| $vars | upsert $entry.name $entry.value }
}

def main [runtime: path] {
    if ($env.SSH_AUTH_SOCK? | is-not-empty) and (agent-ready) {
        return ({SSH_AUTH_SOCK: $env.SSH_AUTH_SOCK} | to json --raw)
    }

    # Share the environment file already used by .zshrc, without evaluating it.
    let saved = $runtime | path join "ssh-agent.env"
    if ($saved | path exists) {
        let vars = open --raw $saved | agent-vars
        if ($vars.SSH_AUTH_SOCK? | is-not-empty) and (with-env $vars { agent-ready }) {
            return ($vars | to json --raw)
        }
    }

    let socket = $runtime | path join "dotfiles-ssh-agent.sock"
    let vars = {SSH_AUTH_SOCK: $socket}
    if (with-env $vars { agent-ready }) {
        return ($vars | to json --raw)
    }

    # Only remove our own stale socket, after testing whether an agent answers.
    if ($socket | path exists) { rm --force $socket }
    let started = ^ssh-agent -a $socket -t 1h -s | complete
    if $started.exit_code != 0 {
        error make {msg: ($started.stderr | str trim)}
    }
    $started.stdout | save --force $saved
    ^chmod 600 $saved
    $started.stdout | agent-vars | to json --raw
}
