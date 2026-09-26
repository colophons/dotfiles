(defpackage #:lem-my-init
    (:use #:cl #:lem))
(in-package :lem-my-init)
;; Dumped image contains the cached source registry
;; Ensure to reinitialize it to let ASDF find new systems.
(asdf:clear-source-registry)
; but if I do this, then `load-library` doesn't seem to work anymore -- 
;   contrib system is not loaded
 
; ;; Load my init files.
(let ((asdf:*central-registry*
        (append (list (asdf:system-source-directory :lem)
                      #P"~/.lem/" 
                      #P"~/common-lisp/")
                asdf:*central-registry*)))
  (ql:quickload :lem-site-init))