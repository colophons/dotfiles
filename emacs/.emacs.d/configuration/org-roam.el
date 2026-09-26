;;; org-roam.el --- Slipbox notes only -*- lexical-binding: t; -*-

(require 'org)
(require 'org-id)

(setq org-id-method 'ts)
(setq org-id-ts-format "%Y%m%dT%H%M%S")

(use-package org-roam
  :custom
  (org-roam-directory (file-truename "~/diurn/notes"))
  (org-roam-db-location (expand-file-name "org-roam.db" user-emacs-directory))
  (org-roam-node-display-template
   (concat "${title:*} " (propertize "${tags:20}" 'face 'org-tag)))
  :bind
  (("C-c n f" . org-roam-node-find)
   ("C-c n i" . org-roam-node-insert)
   ("C-c n c" . org-roam-capture)
   ("C-c n b" . org-roam-buffer-toggle)
   ("C-c n r" . org-roam-db-sync))
  :config
  (make-directory org-roam-directory t)
  (org-roam-db-autosync-mode)

  (setq org-roam-capture-templates
        '(("s" "slip note" plain "%?"
           :target
           (file+head "${slug}.org"
                      "#+title: ${title}
#+created: %U
#+filetags: %^{Tags}

")
           :unnarrowed t))))

(provide 'rosin-org-roam)

