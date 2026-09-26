(defvar marx-backward-marks nil)
(defvar marx-forward-marks nil)

;; set-mark destructively changes mark location (does not save previous location)
;; push-mark stores mark location in the mark-stack and then changes it ("saves" previous location)
;; "if the last global mark pushed was not in the current buffer, also push LOCATION on the global mark ring
;; so, location (point, by default) is the next mark
(defun marx-record-jump-maybe (&optional location nomsg activate)
  (add-to-list 'marx-backward-marks (copy-marker (or location (point)))))

(defun marx-jmp (mrk)
  ;; jumps to a mark's position
  ;; detects if mark is in another buffer, and switches to it if so.
  (let ((mrk-buf (marker-buffer mrk))
        (mrk-pos (marker-position mrk)))
    (cond ((eq (current-buffer) mrk-buf) ; mark is in current buffer
           (message "marx: %S" mrk)
           (goto-char mrk))
          ((buffer-live-p mrk-buf)
           (marx-switch-to-buffer mrk-buf)
           ;; (pop-to-buffer mrk-buf)
           ;; (goto-char mrk) comment this out for now,
           ;; because I am happy to rely on emacs' "last position in buffer" machinery
           )
          (t (message "refusing to jump to killed buffer: %S" mrk)))))

(defun marx-switch-to-buffer (buffer)
  (if-let ((window (get-buffer-window buffer nil)))
      (select-window window)
    (switch-to-buffer buffer)))

(defun marx-skip-if-current (direction)
  (cond ((and (eq direction :forward)
             (marx-mark-at-current-point (car marx-forward-marks)))
         (push (pop marx-forward-marks) marx-backward-marks))
        ((and (eq direction :backward)
              (marx-mark-at-current-point (car marx-backward-marks)))
         (push (pop marx-backward-marks) marx-forward-marks))))


(defun marx-mark-at-current-point (mrk)
  (and (eq (current-buffer) (marker-buffer mrk))
       (eq (point) (marker-position mrk))))

(defun marx-jump-backward ()
  (interactive)
  ;; pops marker off the head of marx-jump-backward and pushes it to the head of marx-jump-forward
  ;; Zips point to the popped marker.
  ;; If nothing is in marx-jump-backward, do nothing
  ;; If the current point is at the next backward mark, skip and do the next one
  (when marx-backward-marks
    (marx-skip-if-current :backward)
    (let ((mrk (pop marx-backward-marks))
          (here (copy-marker (point))))
      (push here marx-forward-marks)
      (marx-jmp mrk))))

(defun marx-jump-forward ()
  (interactive)
  (when marx-forward-marks
    (marx-skip-if-current :forward)
    (let ((mrk (pop marx-forward-marks))
          (here (copy-marker (point))))
      (push here marx-backward-marks)
      (marx-jmp mrk))))

(advice-add 'push-mark :before #'marx-record-jump-maybe)
(advice-add 'other-window :before #'marx-record-jump-maybe)
(advice-add 'previous-buffer :before #'marx-record-jump-maybe)
(advice-add 'next-buffer :before #'marx-record-jump-maybe)
(advice-add 'org-open-at-point :before #'marx-record-jump-maybe)
(advice-add 'dired-find-file :before #'marx-record-jump-maybe)
(advice-add 'rosin-tko-visit-ticket :before #'marx-record-jump-maybe)
;; (advice-add 'rosin-tko-add-note :before #'marx-record-jump-maybe)
;; We could also consider the case of pushing a mark only when we've completed
;; a minibuffer command that takes us to another place, e.g. find-file
;; This is what's going to require the "marx-currently-recording-jump" functionality.
;; and some way of identifying the current invocation.

                                        ;; (advice-add 'find-file :before #'marx-record-jump-maybe)
;;  this-command
;;  real-this-command
;;  last-command
;;  major-mode
;;  buffer-file-name
;;  mark-active
;;  use-region-p
;;
;;  Initial filter rules could be simple:
;;
;;  ignore if minibuffer
;;  ignore if no buffer file and not an org/notes buffer
;;  ignore if region is active
;;  ignore repeated same line in same buffer
;;  ignore tiny moves within N chars/lines
;;  record xref/consult/org-roam/project jumps
;;  maybe record isearch exits later
;;
