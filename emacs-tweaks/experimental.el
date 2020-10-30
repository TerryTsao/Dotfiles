;; (advice-remove 'company-capf 'dc4ever/capf-wrapper)
;; (advice-remove 'company--capf-data 'dc4ever/filter-capf-lsp-retval)

(lambda nil nil)

(defun tmp nil
  (prettify-symbols-mode -1)
  (setq-local prettify-symbols-alist
              (let* ((keyword "lambda")
                     (pretty-char ?λ)
                     (kwlen (length keyword)))
                (list (cons keyword
                            (cl-loop
                             for i from 0 below kwlen
                             if (equal i (- kwlen 1))
                             collect ?\s
                             and collect (cons 'Bc 'Bc)
                             and collect pretty-char
                             else
                             collect ?\s
                             and collect (cons 'Br 'Bl))))))
  (prettify-symbols-mode t))


(tmp)

(let* ((keyword "lambda")
       (pretty-char ?λ)
       (kwlen (length keyword)))
  (list (cons keyword
              (cl-loop
               for i from 0 below kwlen
               if (equal i (- kwlen 1))
               collect ?\s
               and collect (cons 'Bc 'Bc)
               and collect pretty-char
               else
               collect ?\s
               and collect (cons 'Br 'Bl)))))
