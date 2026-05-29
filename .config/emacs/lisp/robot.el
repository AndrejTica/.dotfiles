;; Read the test name from the current line, build a robot CLI command,
;; and send it into vterm. Reuses the existing *vterm* buffer if one
;; exists, otherwise creates one (and waits 0.5s for the shell to be
;; ready — otherwise the first character or two can be eaten by a
;; not-yet-initialized terminal).
(defun robot-run-test ()
  (interactive)
  (let* (
	 (testName (string-trim (thing-at-point 'line)))
	 (cmd (format "robot --loglevel TRACE --test '%s' %s\n" testName (buffer-file-name)))
	 )
    (unless (get-buffer "*vterm*")
      (vterm)
      (sit-for 0.5))   ; give the shell half a second to start
    (pop-to-buffer "*vterm*")
    (vterm-send-string cmd)
    )
  )

(use-package robot-mode
  :ensure t
  :mode "\\.robot\\'"
  :config
  (evil-define-key '(normal visual) 'global
    (kbd "<leader>r")  #'robot-run-test)    ; run robot test case
  )

(provide 'robot)
