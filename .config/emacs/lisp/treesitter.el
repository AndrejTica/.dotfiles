;;; ============================================================
;;; TREE-SITTER — better syntax highlighting and structural editing
;;; ============================================================
;; Swap *-ts-mode for supported languages and prompt to install
;; missing grammars on demand.
(use-package treesit-auto
  :ensure t
  :demand t
  :config
  (setq treesit-auto-install 'prompt)
  (global-treesit-auto-mode))


;;; ============================================================
;;; TREE-SITTER GRAMMARS — markdown, yaml, toml
;;; ============================================================
;; Markdown is unusual — the repo holds TWO grammars (block + inline)
;; in subdirectories on the split_parser branch, so it needs the
;; 4-element form (LANG URL BRANCH SUBDIR).
(setq treesit-language-source-alist
      '((markdown        "https://github.com/tree-sitter-grammars/tree-sitter-markdown"
                         "split_parser"
                         "tree-sitter-markdown/src")
        (markdown-inline "https://github.com/tree-sitter-grammars/tree-sitter-markdown"
                         "split_parser"
                         "tree-sitter-markdown-inline/src")
        (yaml            "https://github.com/tree-sitter-grammars/tree-sitter-yaml")
        (toml            "https://github.com/tree-sitter-grammars/tree-sitter-toml")))

;; Auto-install missing grammars at startup. First run clones and
;; compiles each (needs a C compiler); subsequent starts are instant.
(dolist (grammar '(markdown markdown-inline yaml toml))
  (unless (treesit-language-available-p grammar)
    (treesit-install-language-grammar grammar)))

(add-to-list 'auto-mode-alist '("\\.md\\'"        . markdown-ts-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'"  . markdown-ts-mode))
(add-to-list 'auto-mode-alist '("\\.ya?ml\\'"     . yaml-ts-mode))
(add-to-list 'auto-mode-alist '("\\.toml\\'"      . toml-ts-mode))

(use-package markdown-ts-mode
  :mode ("\\.md\\'" . markdown-ts-mode)
  :defer 't)



(provide 'treesitter)
