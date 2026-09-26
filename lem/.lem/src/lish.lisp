(in-package :lem-user)

(defparameter *lish-port* 11111)

(define-command rosin/lish () ()
  "attempts to spawn a terminal, launch lish, and connect to it via micros 
   TODO:
     - [ ] spawn a terminal
     - [ ] launch LISH
     - [x] connect via micros"
  (lem-lisp-mode:slime-connect "127.0.0.1" 11111))