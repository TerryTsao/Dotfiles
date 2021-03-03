;; (advice-remove 'company-capf 'dc4ever/capf-wrapper)
;; (advice-remove 'company--capf-data 'dc4ever/filter-capf-lsp-retval)

🐍
(aref char-script-table ?🐍)
(aref char-script-table ?)
⃤
🛆

(list-fonts (font-spec :weight 'normal))
(set-fontset-font nil ?🐍 "Noto Color Emoji")
(set-fontset-font nil ? "Linux Libertine Mono O")
(set-fontset-font nil 'symbol "Noto Color Emoji" nil 'append)
(set-fontset-font nil 'symbol "Symbola" nil 'append)

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


(defun sh-set-shell-tmp-advice (func &rest r)
  "Wrap `sh-set-shell' with temporarily modified
`exec-path'."
  (let ((exec-path (cons "/bin/" exec-path)))
    (apply func r)))

(advice-add 'sh-set-shell
            :around 'sh-set-shell-tmp-advice)
(advice-remove 'sh-set-shell 'sh-set-shell-tmp-advice)

(executable-find "sh")
(let ((exec-path (cons "/bin/" exec-path))) (executable-find "sh"))

(let ((fsize 20)   ;; font size
      (fs (font-spec :name (frame-parameter nil 'font))))
  (font-put fs :size fsize)
  (set-frame-font fs nil t)
  (let ((new-font (frame-parameter nil 'font))
        (current-default (assq 'font default-frame-alist)))
    (if current-default
        (setcdr current-default new-font)
      (push (cons 'font new-font) default-frame-alist))))
