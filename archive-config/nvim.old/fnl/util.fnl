(fn exset [cmd]
  (vim.cmd (.. "set " cmd)))

(fn extunmap [binding]
  (vim.cmd (.. "tunmap " binding)))

(fn log [msg sourcefile]
  ;
  )
