# Herdr

## Dependencies

Install on every machine that hosts Herdr sessions:

- Herdr 0.9.0 (the version used by these helpers and tests).
- Python 3, available as `python3` on PATH; no third-party Python packages.
- fzf, available as `fzf` on the Herdr server's PATH, for the pane menu.
- GNU Stow for deployment from this repository.

These helpers target Linux/macOS: the layout helper uses Unix sockets and
`fcntl` file locking. Herdr runs custom commands on the session's server;
connecting from another device does not copy the configuration or helpers.
See [Settings and automation](https://herdr.dev/docs/connecting-machines/#settings-and-automation).

## Deployment

From the repository root, create the target directory if necessary, then preview
only the Herdr package:

```sh
mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/herdr"
stow --dir=config --target="${XDG_CONFIG_HOME:-$HOME/.config}/herdr" --simulate --verbose herdr
```

Stow reports conflicts instead of overwriting existing files. If `config.toml`
is a regular file, compare it with this copy, keep any wanted settings, and move
the original to a backup before applying. Existing session files stay in place.

```sh
stow --dir=config --target="${XDG_CONFIG_HOME:-$HOME/.config}/herdr" --verbose herdr
herdr server reload-config
```

Use Herdr's UI **reload config** action too if an attached client still shows
old bindings. It reloads client settings and the selected server's configuration.
The repository's full `deploy.sh` also deploys this directory as part of `config`
to the default `~/.config` location. The targeted commands above avoid deploying
unrelated packages and also support `XDG_CONFIG_HOME`.

The helpers live in `bin/` beside this configuration. Bindings use
`${XDG_CONFIG_HOME:-$HOME/.config}/herdr/bin`, so no username or checkout location
is embedded in them. The two helpers must stay together: the menu invokes its
sibling layout helper.

Stow creates symlinks. Saving in this checkout immediately changes the files
visible on this machine; Herdr config edits still need a reload. Helper edits
take effect on the next invocation. Commit, push, and pull distribute changes
to another machine; pulling into a linked checkout changes its visible files.

## Bindings

Prefix is **Ctrl-a**.

| Keys | Action |
| --- | --- |
| Ctrl-a, m | Pane menu: move to tab, rename, vertical focus, balance |
| Ctrl-h / j / k / l | Focus left / down / up / right and maximize pane height |

These Ctrl bindings are direct Herdr shortcuts and take precedence over the
same keys in applications inside its panes. Pane-menu actions target the pane
captured when the binding was invoked, not the popup itself.

## Tests

From the repository root:

```sh
python3 -m unittest discover -s config/herdr/tests -v
```

Tests load the adjacent helper sources. The layout integration test starts and
stops its own server in a temporary configuration directory; it checks that
resizing preserves pane identities and shell processes. It does not operate on
the user's running session. Menu tests simulate choices and API calls.
