;(let [(ok? which-key) (pcall require :which-key)]
;  (when ok?
;    (which-key.setup {})))

(let [(ok? which-key) (pcall require :which-key)]
  (when ok?
    (which-key.setup {})))
