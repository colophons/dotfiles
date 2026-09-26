# Pi

## Dependencies

- Pi coding agent.
- GNU Stow.
- The skills listed in `settings.json`, under `~/sys/skills/`.
- The local package `~/pi-adhoc/handoff.ts`, referenced as
  `../../pi-adhoc/handoff.ts` relative to `~/.pi/agent/`.

The declared npm and Git packages are managed by Pi. Their downloaded copies
stay on each machine. The skill files and local package are separate from this
dotfiles package and must be made available on each machine.

## Initial setup

From the dotfiles repository root:

```sh
stow --target="$HOME" --no-folding --simulate --verbose pi
```

If an existing `~/.pi/agent/settings.json` conflicts, review it and move that
file to a local backup before applying:

```sh
stow --target="$HOME" --no-folding --verbose pi
```

`--no-folding` keeps `~/.pi` and `~/.pi/agent` as ordinary directories, even on a
fresh machine. Only `~/.pi/agent/settings.json` becomes a symlink into this
repository. Authentication, sessions, trust decisions, extensions, and package
caches remain machine-local. The package's Stow ignore file permits only this
settings file; Git has a matching exclusion for other Pi state.

Changes made through Pi's settings UI also write to the shared file. Pi may
update bookkeeping such as `lastChangelogVersion` there. Review those changes
with `git diff`; commit/push/pull carries them to other machines. After manually
editing settings, use `/reload` in a running Pi session.

See Pi's [configuration documentation](https://pi.dev/docs/latest/configuration).
