(fn setup []
  (let [auto-pairs vim.g.AutoPairs]
    (when auto-pairs
      (tset auto-pairs "'" nil)
      (tset auto-pairs "`" nil)
      (set nvim.b.AutoPairs auto-pairs))))

;; I'll need to come back to this.....
; (augroup auto-pairs-config
;   (nvim.ex.autocmd
;     :FileType "clojure,fennel,scheme"
;     (.. "call v:lua.require('" *module-name* "').setup()")))
