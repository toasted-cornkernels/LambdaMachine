;;; editor-mcp.el --- Emacs-side runtime for editor-mcp  -*- lexical-binding: t; -*-

;; Loaded into a running Emacs by `emacsclient --eval' on every request.
;; Requests and responses travel through JSON files so that arbitrary text
;; never has to survive shell or Lisp string quoting.

;;; Code:

(require 'json)
(require 'help)
(require 'subr-x)

(defun editor-mcp--read-forms (code)
  "Read every top-level form in the string CODE."
  (with-temp-buffer
    (insert code)
    (goto-char (point-min))
    (let (forms)
      ;; Only stop at true EOF so unbalanced input still signals an error.
      (with-syntax-table emacs-lisp-mode-syntax-table
        (while (progn (forward-comment (buffer-size)) (not (eobp)))
          (push (read (current-buffer)) forms)))
      (nreverse forms))))

(defun editor-mcp--eval (code)
  (eval (cons 'progn (editor-mcp--read-forms code)) t))

(defun editor-mcp--format (value)
  (if (stringp value)
      (substring-no-properties value)
    (prin1-to-string value)))

(defun editor-mcp--get-buffer (name)
  (or (get-buffer name) (error "No buffer named %S" name)))

(defun editor-mcp--transform (req code)
  (with-temp-buffer
    (let ((scratch (current-buffer))
          (mode (alist-get 'mode req)))
      (insert (or (alist-get 'text req) ""))
      (when (and mode (not (string-empty-p mode)))
        ;; Skip hooks so the scratch buffer never starts LSP clients etc.
        (delay-mode-hooks (funcall (intern mode))))
      (goto-char (point-min))
      (let ((value (editor-mcp--eval code)))
        (list (cons 'result (editor-mcp--format value))
              (cons 'buffer (with-current-buffer scratch
                              (buffer-substring-no-properties
                               (point-min) (point-max)))))))))

(defun editor-mcp--buffers ()
  (mapconcat
   (lambda (b)
     (with-current-buffer b
       (format "%s\t%s\t%s\t%d chars%s"
               (buffer-name)
               major-mode
               (or buffer-file-name "-")
               (buffer-size)
               (if (and buffer-file-name (buffer-modified-p)) "\tmodified" ""))))
   (seq-remove (lambda (b) (string-prefix-p " " (buffer-name b))) (buffer-list))
   "\n"))

(defun editor-mcp--read-buffer (req)
  (with-current-buffer (editor-mcp--get-buffer (alist-get 'buffer req))
    (save-restriction
      (widen)
      (let* ((total (count-lines (point-min) (point-max)))
             (start (max 1 (or (alist-get 'start_line req) 1)))
             (end (min total (or (alist-get 'end_line req) total)))
             (point-line (line-number-at-pos (point)))
             (lines nil))
        (save-excursion
          (goto-char (point-min))
          (forward-line (1- start))
          (let ((n start))
            (while (and (<= n end) (not (eobp)))
              (push (format "%d: %s" n
                            (buffer-substring-no-properties
                             (line-beginning-position) (line-end-position)))
                    lines)
              (setq n (1+ n))
              (forward-line 1))))
        (format "[%s: lines %d-%d of %d, point at line %d, mode %s]\n%s"
                (buffer-name) start end total point-line major-mode
                (string-join (nreverse lines) "\n"))))))

(defun editor-mcp--describe (name)
  (let ((sym (intern-soft name)) parts)
    (unless sym (error "No symbol named %s" name))
    (when (fboundp sym)
      (let ((key (where-is-internal sym nil t)))
        (push (format "%s %S%s\n%s"
                      (if (commandp sym) "Command" "Function")
                      (cons sym (help-function-arglist sym t))
                      (if key (format "  [bound to %s]" (key-description key)) "")
                      (or (ignore-errors (documentation sym)) "Not documented."))
              parts)))
    (when (boundp sym)
      (push (format "Variable %s = %s\n%s"
                    name
                    (truncate-string-to-width
                     (prin1-to-string (symbol-value sym)) 1000 nil nil "...")
                    (or (documentation-property sym 'variable-documentation t)
                        "Not documented."))
            parts))
    (if parts
        (string-join (nreverse parts) "\n\n")
      (format "%s is neither a function nor a variable" name))))

(defun editor-mcp--apropos (req)
  (let* ((commands-only (eq (alist-get 'commands_only req) t))
         (limit (or (alist-get 'limit req) 200))
         (syms (apropos-internal
                (alist-get 'pattern req)
                (if commands-only #'commandp
                  (lambda (s) (or (fboundp s) (boundp s))))))
         (lines nil))
    (dolist (s (seq-take syms limit))
      (let ((doc (or (ignore-errors
                       (if (fboundp s) (documentation s t)
                         (documentation-property s 'variable-documentation t)))
                     "")))
        (push (format "%s%s\t%s" s (if (fboundp s) "" " (variable)")
                      (car (split-string doc "\n")))
              lines)))
    (concat (string-join (nreverse lines) "\n")
            (if (> (length syms) limit)
                (format "\n... %d more; narrow the pattern" (- (length syms) limit))
              ""))))

(defun editor-mcp-run (request-file response-file)
  "Run the request in REQUEST-FILE and write the JSON response to RESPONSE-FILE."
  (let* ((json-object-type 'alist)
         (json-key-type 'symbol)
         (json-false nil)
         (req (let ((coding-system-for-read 'utf-8))
                (json-read-file request-file)))
         (op (alist-get 'op req))
         (code (or (alist-get 'code req) ""))
         (printed (generate-new-buffer " *editor-mcp-output*"))
         response)
    (unwind-protect
        (progn
          (setq response
                (condition-case err
                    (let ((standard-output printed))
                      (pcase op
                        ("eval"
                         (let ((buf (alist-get 'buffer req)))
                           (list (cons 'result
                                       (editor-mcp--format
                                        (if buf
                                            (with-current-buffer (editor-mcp--get-buffer buf)
                                              (editor-mcp--eval code))
                                          (editor-mcp--eval code)))))))
                        ("transform" (editor-mcp--transform req code))
                        ("buffers" (list (cons 'result (editor-mcp--buffers))))
                        ("read" (list (cons 'result (editor-mcp--read-buffer req))))
                        ("describe" (list (cons 'result (editor-mcp--describe
                                                         (alist-get 'symbol req)))))
                        ("apropos" (list (cons 'result (editor-mcp--apropos req))))
                        (_ (error "Unknown op %S" op))))
                  (error (list (cons 'error (error-message-string err))))))
          (let ((out (with-current-buffer printed (buffer-string))))
            (unless (string-empty-p out)
              (push (cons 'output (substring-no-properties out)) response))))
      (kill-buffer printed))
    (let ((coding-system-for-write 'utf-8))
      (with-temp-file response-file
        (insert (json-encode response))))
    t))

(provide 'editor-mcp)
;;; editor-mcp.el ends here
