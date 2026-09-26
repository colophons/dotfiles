# Neovim

## Dependencies

For this configuration on Linux, install these tools on the machine running
Neovim. Executables must be on the PATH inherited by Neovim.

| Dependency | Purpose |
| --- | --- |
| Neovim 0.12+ built with LuaJIT | Editor and native LSP/completion APIs used by this config |
| Git 2.19+ | Plugin downloads and Fugitive |
| ripgrep (`rg`) | Telescope text search and fallback file search |
| GNU make and GCC or Clang | Build Telescope's native fzf extension |
| `curl` or GNU `wget`, plus `unzip`, GNU `tar`, and `gzip` | Download and extract Mason packages |

The build requirements follow the configured `make` build of
[telescope-fzf-native](https://github.com/nvim-telescope/telescope-fzf-native.nvim#installation);
the download tools follow [Mason's Unix requirements](https://github.com/mason-org/mason.nvim#requirements).

Language support needs additional tools:

| Language | Machine dependencies | Language server |
| --- | --- | --- |
| Rust | `cargo`, `rustc`, `rustfmt`, and matching standard-library sources (`rust-src`) | `rust-analyzer` |
| TypeScript / JavaScript | Node.js and npm; the currently installed typescript-language-server 6.0.0 requires Node >=22.22.2 | `typescript-language-server` |

`rustfmt` provides formatting; `rust-src` provides standard-library navigation.
With rustup, install those components using `rustup component add rustfmt rust-src`.
With a system Rust toolchain, use its matching packages.

Optional: `fd` (or `fdfind`) is used for file discovery when installed. Otherwise,
file search uses `rg`. No Nerd Font is required.

lazy.nvim installs the plugins declared in `lua/plugins/` and `init.lua`;
`lazy-lock.json` records their revisions. The fzf extension is built automatically
and does not require the standalone `fzf` executable. Mason installs language
servers separately; their versions are **not** pinned by `lazy-lock.json`.
Network access is needed for those initial downloads and subsequent updates.

## Initial setup

1. Install the machine dependencies above, including those for the languages
   you use.
2. Link this directory to Neovim's configuration location:
   `${XDG_CONFIG_HOME:-$HOME/.config}/nvim` (normally `~/.config/nvim`). The repository's
   `config` Stow package supplies this link for the default location; if it
   already points here, there is nothing to do.
3. Start `nvim`. The configuration bootstraps lazy.nvim, which installs the
   plugins and builds the native fzf extension. Let installation finish.
4. Install the language servers you use:

   ```vim
   :MasonInstall rust-analyzer typescript-language-server
   ```

5. Restart Neovim, then open a file in a Rust or TypeScript/JavaScript project.
   Rust projects use `Cargo.toml`; TypeScript/JavaScript projects should have
   their `tsconfig.json`/`jsconfig.json` or `package.json` at the project root.

Mason installs servers under Neovim's data directory and prepends its `bin`
directory to Neovim's PATH. Its TypeScript server package also installs
TypeScript. An existing server on PATH can be used instead of installing it
through Mason; Mason's copy takes precedence when present.

Both servers are enabled in `lua/plugins/lsp.lua`. To add a server, install its
executable and add its nvim-lspconfig name to `vim.lsp.enable()` there. The two
configured names are `rust_analyzer` and `ts_ls`.

Use `:Lazy` to manage plugins and `:Lazy restore` to restore locked revisions.
Use `:Mason` to manage language servers. Srcery is the default theme; Zenburn
is available through `:colorscheme zenburn` or `Space fc`.

## Keys

Leader is **Space**. Pause after it for which-key. Most keys below match the old
config; obsolete APIs and bindings to absent plugins were not carried over.

`Space h` is the Help prefix: `Space h h` searches help, and `Space h m` (or
`:Mappings`) opens `mappings://all`, a named, read-only buffer. It lists global
and buffer-local mappings across all modes, including descriptions, actions,
and available source locations. Search and yank from it normally. `gR` refreshes,
Enter visits a source, and `q` closes the window. The buffer remains in the buffer
list and refreshes when revisited; it is regenerated after restarting Neovim.

This is a view of registered mappings: LSP and plugin-window mappings appear
once their contexts create them. Lazy loading triggers are included without
loading their plugins. Lua source locations identify callback definitions,
which may be library functions or loading wrappers rather than binding sites.
Intrinsic commands like `j` and `dw`, and abbreviations, are not included.

| Keys | Action |
| --- | --- |
| `Space q / v` | Confirm quit / vertical split |
| `Space /` | Clear search highlight |
| `Space hh / hm` | Help search / all mappings buffer |
| `Space ff` | Find files from the file's directory (fd/fdfind, falling back to rg) |
| `Space f Space` | Live ripgrep search from the file's directory |
| `Space fg` | Grep word under cursor |
| `Space fb / fr / fl` | Buffers / recent files / resume search |
| `Space fh / fm / fc` | Help / keymaps / colorschemes |
| `Space f-` | File browser (netrw + vinegar, not a Telescope extension) |
| `-` | Browse parent directory, keeping the current file selected |
| `M` (Shift-M) | Harpoon: mark file (normal mode) |
| `Tab` or `Space m` | Harpoon: quick menu (normal mode) |
| `Space fsq` or `Space lq` | Quickfix picker |
| `Space gs / gd / gb` | Git status / vertical diff against index / blame |
| `gd / gI / grr` | Definition / implementations / references |
| `K` or `Space l Space` | Hover |
| `Space la / lr / lf` | Code action / rename / format |
| `Space ls / lh / li` | Signature / toggle inlay hints / LSP health |
| `gl` or `L` | Diagnostics at point |
| `Space lj / lk / lD` | Next / previous / all diagnostics |
| `Space lds / lws` | Document / workspace symbols |
| `Space pl / pm` | Lazy / Mason |

Formatting is explicit (`Space lf`), not on save.
`Space la` and `Space lf` also work on visual selections. References moved from
old `gr` to **`grr`** to leave Neovim's native `grn`, `gra`, `gri`, etc. intact.

Native completion opens on server trigger characters (e.g. `.`). In insert mode:
`Ctrl-Space` requests completion (`Ctrl-X Ctrl-O` is a terminal-safe alternative),
`Ctrl-N/P` selects, `Ctrl-Y` accepts, `Ctrl-E` dismisses; Enter remains Enter.

Inside Telescope: `Ctrl-J/K` select, `Ctrl-N/P` browse query history, Enter opens,
Ctrl-X/V split, Esc then q closes. Buffers start in normal mode; `dd` deletes a
buffer (`Ctrl-D` in insert mode). File search and grep include hidden files, exclude
`.git`, and respect ignore files by default.

`Space f Space` starts grep and `Space ff` starts file search in the current
file's directory. Both pickers share these scope controls:

| Action | Normal mode | Insert mode |
| --- | --- | --- |
| Widen one directory toward the Git root | Left or `<` | Ctrl-Left or Alt-< |
| Narrow toward the original directory | Right or `>` | Ctrl-Right or Alt-> |

The query and editing mode survive scope changes, and the title
shows the search directory. At either endpoint the corresponding key does
nothing. Right retraces the original directory chain; it does not select an
arbitrary child directory.

Both pickers also have these normal-mode bindings:

| Keys | Action |
| --- | --- |
| `ti` | Toggle ignore rules (off includes ignored files) |
| `th` | Toggle hidden files |
| `t.` | Jump directly to the Git root; Right can narrow again |

The title shows `ignore:on/off` and `hidden:on/off`. Both start on for each new
search. Toggles preserve the query and scope; their state survives widening,
narrowing, jumping to the root, and resuming the picker. `.git` remains excluded.
Outside Git, `t.` reports that there is no Git root and leaves the scope alone.

Outside Git, the upper bound is Neovim's working directory if it contains the
file; otherwise the search stays in the file's directory. Unnamed and special
buffers start from the working directory. Symlinked directories are resolved
before finding the Git root. Other search commands, including plain
`:Telescope live_grep` and `:Telescope find_files`, continue to use the working
directory by default.

Harpoon lists are scoped to the current working directory and persisted between
sessions. In its menu, Enter jumps to a file; edit/delete/reorder lines to change
the list, and Esc closes. Only normal-mode Tab is customized; insert-mode Tab
keeps Neovim's snippet-jump-or-indent behavior. As in your old config, M replaces
Vim's middle-of-window motion, and Tab may also occupy Ctrl-I in terminals that
cannot distinguish them.

Vinegar keeps netrw: `-` browses upward, Enter opens a file, `~` goes home,
and `Ctrl-^` returns to the previous buffer.

Fugitive's `:Git` (or `Space gs`) opens repository status; `g?` shows its
available actions. `:Git <command>` runs Git from the current buffer's repository.
`Space gd` compares the current file with its staged version in a vertical split;
`:diffoff!` exits diff mode. `Space gb` opens blame for the current file.
See `:help fugitive` for the full command set.
