(setq display-line-numbers-type 'relative)

(global-display-line-numbers-mode 1)

;;; ============================================================
;;; STARTUP UI TWEAKS
;;; ============================================================
(setq inhibit-startup-screen t)

;; (menu-bar-mode -1)        ; uncomment to reclaim the top menu bar's space

(setq scroll-margin 8)      ; keep N lines of context above/below cursor
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;;; ============================================================
;;; QUALITY-OF-LIFE MODES
;;; ============================================================
(recentf-mode 1)
(save-place-mode 1)              ; remember cursor position per file across sessions
(global-auto-revert-mode 1)

;;; ============================================================
;;; COMPLETION — VERTICAL MINIBUFFER UI
;;; ============================================================
(fido-vertical-mode 1)

;;; ============================================================
;;; SPELL CHECKING
;;; ============================================================
;; Requires aspell or hunspell installed on the OS.
;;
;; flyspell-mode    — checks prose, underlines misspellings.
;; flyspell-prog-mode — same, but only inside comments/strings (use in code).
;;
;; Hooks cover all the prose modes you might land in: text (.txt),
;; both markdown variants (.md), and org.
(dolist (hook '(org-mode-hook
                text-mode-hook
                markdown-mode-hook
                markdown-ts-mode-hook))
  (add-hook hook #'flyspell-mode))


;; No beep or flash on C-g, end of buffer, etc.
(setq ring-bell-function 'ignore)

;;; ============================================================
;;; KEEP PROJECT DIRECTORIES CLEAN
;;; ============================================================
;; Redirect Emacs's sidecar files (foo~, #foo#) into ~/.emacs.d/ so
;; they don't clutter project directories or show up in git status.
;; Lock files (.#foo) can't be relocated — they have to live next to
;; the file they protect — so we just disable them. Safe as long as
;; you don't run multiple Emacs editing the same file simultaneously.
(setq backup-directory-alist
      `(("." . ,(expand-file-name "backups/" user-emacs-directory))))
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "auto-saves/" user-emacs-directory) t)))
(setq create-lockfiles nil)

(electric-pair-mode 1)

(add-hook 'before-save-hook #'delete-trailing-whitespace)

(setq require-final-newline t)

(setq scroll-conservatively 101)     ; never recenter; smooth incremental scroll

(scroll-bar-mode -1)

(tool-bar-mode -1)

(load-theme 'modus-vivendi t)

(setq auto-revert-check-vc-info t)

(provide 'options)


(setq-default mode-line-buffer-identification
              '(:eval
                (if buffer-file-name
                    (abbreviate-file-name buffer-file-name)
                  (buffer-name))))

;;; ============================================================
;;; AUTO-SAVE ON BUFFER SWITCH
;;; ============================================================
;; Hooks into the lower-level window-buffer-change-functions so it
;; catches every way of leaving a buffer (evil's :b, project switch,
;; mouse clicks, programmatic switches).
(defun my/save-buffer-on-switch ()
  "Save current buffer if it visits a file and has unsaved changes."
  (when (and buffer-file-name
             (buffer-modified-p)
             (file-writable-p buffer-file-name))
    (save-buffer)))

(add-hook 'window-buffer-change-functions
          (lambda (_window) (my/save-buffer-on-switch)))

(defun my/indent-buffer-on-save ()
  "Indent the entire buffer before saving (elisp only)."
  (when (derived-mode-p 'emacs-lisp-mode 'lisp-interaction-mode)
    (indent-region (point-min) (point-max))))

(add-hook 'before-save-hook #'my/indent-buffer-on-save)
