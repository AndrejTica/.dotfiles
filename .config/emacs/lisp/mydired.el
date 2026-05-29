(setq dired-listing-switches "-alh --group-directories-first")

;;; ============================================================
;;; DIRED — q kills the buffer instead of burying it
;;; ============================================================
;; By default, q runs quit-window which just hides the buffer.
;; Buried dired buffers still show up in project-switch-to-buffer
;; and similar lists. Override q to kill the buffer outright.
(with-eval-after-load 'dired
  (evil-collection-define-key 'normal 'dired-mode-map
    (kbd "q") #'kill-current-buffer))

(with-eval-after-load 'dired
  (evil-collection-define-key 'normal 'dired-mode-map
    (kbd "<left>")  #'dired-up-directory))

;; Reuse one buffer when navigating into subdirectories. Without
;; this, every RET on a folder opens a new dired buffer and q has
;; to be pressed once per nested folder to clean up.
(setq dired-kill-when-opening-new-dired-buffer t)

;; Kill the dired buffer when opening a file, so dired never
;; shows up in project-switch-to-buffer (C-x p b).
(with-eval-after-load 'dired
  (advice-add 'dired-find-file :around
              (lambda (orig &rest args)
                (let ((dired-buf (current-buffer)))
                  (apply orig args)
                  (when (not (eq (current-buffer) dired-buf))
                    (kill-buffer dired-buf))))))

;; In dired, default the destination of copy/move operations to the
;; other dired window when split — fast for "copy A to B" workflows.
(setq dired-dwim-target t)

(provide 'mydired)
