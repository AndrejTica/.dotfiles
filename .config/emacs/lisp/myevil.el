;;; ============================================================
;;; EVIL — VIM EMULATION
;;; ============================================================
(use-package evil
  :demand t

  :init
  ;; These four MUST be set before evil loads — they're read once,
  ;; at package init time. Setting them in :config does nothing.
  (setq evil-want-keybinding nil)         ; let evil-collection handle other modes
  (setq evil-search-module 'evil-search)  ; vim-style search w/ persistent highlight
  (setq evil-want-minibuffer t)
  (setq evil-undo-system 'undo-fu)

  :config
  (setq evil-ex-search-persistent-highlight t)  ; :set hlsearch
  (setq evil-ex-search-incremental t)           ; :set incsearch
  (setq evil-ex-search-case 'smart)             ; smartcase

  (evil-mode 1)

  (evil-set-leader '(normal visual) (kbd "SPC"))

  (evil-define-key '(normal visual) 'global
    ;; Project (<leader>p)
    (kbd "<leader>pb") #'project-switch-to-buffer
    (kbd "<leader>pf") #'project-find-file
    (kbd "<leader>pp") #'project-switch-project
    (kbd "<leader>pg") #'project-find-regexp
    ;; Tools
    (kbd "<leader>g")  #'vc-dir
    (kbd "<leader>t")  #'my/vterm-new
    (kbd "<leader>r")  #'robot-run-test
    (kbd "<leader>n")  #'dired-jump)

  (define-key evil-normal-state-map (kbd "<escape>") #'evil-ex-nohighlight))

;;; ============================================================
;;; EVIL-COLLECTION — vim bindings for built-in modes
;;; ============================================================
(use-package evil-collection
  :after evil
  :config (evil-collection-init))

;;; ============================================================
;;; EVIL-GOGGLES — visual feedback for yank/delete/change/etc.
;;; ============================================================
(use-package evil-goggles
  :ensure t
  :after evil
  :config
  ;; Slightly faster than default for a snappier feel.
  (setq evil-goggles-duration 0.15)
  ;; Use the default face from your theme (highlights nicely on modus-vivendi).
  (evil-goggles-mode 1)
  ;; Use a "pulse" effect instead of a static highlight (optional but nice).
  (evil-goggles-use-diff-faces))

;;; ============================================================
;;; EVIL-SURROUND — ys/cs/ds for quotes, parens, tags
;;; ============================================================
(use-package evil-surround
  :ensure t
  :after evil
  :config (global-evil-surround-mode 1))

;;; ============================================================
;;; EVIL-COMMENTARY — gc operator to toggle comments
;;; ============================================================
;; Examples: gcc (line), gcap (paragraph), gcG (to end of file),
;; gcif (with tree-sitter text objects: inside function).
(use-package evil-commentary
  :ensure t
  :after evil
  :config (evil-commentary-mode 1))

;;; ============================================================
;;; TREE-SITTER TEXT OBJECTS FOR EVIL
;;; ============================================================
;; AST-backed text objects: daf, cif, vac, etc.
(use-package evil-textobj-tree-sitter
  :ensure t
  :after evil
  :config
  ;; Function
  (define-key evil-outer-text-objects-map "f"
              (evil-textobj-tree-sitter-get-textobj "function.outer"))
  (define-key evil-inner-text-objects-map "f"
              (evil-textobj-tree-sitter-get-textobj "function.inner"))

  ;; Class
  (define-key evil-outer-text-objects-map "c"
              (evil-textobj-tree-sitter-get-textobj "class.outer"))
  (define-key evil-inner-text-objects-map "c"
              (evil-textobj-tree-sitter-get-textobj "class.inner"))

  ;; Parameter / argument
  (define-key evil-outer-text-objects-map "a"
              (evil-textobj-tree-sitter-get-textobj "parameter.outer"))
  (define-key evil-inner-text-objects-map "a"
              (evil-textobj-tree-sitter-get-textobj "parameter.inner"))

  ;; Comment
  (define-key evil-outer-text-objects-map "C"
              (evil-textobj-tree-sitter-get-textobj "comment.outer"))
  (define-key evil-inner-text-objects-map "C"
              (evil-textobj-tree-sitter-get-textobj "comment.inner")))

(provide 'myevil)
