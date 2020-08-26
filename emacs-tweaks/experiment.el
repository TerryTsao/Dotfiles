(defun dc4ever/filter-capf-lsp-retval (res)
  ""
  (unless (and (and (symbolp 'dc4ever/capf-prefix?) dc4ever/capf-prefix?)
              (eq 'lsp-completion-at-point (car res))
              (eq 'ccls (lsp--client-server-id (car (lsp-workspaces))))
              (let ((bounds-start (nth 1 res)))
                (save-excursion
                  (goto-char bounds-start)
                  (unless (= (point) (point-at-bol))
                    (and
                     (not (equal "#include "
                                 (buffer-substring-no-properties
                                  (point-at-bol)
                                  (+ (point-at-bol) (length "#include ")))))
                     (equal "\"" (buffer-substring-no-properties
                                  (- (point) 1) (point))))))))
         res))

(defun dc4ever/capf-wrapper (func &rest r)
  ""
  (if (eq 'prefix (car r))
      (let ((dc4ever/capf-prefix? t))
        (funcall func r))
    (funcall func r)))

(advice-add 'company-capf :around 'dc4ever/capf-wrapper)
(advice-add 'company--capf-data :filter-return 'dc4ever/filter-capf-lsp-retval)
