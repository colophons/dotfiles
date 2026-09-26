
(in-package :lem-user)
; do we have a repl?
; (rosin/focus-internal-repl)
; (lem/prompt-window:current-prompt-window)

;;;; tree sitter stuff 2 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; garlic's excellent TS library

;;;;; tree sitter stuff: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; use this library: https://github.com/death/cl-tree-sitter
; sudo pacman -S tree-sitter-cli
; and clone this to ~/treesitters: https://github.com/tree-sitter/tree-sitter-c-sharp
; build tree sitters in ~/treesitters
; copy .so file to /usr/lib
; then we can import it like so:
; (cl-tree-sitter:register-language :csharp "tree-sitter-c-sharp")
; but this doesn't work
; (cl-tree-sitter:parse-string :csharp "public static int main() { return 0; }")
; the alien function "c_sharp" is undefined
; back to square one

;; Putting "space" in the global keymap unfortunately makes everything quite slow
;(define-keys *global-keymap*
;  ("Space x" 'execute-command)) 


; image buffer stuff
; (pop-to-buffer (lem-sdl2/image-buffer::open-image-buffer "/home/rosin/toopowerful.png"))
; (pop-to-buffer (lem-sdl2/image-buffer::open-image-buffer "/home/rosin/vlcsnap-2022-03-19-12h48m30s651.png"))
;(pop-to-buffer (lem-sdl2/image-buffer::open-image-buffer "/home/rosin/repairer.png"))

; (lem-sdl2/drawing:
; (lem-sdl2/image-buffer::open-image-buffer "/home/rosin/repairer.png") 
; (format nil "~a" (cmd:$sh "ls -1 /home/rosin/*.png"))



; figure out how to see, on the status line, the last command that fired


;  just like the M-x prefix
;  I think it does something like "command mode"

; (lem-vi-mode/registers:paste-yank)
; (lem-vi-mode/commands:vi-paste-after)

; Oh HELL yes

; How can I pop open a prompt?
; Types of popups:

; helpful: 
; https://github.com/garlic0x1/.lem/blob/master/src/places.lisp

; This gives us a "drop-down from top" kind of window
; which you "type out" of
; (with-pop-up-typeout-window (out (make-buffer "*foo*") :erase t :read-only t)
;   (write-string "foo" out))

; This one gives us a prompt asking for a string, and immediately yields it to the caller
; (princ (prompt-for-string "Foo: "))


; There are a whole bunch of these -- the `prompt-for-*` family
; and fuzzy finding?
; (lem-core::fuzzy-match-p  "sla" "night slave") ; => T
; it would be nice if I had a function that showed me the package
; that a particular command is from
; that's apropos
; apropos-command
; lisp-apropos

; so I can call this, and cache ?
;(buffer-filename)
; (defvar *harpooned* '() "A list of harpooned files")
; 
; (define-command rosin/harpoon-current-file () ()
;   (let ((harpooned (config :harpooned nil))
;         (current (buffer-filename)))
;     (format t "Adding ~a to ~a" current harpooned)
;     (setf (config :harpooned) (adjoin current harpooned :test #'string-equal))))
; 
; (define-command rosin/go-to-harpooned () ()
;   (let ((harpooned (config :harpooned nil)))
;     ; todo :^)
;     ))

; how do I get the current file?


