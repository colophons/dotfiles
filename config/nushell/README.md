# Nushell

## Dependencies

This configuration targets Linux and was checked with Nushell 0.115.1,
Atuin 18.5.0, and mise 2026.9.1.

- `nu`: Nushell.
- `git`: Git shortcuts and the prompt's branch segment.
- `ssh-agent` and `ssh-add`: OpenSSH agent support.
- `flock` (util-linux) and `chmod` (coreutils): agent startup locking and permissions.
- `atuin`: history integration; `~/.atuin/bin` is included on PATH.
- `mise`: automatic tool/environment activation when entering projects.
- `nvim`: configured editor and command-buffer editor.
- `cha`: Chawan, used by `duckduckgo` and selected as `$env.BROWSER`.

The prompt shows a Kubernetes context when `kubectl` is installed and has a
current context. Ghostty is selected as `$env.TERMINAL`.
Missing Atuin or mise produces a startup notice and skips that integration.

## Initial setup

From the repository root, create an ordinary target directory so history and
machine-local settings stay outside this checkout:

```sh
mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/nushell"
stow --dir=config --target="${XDG_CONFIG_HOME:-$HOME/.config}/nushell" --simulate --verbose nushell
```

If Stow reports existing `config.nu` or `env.nu` files, review and move those
files to backups first. Then apply:

```sh
stow --dir=config --target="${XDG_CONFIG_HOME:-$HOME/.config}/nushell" --verbose nushell
nu
```

Start `nu` from your current shell; `exit` returns there. This setup does not
change the account's login shell or the shell launched by Ghostty/Herdr.
`config nu` opens the linked configuration in Neovim. Start a new Nu session
after editing: re-sourcing would register the integrations' hooks a second time.
Plain `nu -c` does not load these interactive startup files; scripts can source
`commands.nu` explicitly when they need the shortcuts.
As elsewhere in this repository, saves apply locally through symlinks;
commit/push/pull distributes the source to other machines.

## What loads

- `env.nu` preserves inherited PATH entries, adds Krew, local binaries, Atuin,
  scripts, Go, Cargo, and .NET tool paths, and removes duplicates. It generates
  Atuin/mise initialization from the installed tools into a per-process cache
  directory before `config.nu` is parsed. Generated code never enters Git.
- `config.nu` selects vi editing, Neovim, Ghostty, and Chawan, loads the files
  below, activates Atuin and mise, removes the temporary initialization files,
  and attaches an SSH agent.
- `commands.nu` is the complete set of personal shortcuts listed below.
- `prompt.nu` shows `[user@host last/two/directories] (branch) (kube-context)`.
  Git/context segments disappear when unavailable. Vi insert mode uses `$`;
  normal mode uses `>`.
- `ssh-agent.nu` reuses a reachable inherited/forwarded agent first, then the
  `ssh-agent.env` file shared with zsh. Otherwise it reuses or starts an agent
  at a fixed socket under `$XDG_RUNTIME_DIR` (falling back to Nu's cache).
  Concurrent Nu startups share a lock. New agents retain the old **one-hour
  default key lifetime**; keys are added separately with `ssh-add`.

Atuin owns **Ctrl-R** and **Up** in both vi modes (and Emacs mode). Up navigates
an open menu before invoking Atuin. Nu's configuration exposes these bindings:

```nu
$env.config.keybindings | where name =~ atuin
```

The generator adapts Atuin 18.5's deprecated `get -i` spelling and duplicate
keybinding names for current Nu. Otherwise initialization comes directly from
the installed tools. See [Atuin's Nu setup](https://docs.atuin.sh/latest/guide/installation/#installing-the-shell-plugin)
and [mise's Nu setup](https://mise.jdx.dev/installing-mise.html#nushell).

## Shortcuts

| Command | Behavior |
| --- | --- |
| `datestamp` | Local date as `YYYY-MM-DD` |
| `gits` | `git status` |
| `gita ...args` | Show status, then `git add` with the supplied arguments |
| `gitm "message" ...args` | Show status, then `git commit -m` with the supplied message and extra flags |
| `duckduckgo ...words` | URL-encode a query and open DuckDuckGo Lite in Chawan |

`gita` and `gitm` stop if `git status` fails. Arguments remain separate, including
filenames or commit messages containing spaces. `ls` keeps Nu's structured
behavior.

## Machine-local settings

Nu automatically loads `*.nu` files in its configuration's `autoload/` directory
after `config.nu`. Create `~/.config/nushell/autoload/90-local.nu` (under
`$XDG_CONFIG_HOME` when set) for private environment values or local commands.
This target directory remains outside the repository with the deployment above.
The old `.localaliases` file is zsh code and is not sourced or copied.

See the [Nu configuration guide](https://www.nushell.sh/book/configuration.html).
