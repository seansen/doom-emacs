;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; Command-Log
(package! command-log-mode
  :recipe (:host github :repo "lewang/command-log-mode"))
(package! move-text
  :recipe (:host github :repo "emacsfodder/move-text"))
(package! undo-tree
  :recipe (:host github :repo "apchamberlain/undo-tree.el"))
(package! helm-bibitex
  :recipe (:host github :repo "tmalsburg/helm-bibtex"))
(package! selectric-mode :pin "bb9e66678f")
(package! org-super-agenda :pin "dd0d104c26")
(package! doct
  :recipe (:host github :repo "progfolio/doct")
  :pin "1bcec209e1")
(package! undo-tree
:recipe (:host github :repo "apchamberlain/undo-tree.el"))
(package! simple-httpd
  :recipe (:host github :repo "skeeto/emacs-web-server"))

;; Org
(package! org-roam-server 
  :recipe (:host github :repo "org-roam/org-roam-server" :files ("*")))
(package! org-roam-bibtex
  :recipe (:host github :repo "org-roam/org-roam-bibtex"))
(package! org-graph-view 
  :recipe (:host github :repo "alphapapa/org-graph-view") :pin "13314338d7")
(package! org-chef 
  :pin "1dd73fd3db")
(package! org-ref-ox-hugo
  :recipe (:host github :repo "jethrokuan/org-ref-ox-hugo" :branch "custom/overrides"))
(package! org-pretty-table-mode
  :recipe (:host github :repo "Fuco1/org-pretty-table") :pin "88380f865a")
(package! org-cliplink
  :recipe (:host github :repo "rexim/org-cliplink"))
(package! org-index
  :recipe (:host github :repo "marcIhm/org-index"))
(package! org-roam-bibtex
 :recipe (:host github :repo "org-roam/org-roam-bibtex"))
(package! org-ref-ox-hugo
  :recipe (:host github :repo "jethrokuan/org-ref-ox-hugo" :branch "custom/overrides"))
(package!  company-org-roam
  :recipe (:host github :repo "org-roam/company-org-roam"))
(package!  org-sidebar
  :recipe (:host github :repo "alphapapa/org-sidebar"))



;;(package! org-fancy-priorities)
;;(package! indium)
;;(package! prettier-js)
;;(package! org2clip)
;;(package! xclip)
;;(package! dash)
;;(package! evil-org)
;;(package! org-ref)
;;(package! biblio)
;;(package! ob-translate)
;;(package! origami)
;;(package! org-super-agenda)
;;(package! deadgrep)
;;(package! dart-mode)
;;(package! ob-dart)
;;(package! kotlin-mode)
;;(package! sql-indent)
;;(package! org-brain)
;;(package! ascii-art-to-unicode)
;;(package! wakatime-mode)
