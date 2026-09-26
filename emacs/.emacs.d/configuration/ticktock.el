(require 'org)

(defvar *ARVELIE-YEAR-START* 2026)

(defun ticktock--arvelie-date (&optional date)
  "Calculates arvelie date, extended by the day-of-week (0: sunday). Defaults to today."
  (let* ((months (list ?A ?B ?C ?D ?E ?F ?G ?H ?I
  		     ?J ?K ?L ?M ?N ?O ?P ?Q ?R
  		     ?S ?T ?U ?V ?W ?X ?Z ?Z ?+))
         (dt (or (and date (date-to-time date)) (current-time)))
         (decoded (decode-time dt))
         (d-o-y (1- (time-date--day-in-year decoded)))
         (year (decoded-time-year decoded))
         (arv-year (- year *ARVELIE-YEAR-START*))
         (arv-month (nth (/ d-o-y 14) months))
         (arv-d-o-m (% d-o-y 14))
         (weekday (decoded-time-weekday decoded)))
    (format "%02d%c%02d.%d" arv-year arv-month arv-d-o-m weekday)))

(defun ticktock--insert-time-table ()
  "Insert a time tracking table at point."
  (insert "| start | end | topic | note | date |\n")
  (insert "|-|\n")
  (org-table-align))

(defun ticktock--goto-time-section-today ()
  "Go to today's Time table.
Return nil and emit a message when today's journal entry has no Time subtree.
Create the table when the Time subtree exists but has no table."
  (rosin/diurn-goto-todays-journal-entry)
  (let ((day-end (save-excursion
                   (org-end-of-subtree t)
                   (point))))
    (if (re-search-forward "^\\*\\*\\* Time[ \t]*$" day-end t)
        (let* ((time-heading-end (line-end-position))
               (time-end (save-excursion
                           (org-end-of-subtree t)
                           (point)))
               (table-point
                (save-excursion
                  (forward-line 1)
                  (catch 'table
                    (while (< (point) time-end)
                      (when (org-at-table-p)
                        (throw 'table (point)))
                      (forward-line 1))
                    nil))))
          (if table-point
              (progn
                (goto-char table-point)
                (goto-char (1- (org-table-end))))
            (goto-char time-heading-end)
            (insert "\n")
            (ticktock--insert-time-table)
            (goto-char (1- (org-table-end)))))
      (message "ticktock: today's journal entry has no *** Time subtree")
      nil)))

(defun ticktock--insert-time-today (start end topic note)
  "Inserts a time entry to today's time table. Expects the following:
   - start   : formatted time start
   - end     : formated time end
   - topic   : topic for the time section
   - note    : optional note

If it cannot locate today's \"*** Time\" subtree, it emits a message and skips
the insert. If the subtree exists but has no table, it creates the table."
  (when (ticktock--goto-time-section-today)
    (org-table-insert-row 'end)
    (insert start) (org-table-next-field)
    (insert end) (org-table-next-field)
    (insert topic) (org-table-next-field)
    (insert note) (org-table-next-field)
    (insert (ticktock--arvelie-date))
    (org-table-align)))

            ; (format-time-string "%H:%M" (seconds-to-time start-time))
;; This will be reached from two places:
;; pomm-third-time-start
;; pomm-third-time-switch
;; pomm-third-time-start

;; I believe the status when we enter this hook will reflect the state we are transitioning to
;;   in other words, when we enter the hook changing from running -> stopped,
;;   the status will be "stopped"

   ;;- context : a string describing the topic of the time.
   ;;          :  May include an optional note section delineated by the sequence \"::\"
   ;;          :  (for example, \"emacs :: working on insert-time-today\")
(defvar ticktock--current-start (current-time))
(defun ticktock--toggle ()
  ;; this needs to get the last iteration's start time if we go to break.

  (pcase-let* ((status (alist-get 'status pomm-third-time--state))
         (kind (alist-get 'kind (alist-get 'current pomm-third-time--state)))
	 (ctx (alist-get 'context pomm-third-time--state))
	 (`(,topic ,note) (string-split ctx "::" t "[ ]+"))
         (active-p (and (eq kind 'work)
                        (eq status 'running)))
	(start-time-fmt (format-time-string "%H:%M" ticktock--current-start))
	(end-time-fmt (format-time-string "%H:%M" (current-time))))

    ;(ticktock--insert-time-today start-time end-time topic-note)
    (if (not active-p)
	(progn
	  (message "[debug] :: inserting time %s->%s %s %s" status kind start-time-fmt end-time-fmt topic note)
	  (ticktock--insert-time-today start-time-fmt end-time-fmt topic note))
      (progn
	(setf ticktock--current-start (current-time))
	(message "[debug] :: update current-start")))))

(add-hook 'pomm-third-time-on-status-changed-hook #'ticktock--toggle)
