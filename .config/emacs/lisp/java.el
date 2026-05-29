;; ;;; ============================================================
;; ;;; JAVA — JUnit test runner via compile (Maven)
;; ;;; ============================================================
;; (defun my/java-project-root ()
;;   "Return the current Maven project root, or signal an error."
;;   (or (and (project-current)
;;            (project-root (project-current)))
;;       (locate-dominating-file default-directory "pom.xml")
;;       (user-error "Not inside a Maven project (no pom.xml found)")))

;; (defun my/java-method-at-point ()
;;   "Return the Java method name enclosing point, or nil."
;;   (if (and (treesit-available-p)
;;            (derived-mode-p 'java-ts-mode))
;;       (let ((node (treesit-node-at (point))))
;;         (while (and node
;;                     (not (string= (treesit-node-type node)
;;                                   "method_declaration")))
;;           (setq node (treesit-node-parent node)))
;;         (when node
;;           (treesit-node-text
;;            (treesit-node-child-by-field-name node "name"))))
;;     (save-excursion
;;       (when (re-search-backward
;;              "\\(?:public\\|private\\|protected\\).*?\\s-\\([a-zA-Z0-9_]+\\)\\s-*("
;;              nil t)
;;         (match-string 1)))))

;; (defun my/java-test-all ()
;;   "Run the entire JUnit suite with Maven."
;;   (interactive)
;;   (let ((default-directory (my/java-project-root)))
;;     (compile "mvn test")))

;; (defun my/java-test-class ()
;;   "Run all JUnit tests in the current class with Maven."
;;   (interactive)
;;   (let* ((default-directory (my/java-project-root))
;;          (class (file-name-base (buffer-file-name))))
;;     (compile (format "mvn test -Dtest=%s" (shell-quote-argument class)))))

;; (defun my/java-test-method ()
;;   "Run the single JUnit test method at point with Maven."
;;   (interactive)
;;   (let* ((default-directory (my/java-project-root))
;;          (class (file-name-base (buffer-file-name)))
;;          (method (my/java-method-at-point)))
;;     (unless method
;;       (user-error "Couldn't find a test method at point"))
;;     (compile (format "mvn test -Dtest=%s#%s"
;;                      (shell-quote-argument class)
;;                      (shell-quote-argument method)))))

;; (with-eval-after-load 'evil
;;   (dolist (mode '(java-mode java-ts-mode))
;;     (evil-define-key 'normal (intern (format "%s-map" mode))
;;       (kbd "<leader>ta") #'my/java-test-all
;;       (kbd "<leader>tf") #'my/java-test-class
;;       (kbd "<leader>tt") #'my/java-test-method)))
