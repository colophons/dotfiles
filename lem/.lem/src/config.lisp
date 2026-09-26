(in-package lem-terminal/terminal-mode)
(push 'window-move-up *bypass-commands*)
(push 'window-move-down *bypass-commands*)
(push 'window-move-left *bypass-commands*)
(push 'window-move-right *bypass-commands*)
(in-package :lem-user)


; ; Start in vi-mode
(lem-vi-mode:vi-mode)

(load-theme "isotope")

; (ql:quickload "lem/legit")


; How do I rebind an editor variable?

(defun current-major-mode ()
  (lem:mode-name (lem:buffer-major-mode (lem:current-buffer))))

(defun major-mode-is-p (mode-name)
  (string-equal (current-major-mode) mode-name))

(define-command rosin/vinegar () ()
  "Changes to directory mode in the current directory, or goes up a dir"
  (if (major-mode-is-p "Directory")
      (lem/directory-mode::directory-mode-up-directory)
      (find-file (current-directory))))

; some meta commands
(define-command rosin/open-init () ()
  (find-file "~/.lem/init.lisp"))

; doesn't work right now
(define-command rosin/open-lem-source () ()
  (find-file (ql:where-is-system :lem)))

; This doesn't do what I think it does
(define-command rosin/focus-internal-repl () ()
  (let ((buffer (lem-lisp-mode::repl-buffer)))
    (if buffer
        (lem-lisp-mode::lisp-switch-to-repl-buffer)
        (progn (lem-core:call-command 'lem-lisp-mode/internal:start-lisp-repl nil)
               (lem-core:call-command 'lem-lisp-mode/internal:slime-self-connect nil)))))

; hook settin:

(add-hook *prompt-after-activate-hook*
          (lambda ()
            ; (setf lem/completion-mode::*completion-reverse* t)
            (call-command 'lem/prompt-window::prompt-completion nil)))

(add-hook *prompt-deactivate-hook*
          (lambda ()
            ; (setf lem/completion-mode::*completion-reverse* nil)
            (lem/completion-mode:completion-end)))


(setf lem-core::*default-prompt-gravity* :bottom-display)
(setf lem/prompt-window::*prompt-completion-window-gravity* :horizontally-above-window)
(setf lem/prompt-window::*fill-width* t); how do we make it so that our micros repl uses roswell's quicklisp dist?


; try forcing the central registry
; this isn't necessary because of what we do in `~/.lem/init.lisp`
; (trace asdf:load-system)
; (let ((asdf:*central-registry* (cons (uiop:parse-native-namestring 
;                                       "/home/rosin/projects/lem/"
;                                       :ensure-directory t) asdf:*central-registry*)))
;   (load-library "tetris"))

; 
; (load-library "tetris")
; (load-library "treesitter-mode")
; (let ((asdf:*central-registry* (cons (uiop:parse-native-namestring 
;                                       "~/projects/lem/"
;                                       :ensure-directory t) asdf:*central-registry*)))
;   (load-library "treesitter-mode"))
