(org-babel-do-load-languages
 'org-babel-load-languages
 '((calc . t)
   (lisp . t)
   (shell . t)
;   (jq . t)
;   (verb . t)
   (lua . t)
   (forth . t)))

(setq org-babel-lisp-eval-fn #'sly-eval)
; https://orgmode.org/manual/Results-of-Evaluation.html
(setq org-babel-default-header-args '((:results . "output drawer replace")))

(defun rosin/org-gtd-refile-target-p ()
    (let ((level (org-current-level)))
      (or (and (= level 1)
               (not (member (org-get-heading t t t t)
                            '("COMMENT"))))
          (and (= level 2)
               (save-excursion
                 (org-up-heading-safe)
                 (member (org-get-heading t t t t)
                         '("Reading" "Projects")))))))

