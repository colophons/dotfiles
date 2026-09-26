
 (fn pecho [ok? ...]
  "nvim_echo vargs, as DiagnosticHint or DiagnosticError depending on ok?"
  (let [{: nvim_echo} vim.api
        {: view} (require :fennel)
        hl (if ok? :DiagnosticHint :DiagnosticError)
        list [...]
        output []]
    ;; TODO: this can be fcollect in fennel 1.2.0)
    (for [i 1 (select :# ...)]
      (table.insert output (-> (. list i)
                               (#(match (type $1)
                                   :table (view $1)
                                   _ (tostring $1)))
                               (.. "\n"))))
    (nvim_echo (icollect [_ l (ipairs output)] [l hl]) true {})))

(vim.keymap.set :n :heb
                #(let [{: eval-buffer} (require :hotpot.api.eval)]
                  (pecho (eval-buffer 0)))
               {:desc "Evaluate entire buffer"})

(vim.keymap.set :v :hes
                #(let [{: eval-selection} (require :hotpot.api.eval)]
                  (pecho (eval-selection)))
               {:desc "Evaluate selection"})

(vim.keymap.set :n :hcb
                #(let [{: compile-buffer} (require :hotpot.api.compile)]
                  (pecho (compile-buffer 0)))
               {:desc "Compile entire buffer"})

(vim.keymap.set :v :hcs
                #(let [{: compile-selection} (require :hotpot.api.compile)]
                  (pecho (compile-selection)))
               {:desc "Compile selection"})


(vim.keymap.set :n :dz #(print "hello world!")
                {:desc "debug string"})


(require :mappings)
(require :plugins)
