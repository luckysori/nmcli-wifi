(define-derived-mode nmcli-wifi-mode tabulated-list-mode
  "nmcli-wifi"
  "nmcli WiFi Mode"
  (let ((columns [("IN-USE" 10 t)
                  ("SSID" 30 t)
                  ("MODE" 10 t)
                  ("CHAN" 5 t)
                  ("RATE" 15 t)
                  ("SIGNAL" 10 t)
                  ("BARS" 5 t)
                  ("SECURITY" 10 t)])
        (rows (nmcli-wifi--shell-command)))
    (setq tabulated-list-format columns)
    (setq tabulated-list-entries rows)
    (tabulated-list-init-header)
    (tabulated-list-print)))

;; TODO: Try to rescan first
(defun nmcli-wifi-refresh ()
  (interactive)
  (let ((rows (nmcli-wifi--shell-command)))
    (setq tabulated-list-entries rows)
    (tabulated-list-print t t)))

(defun nmcli-wifi--shell-command ()
  (interactive)
  (mapcar (lambda (x)
            `(,(car (cdr x))
              ,(vconcat [] x)))
          (mapcar (lambda (x)
                    (if (string= "*" (car x)) x (cons "" x)))
                  (cdr (mapcar (lambda (x)
                                 (split-string x "  " t " "))
                               (split-string (shell-command-to-string "nmcli dev wifi") "\n" t))))))

(defun nmcli-wifi ()
  (interactive)
  (switch-to-buffer "*nmcli-wifi*")
  (nmcli-wifi-mode))

(defun nmcli-wifi-connect ()
  (interactive)
  (let ((ssid (aref (tabulated-list-get-entry) 1))
        (passwordRequired (not (string= "--" (aref (tabulated-list-get-entry) 7)))))
    (if (not passwordRequired)
        (shell-command (format "nmcli dev wifi connect \"%s\"" ssid))
      (let ((password (read-passwd "Password: ")))
        (progn (shell-command (format "nmcli dev wifi connect \"%s\" password %s" ssid password))
               (clear-string password))))))

(define-key nmcli-wifi-mode-map (kbd "g") 'nmcli-wifi-refresh)
(define-key nmcli-wifi-mode-map (kbd "c") 'nmcli-wifi-connect)

(provide 'nmcli-wifi)
