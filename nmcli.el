(define-derived-mode nmcli-wifi-mode tabulated-list-mode
  "nmcli-wifi"
  "nmcli WiFi Mode"
  (let ((output (mapcar (lambda (x)
                          (split-string x " " t " "))
                        (split-string (shell-command-to-string "nmcli dev wifi") "\n" t))))
    (let ((columns (vconcat []
                            (mapcar (lambda (x)
                                      (list x 10))
                                    (car output))))
          (rows (mapcar (lambda (x)
                          `(nil ,(vconcat [] x)))
                        (mapcar (lambda (x)
                                  (if (string= "*" (car x)) x (cons "" x)))
                                (cdr output)))))
      (setq tabulated-list-format columns)
      (setq tabulated-list-entries rows)
      (tabulated-list-init-header)
      (tabulated-list-print)))
  (defun nmcli-wifi ()
    (interactive)
    (switch-to-buffer "*nmcli-wifi*")
    (nmcli-wifi-mode)))
