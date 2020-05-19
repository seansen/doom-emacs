;;;;(global-set-key (kbd "C-x p i") 'org-cliplink)

(global-undo-tree-mode)

(setq user-full-name "Sean Avery"
      user-mail-address "seanavery@gmx.net")

(setq doom-font (font-spec :family "JetBrains Mono" :size 14))
(setq doom-theme 'doom-gruvbox)
;;(setq fancy-splash-image "~/image.png")

(setq org-support-shift-select t)
(setq display-line-numbers-type 'relative)
(setq evil-move-cursor-back nil)                 ; Escape
(setq evil-escape-key-sequence "jk"              ; Escape
      evil-escape-delay 0.3)                     ; Escape
(custom-set-faces! '(doom-modeline-evil-insert-state :weight bold :foreground "#339CDB"))

(setq-default
 delete-by-moving-to-trash t                      ; Delete files to trash
 tab-width 4                                      ; Set width for tabs
 uniquify-buffer-name-style 'forward              ; Uniquify buffer names
 window-combination-resize t                      ; take new window space from all other windows (not just current)
 x-stretch-cursor t)                              ; Stretch cursor to the glyph width

(setq undo-limit 80000000                         ; Raise undo-limit to 80Mb
      evil-want-fine-undo t                       ; By default while in insert all changes are one big blob. Be more granular
      auto-save-default t                         ; Nobody likes to loose work, I certainly don't
      inhibit-compacting-font-caches t)           ; When there are lots of glyphs, keep them in memory

(delete-selection-mode 1)                         ; Replace selection when inserting text
(display-time-mode 1)                             ; Enable time in the mode-line
(display-battery-mode 1)                          ; On laptops it's nice to know how much power you have
(global-subword-mode 1)                           ; Iterate through CamelCase words

(setq-default major-mode 'org-mode)

;;(if (eq initial-window-system 'x)                 ; if started by emacs command or desktop file
;;    (toggle-frame-maximized)
;;  (toggle-frame-fullscreen))

(setq evil-vsplit-window-right t
      evil-split-window-below t)

(defadvice! prompt-for-buffer (&rest _)
  :after '(evil-window-split evil-window-vsplit)
  (+ivy/switch-buffer))

(setq +ivy-buffer-preview t)

(move-text-default-bindings)

(use-package deft
:after org
:bind
("C-c n d" . deft)
:custom
(deft-recursive t)
(deft-use-filter-string-for-filename t)
(deft-default-extension "org")
(deft-extensions '("txt" "tex" "org"))
(deft-directory "~/Dropbox/zettelkasten"))

(setq org-directory "~/org/")

(use-package org-roam-protocol)

(defun ha/org-return (&optional ignore)
  "Add new list item, heading or table row with RET.
A double return on an empty element deletes it.
Use a prefix arg to get regular RET. "
  (interactive "P")
  (if ignore
      (org-return)
    (cond
     ;; Open links like usual
     ((eq 'link (car (org-element-context)))
      (org-return))
     ;; lists end with two blank lines, so we need to make sure we are also not
     ;; at the beginning of a line to avoid a loop where a new entry gets
     ;; created with only one blank line.
     ((and (org-in-item-p) (not (bolp)))
      (if (org-element-property :contents-begin (org-element-context))
          (org-insert-heading)
        (beginning-of-line)
        (setf (buffer-substring
               (line-beginning-position) (line-end-position)) "")
        (org-return)))
     ((org-at-heading-p)
      (if (not (string= "" (org-element-property :title (org-element-context))))
          (progn (org-end-of-meta-data)
                 (org-insert-heading))
        (beginning-of-line)
        (setf (buffer-substring
               (line-beginning-position) (line-end-position)) "")))
     ((org-at-table-p)
      (if (-any?
           (lambda (x) (not (string= "" x)))
           (nth
            (- (org-table-current-dline) 1)
            (org-table-to-lisp)))
          (org-return)
        ;; empty row
        (beginning-of-line)
        (setf (buffer-substring
               (line-beginning-position) (line-end-position)) "")
        (org-return)))
     (t
      (org-return)))))

(define-key org-mode-map (kbd "RET")  #'ha/org-return)

(setq org-roam-directory "~/Dropbox/zettelkasten/")
(setq org-roam-buffer-position 'right)
(setq org-roam-buffer-width 0.4)
(setq org-roam-index-file "index.org")
(setq org-roam-completion-system 'ivy)(after! org-roam
(map! :leader
:prefix "n"
:desc "org-roam" "l" #'org-roam
:desc "org-roam-insert" "i" #'org-roam-insert
:desc "org-roam-switch-to-buffer" "b" #'org-roam-switch-to-buffer
:desc "org-roam-find-file" "f" #'org-roam-find-file
:desc "org-roam-show-graph" "g" #'org-roam-show-graph
:desc "org-roam-insert" "i" #'org-roam-insert
:desc "org-roam-capture" "c" #'org-roam-capture
:desc "org-roam-find-directory" "d" #'org-roam-find-directory
:desc "org-roam-company" "k" #'company-org-roam
:desc "org-roam-find-ref" "x" #'org-roam-find-ref
:desc "org-roam-graph" "y" #'org-roam-graph
:desc "org-roam-jump-to-index" "j" #'org-roam-jump-to-index
))

(require 'company-org-roam)
(use-package company-org-roam
:when (featurep! :completion company)
:after org-roam
:config
(set-company-backend! 'org-mode '(company-org-roam company-yasnippet company-dabbrev)))

(use-package! org-roam-server)

;;(use-package! company-org-roam
;;  :config
;;  (push 'company-org-roam company-backends))

(defun zp/org-find-time-file-property (property &optional anywhere)
    "Return the position of the time file PROPERTY if it exists.
When ANYWHERE is non-nil, search beyond the preamble."
    (save-excursion
      (goto-char (point-min))
      (let ((first-heading
             (save-excursion
               (re-search-forward org-outline-regexp-bol nil t))))
        (when (re-search-forward (format "^#\\+%s:" property)
                                 (if anywhere nil first-heading)
                                 t)
          (point)))))

  (defun zp/org-has-time-file-property-p (property &optional anywhere)
    "Return the position of time file PROPERTY if it is defined.
As a special case, return -1 if the time file PROPERTY exists but
is not defined."
    (when-let ((pos (zp/org-find-time-file-property property anywhere)))
      (save-excursion
        (goto-char pos)
        (if (and (looking-at-p " ")
                 (progn (forward-char)
                        (org-at-timestamp-p 'lax)))
            pos
          -1))))

  (defun zp/org-set-time-file-property (property &optional anywhere pos)
    "Set the time file PROPERTY in the preamble.
When ANYWHERE is non-nil, search beyond the preamble.
If the position of the file PROPERTY has already been computed,
it can be passed in POS."
    (when-let ((pos (or pos
                        (zp/org-find-time-file-property property))))
      (save-excursion
        (goto-char pos)
        (if (looking-at-p " ")
            (forward-char)
          (insert " "))
        (delete-region (point) (line-end-position))
        (let* ((now (format-time-string "[%Y-%m-%d %a %H:%M]")))
          (insert now)))))

  (defun zp/org-set-last-modified ()
    "Update the LAST_MODIFIED file property in the preamble."
    (when (derived-mode-p 'org-mode)
      (zp/org-set-time-file-property "LAST_MODIFIED")))

(setq org-roam-capture-templates
'(
  ("d" "default" plain (function org-roam--capture-get-point)
   "%?"
    :file-name "%(format-time-string \"%Y%m%d%H%M%S-${slug}\" (current-time) t)"
    :head "#+TITLE: ${title}\n#+Author: Sean Averhoff\n#+CREATED: %U\n#+LAST_MODIFIED: %U\n- tags :: \n----------\n"
        :unnarrowed t)

  ("n" "note" plain (function org-roam--capture-get-point)
  "%?"
    :file-name  "%(format-time-string \"%Y%m%d%H%M%S-${slug}\" (current-time) t)"
    :head "#+TITLE: ${title}\n#+Author: Sean Averhoff\n#+CREATED: %U\n#+LAST_MODIFIED: %U\n- tags :: \n----------\n"
    :unnarrowed t)

  ("p" "private" plain (function org-roam--capture-get-point)
  "%?"
    :file-name "private-${slug}"
    :head "#+TITLE: ${title}\n#+Author: ${author-or-editor}"
    :unnarrowed t)))

(setq +mu4e-backend 'offlineimap)
