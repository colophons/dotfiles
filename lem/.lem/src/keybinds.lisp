(in-package :lem-user)

(setf (variable-value 'lem-vi-mode:leader-key :global) "Space")

(define-key lem-vi-mode:*normal-keymap* "Leader f b" 'lem/list-buffers:list-buffers)
(define-key lem-vi-mode:*normal-keymap* "Leader p f" 'lem-core/commands/project:project-find-file)
(define-key lem-vi-mode:*normal-keymap* "Leader f f" 'find-file-recursively)
(define-key lem-vi-mode:*normal-keymap* "Leader f Space" 'lem/grep::grep)
(define-key lem-vi-mode:*normal-keymap* "Leader e x" 'lem-lisp-mode/eval::lisp-eval-last-expression-and-insert)
(define-keys lem-vi-mode:*visual-keymap*
  ("<" 'lem-core/commands/edit:delete-indentation))
(define-keys lem-vi-mode:*normal-keymap*
  ("-" 'rosin/vinegar)
  ; just vim window stuff
  ("C-w v" 'split-active-window-horizontally)
  ("C-w s" 'split-active-window-vertically)
  ; meta
  ("Leader m i" 'rosin/open-init)
  ("Leader m l" 'rosin/open-lem-source)
  ("Leader m r" 'rosin/focus-internal-repl)
  ("Leader l f" 'format-current-buffer)
  ("g d" 'lem/language-mode:find-definitions)
  ("g r" 'lem/language-mode:find-references)
  ("g t" 'lem/frame-multiplexer:frame-multiplexer-next)
  ("g T" 'lem/frame-multiplexer:frame-multiplexer-prev)
  ("Leader a n" 'lem/frame-multiplexer:frame-multiplexer-create-with-new-buffer-list))

(define-key *global-keymap* "C-h k" 'describe-key)
(define-key *global-keymap* "C-h b" 'describe-bindings)

;; I wish I had something like the telescope keybindings thing from neovim

; (define-key *language-mode-keymap* "C-M-a" 'beginning-of-defun)
; (define-key *language-mode-keymap* "C-M-e" 'end-of-defun)
; (define-key *language-mode-keymap* "Tab" 'indent-line-and-complete-symbol)
; (define-key *global-keymap* "C-j" 'newline-and-indent)
; (define-key *global-keymap* "M-j" 'newline-and-indent)
; (define-key *language-mode-keymap* "C-M-\\" 'indent-region)
; (define-key *language-mode-keymap* "M-;" 'comment-or-uncomment-region)
; (define-key *language-mode-keymap* "M-." 'find-definitions)
; (define-key *language-mode-keymap* "M-_" 'find-references)
; (define-key *language-mode-keymap* "M-?" 'find-references)

; (define-key *language-mode-keymap* "M-," 'pop-definition-stack)
; (define-key *language-mode-keymap* "C-M-i" 'complete-symbol)
; (define-key *global-keymap* "M-(" 'insert-\(\))
; (define-key *global-keymap* "M-)" 'move-over-\))
