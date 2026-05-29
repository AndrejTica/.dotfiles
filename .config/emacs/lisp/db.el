
;;; ============================================================
;;; SQL — POSTGRES CONNECTION FROM ENV VARS
;;; ============================================================
;; Connect with M-x sql-connect RET docstore-dev RET.
;; Env vars to set in your shell (~/.bashrc):
;;   DOCSTORE_DB_DEV_USER, _NAME, _HOST, _PORT, _PASSWORD
;;
;; The backtick + ,getenv form is a quasiquote: the list is literal
;; except the parts prefixed with comma, which are evaluated at
;; init-load time. That lets us splice env-var values into a static
;; config structure.
(setq sql-connection-alist
      `((docstore-dev
         (sql-product 'postgres)
         (sql-user     ,(or (getenv "DOCSTORE_DB_DEV_USER") ""))
         (sql-database ,(or (getenv "DOCSTORE_DB_DEV_NAME") ""))
         (sql-server   ,(or (getenv "DOCSTORE_DB_DEV_HOST") ""))
         (sql-password ,(or (getenv "DOCSTORE_DB_DEV_PASSWORD") ""))
         (sql-port     ,(string-to-number
                         (or (getenv "DOCSTORE_DB_DEV_PORT") "5432"))))))

;; Truncate long lines so wide query results stay column-aligned.
(add-hook 'sql-interactive-mode-hook
          (lambda ()
            (toggle-truncate-lines t)))

(provide 'db)
