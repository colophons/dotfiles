
(fn exset [cmd]
  (vim.cmd (.. "set " cmd)))

(fn extunmap [binding]
  (vim.cmd (.. "tunmap " binding)))

  (set vim.g.vim_better_default_persistent_undo true)

  ; (nvim.ex.runtime_ "plugin/default.vim")

  (exset :nonumber)
  (exset :norelativenumber)
  (exset :wrap)
  (exset :nocursorline)
  (exset "wildmode=full")
  (exset "wildoptions=pum")
  (exset "listchars-=eol:↵")

  (set vim.o.undodir (.. (vim.fn.stdpath "data") "/undo"))

  (exset "clipboard-=unnamedplus")

;  (extunmap :<space>wh)
;  (extunmap :<space>wj)
;  (extunmap :<space>wk)
;  (extunmap :<space>wl)
