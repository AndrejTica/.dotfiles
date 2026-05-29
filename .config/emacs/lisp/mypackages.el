
;;; ============================================================
;;; UNDO SYSTEM
;;; ============================================================
;; Linear vim-style undo for evil (alternative to Emacs's undo tree).
(use-package undo-fu)

;;; ============================================================
;;; GIT GUTTER — show uncommitted changes in the fringe
;;; ============================================================
(use-package git-gutter
  :ensure t
  :config
  (global-git-gutter-mode +1))


(use-package vterm
  :ensure t)

;;; ============================================================
;;; VTERM — leader binding always creates a new instance
;;; ============================================================
(defun my/vterm-new ()
  "Open a new vterm buffer (never reuse an existing one)."
  (interactive)
  (vterm t))

;;; ============================================================
;;; COMPLETION — corfu (popup) + cape (sources)
;;; ============================================================
;; corfu: the popup UI. cape: the completion sources that populate it.
;; TAB is left alone — completion auto-triggers as you type; use
;; C-n / C-p inside the popup to navigate and RET to accept.
(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.1)
  (corfu-auto-prefix 1)          ; trigger after 1 char (catches "/")
  (corfu-cycle t)
  (corfu-preselect 'first)
  :init
  (global-corfu-mode))

(use-package cape
  :ensure t
  :init
  ;; Order matters — earlier sources are checked first.
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  )

;; :height is in 1/10 pt — 130 = 13pt.
(set-face-attribute 'default nil
                    :family "JetBrains Mono"
                    :height 130)

(set-face-attribute 'variable-pitch nil
                    :family "Iosevka Aile"
                    :height 130)

;; First run: M-x nerd-icons-install-fonts to install the font files.
(use-package nerd-icons :ensure t)

(use-package nerd-icons-dired
  :ensure t
  :hook (dired-mode . nerd-icons-dired-mode))


;;; ============================================================
;;; INDENT BARS — visible indentation guides for indent-sensitive langs
;;; ============================================================
(use-package indent-bars
  :ensure t
  :hook ((python-mode python-ts-mode yaml-mode yaml-ts-mode) . indent-bars-mode)
  :config
  (setq indent-bars-color '(highlight :face-bg t :blend 0.2)
        indent-bars-pattern "."
        indent-bars-width-frac 0.1))

(use-package org-modern
  :ensure t)
(with-eval-after-load 'org (global-org-modern-mode))


;;; ============================================================
;;; EGLOT — LSP client (built into Emacs 29+)
;;; ============================================================
(use-package eglot
  :ensure nil
  :hook ((python-ts-mode      . eglot-ensure)
         (java-ts-mode        . eglot-ensure)
         (js-ts-mode          . eglot-ensure)
         (typescript-ts-mode  . eglot-ensure)
         (tsx-ts-mode         . eglot-ensure)
         (yaml-ts-mode        . eglot-ensure)
         (nxml-ts-mode           . eglot-ensure)
         (html-ts-mode           . eglot-ensure)
         (mhtml-ts-mode          . eglot-ensure)
         (css-ts-mode         . eglot-ensure))
  :config
  ;; Disable automatic eldoc display in minibuffer for eglot buffers
  ;;(setq eldoc-echo-area-use-multiline-p nil)
  ;; K shows hover docs in a dedicated buffer (vim-style)
  (setq eldoc-idle-delay 1)
  (setq eldoc-echo-area-use-multiline-p nil)
  (setq eldoc-echo-area-prefer-doc-buffer t)
  (global-eldoc-mode 1)
  (setq eglot-send-changes-idle-time 1)
  (setq eglot-report-progress nil)
  (setq eglot-ignored-server-capabilities
	'(:inlayHintProvider))          ; inline type hints
  (add-to-list 'eglot-server-programs
               '((nxml-mode xml-mode) . ("lemminx"))))

(require 'eglot-booster)

(eglot-booster-mode 1)


;;; ============================================================
;;; MAGIT — full-featured git interface
;;; ============================================================
(use-package magit
  :ensure t
  :config
  (with-eval-after-load 'evil
    (evil-define-key '(normal visual) 'global
      (kbd "<leader>g") #'magit-status)))

(use-package pet
  :config
  (add-hook 'python-base-mode-hook 'pet-mode -10))

(provide 'mypackages)
