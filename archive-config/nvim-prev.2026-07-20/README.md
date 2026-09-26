# Neovim

A small, vi-native editor layer for a terminal-centered operations workflow.
It is intentionally not an IDE distribution or an operations cockpit.

## Requirements

- Neovim 0.11.7 or newer
- git
- ripgrep for live grep
- fd for fast file discovery
- make and a C compiler for Telescope's native FZF sorter

The native editor starts without network access or plugins. On the first
connected session, run :PluginBootstrap to install Lazy, Telescope, and
Harpoon. Later, use :Lazy sync to update them and :checkhealth telescope to
diagnose finder dependencies.

## Editing model

Native Vim behavior wins by default. In particular:

- <C-o> and <C-i>/<Tab> move backward and forward through the jumplist.
- - opens the built-in file browser.
- <C-h/j/k/l> moves between windows.
- <leader>w writes the current buffer.
- <leader>y and <leader>p use the system clipboard.
- <leader><CR> or <leader>tt opens a terminal at the buffer's directory.
- ;; or <Esc><Esc> leaves terminal mode.
- [q and ]q move through quickfix entries.

## Finding

- <leader>ff files, including hidden files while respecting ignore rules
- <leader>fg or <leader>f<Space> live grep
- <leader>f* grep the word under the cursor
- <leader>fb open buffers
- <leader>fr recent files in the current working directory
- <leader>f/ fuzzy search the current buffer
- <leader>fa marks
- <leader>fj jumplist
- <leader>fh help
- <leader>fk keymaps
- <leader>fl resume the last picker

## Working set

Harpoon is the small, deliberate working set:

- <leader>ha add the current file
- <leader>hh show the list
- <leader>h1 through <leader>h4 select slots
- [h and ]h move through the list

## Deliberately deferred

Org, TKO, agent/session orchestration, LSP, completion, Treesitter, formatting,
and Git UI belong to later layers. The older experiments remain under
lua/user.old and lua/bespoke, but are not part of startup.
