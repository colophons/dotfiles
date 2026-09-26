# These paths must be ready before generating the integrations below.
$env.PATH = (
    $env.PATH
    | prepend [
        (($env.KREW_ROOT? | default ($env.HOME | path join ".krew")) | path join "bin")
        ($env.HOME | path join ".local" "bin")
        ($env.HOME | path join ".atuin" "bin")
    ]
    | append [
        ($env.HOME | path join "scripts")
        ($env.HOME | path join "go" "bin")
        ($env.HOME | path join ".cargo" "bin")
        ($env.HOME | path join ".dotnet" "tools")
    ]
    | uniq
)

# Nu parses source/use before evaluation. Generate these in env.nu so they
# exist when config.nu is parsed. Each shell gets its own PATH-dependent copy.
let init_dir = $nu.cache-dir | path join $"init-($nu.pid)"
mkdir $init_dir
^chmod 700 $init_dir
for tool in [atuin mise] {
    let target = $init_dir | path join $"($tool).nu"
    let generated = if (which $tool | is-empty) {
        {exit_code: 1, stdout: "", stderr: $"($tool) is not on PATH"}
    } else if $tool == "atuin" {
        ^atuin init nu | complete
    } else {
        ^mise activate nu | complete
    }
    if $generated.exit_code == 0 {
        # Atuin 18.5 uses an old get flag and gives both bindings the same name.
        let script = if $tool == "atuin" {
            $generated.stdout
            | str replace --all "get -i " "get -o "
            | str replace --regex '(name:\s*)atuin(\s+modifier:\s*none)' '${1}atuin_up${2}'
        } else { $generated.stdout }
        $script | save --force $target
    } else {
        "" | save --force $target
        print --stderr $"Nu: skipping ($tool) integration: ($generated.stderr | str trim)"
    }
}
