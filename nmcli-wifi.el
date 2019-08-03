(define-derived-mode nmcli-wifi-mode tabulated-list-mode
  "nmcli-wifi"
  "nmcli WiFi Mode"
  (let ((columns [("IN-USE" 10)
                  ("SSID" 30)
                  ("MODE" 10)
                  ("CHAN" 5)
                  ("RATE" 15)
                  ("SIGNAL" 10)
                  ("BARS" 5)
                  ("SECURITY" 10)])
        (rows (nmcli-wifi--shell-command)))
    (setq tabulated-list-format columns)
    (setq tabulated-list-entries rows)
    (tabulated-list-init-header)
    (tabulated-list-print)))

(defun nmcli-wifi-refresh ()
  (interactive)
  (let ((rows (nmcli-wifi--shell-command)))
    (setq tabulated-list-entries rows)
    (tabulated-list-print t t)))

(defun nmcli-wifi--shell-command ()
  (interactive)
  (mapcar (lambda (x)
            `(nil ,(vconcat [] x)))
          (mapcar (lambda (x)
                    (if (string= "*" (car x)) x (cons "" x)))
                  (cdr (mapcar (lambda (x)
                                 (split-string x "  " t " "))
                               (split-string (shell-command-to-string "nmcli dev wifi") "\n" t))))))

(defun nmcli-wifi ()
  (interactive)
  (switch-to-buffer "*nmcli-wifi*")
  (nmcli-wifi-mode))

(define-key nmcli-wifi-mode-map (kbd "g") 'nmcli-wifi-refresh)

(provide 'nmcli-wifi)
