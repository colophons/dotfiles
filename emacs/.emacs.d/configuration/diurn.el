;;; diurn.el --- Helpers for the diurn journal -*- lexical-binding: t; -*-

(require 'org)

(defvar rosin/diurn-directory
  (expand-file-name "~/diurn")
  "Root directory for the diurn repository.")

(defvar rosin/diurn-journal-file
  (expand-file-name "journal.org" rosin/diurn-directory)
  "Path to the diurn journal file.")

(defvar rosin/diurn-daily-entry-template
  "%s\n*** Time\n\n*** Training\n\n*** Frogs\n\n"
  "Raw Org template for a new daily journal entry.
The %s is replaced with today's rendered journal heading.")

(defun rosin/diurn--ordinal-suffix (day)
  "Return the English ordinal suffix for DAY."
  (let ((mod100 (% day 100)))
    (if (and (>= mod100 11) (<= mod100 13))
        "th"
      (pcase (% day 10)
        (1 "st")
        (2 "nd")
        (3 "rd")
        (_ "th")))))

(defun rosin/diurn--todays-journal-prefix ()
  "Return today's stable journal heading prefix."
  (format-time-string "** %Y.%m.%d ::"))

(defun rosin/diurn--todays-journal-heading ()
  "Return today's custom journal heading."
  (let ((day (string-to-number (format-time-string "%d"))))
    (format "%s %s, %s %d%s"
            (rosin/diurn--todays-journal-prefix)
            (format-time-string "%A")
            (format-time-string "%B")
            day
            (rosin/diurn--ordinal-suffix day))))

(defun rosin/diurn--goto-days-heading ()
  "Move point to the top-level `* days' heading.
Return non-nil when the heading exists."
  (goto-char (point-min))
  (let ((case-fold-search t))
    (when (re-search-forward "^\\* days[ \t]*$" nil t)
      (beginning-of-line)
      t)))

(defun rosin/diurn--goto-or-create-todays-journal-entry ()
  "Go to today's custom journal heading, creating it if needed."
  (find-file rosin/diurn-journal-file)
  (widen)
  (goto-char (point-min))
  (let ((today-prefix (rosin/diurn--todays-journal-prefix)))
    (if (re-search-forward
         (concat "^" (regexp-quote today-prefix))
         nil t)
        (beginning-of-line)
      (unless (rosin/diurn--goto-days-heading)
        (user-error "Could not find top-level * days heading"))
      (forward-line 1)
      (let ((entry-start (point)))
        (insert (format rosin/diurn-daily-entry-template
                        (rosin/diurn--todays-journal-heading)))
        (goto-char entry-start)))))

(defun rosin/diurn-goto-todays-journal-entry (&optional end-of-subtree)
  "Go to today's custom journal heading in `rosin/diurn-journal-file'.
With prefix argument END-OF-SUBTREE, move to the end of today's subtree."
  (interactive "P")
  (rosin/diurn--goto-or-create-todays-journal-entry)
  (when end-of-subtree
    (org-end-of-subtree t)
    (unless (bolp)
      (insert "\n"))))

(defun rosin/diurn-open-todays-journal-entry (&optional end-of-subtree)
  "Open today's journal entry, creating it if needed, then narrow to it.
With prefix argument END-OF-SUBTREE, move point to the end of the narrowed
daily entry."
  (interactive "P")
  (rosin/diurn-goto-todays-journal-entry)
  (org-narrow-to-subtree)
  (show-all)
  (when end-of-subtree
    (goto-char (point-max))
    (unless (bolp)
      (insert "\n"))))

(provide 'rosin-diurn)
(provide 'diurn)
