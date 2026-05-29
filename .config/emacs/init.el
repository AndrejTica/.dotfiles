;;; init.el --- Personal Emacs configuration -*- lexical-binding: t; -*-


(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
;;; ============================================================
;;; PACKAGE ARCHIVES
;;; ============================================================
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("elpa"  . "https://elpa.gnu.org/packages/")))

;; Without this, use-package silently skips missing packages on a
;; fresh machine, which makes new installs confusingly broken.
(setq use-package-always-ensure t)

(require 'myevil)

(require 'options)

(require 'treesitter)

(require 'project)

(require 'mypackages)

(require 'db)

(require 'mydired)

(require 'myorg)

(require 'robot)

;; project.el only knows about projects you've previously visited.
;; This walks ~/Workspace once at startup and registers each git repo
;; so <leader>pp lists them without needing to visit a file first.
(when (file-directory-p "~/Workspace")
  (project-remember-projects-under "~/Workspace"))

(setq project-mode-line t)         ; Emacs 30+ — show project name in mode line





;;; init.el ends here
