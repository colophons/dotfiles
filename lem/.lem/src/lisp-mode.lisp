(in-package :lem-user)

;(add-hook lem-lisp-mode:*lisp-mode-hook*
;          (lambda (buffer)
;            (pare
;(add-hook lem-lisp-mode:*lisp-mode-hook*

; (add-hook lem:*find-file-hook*
;           (lambda (buffer)
;             (message (format nil "it's ~a" (buffer-major-mode buffer)))
;             (when (eq (buffer-major-mode buffer) 'lisp-mode)
;               (lem-paredit-mode:paredit-mode))))


(add-hook lem-lisp-mode:*lisp-mode-hook*
          (lambda ()
            (setf  (variable-value 'lem-lisp-mode:paren-coloring :global) t)
            (change-buffer-mode (current-buffer) 'lem-paredit-mode:paredit-mode t)))

