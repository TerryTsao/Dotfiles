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

(defun dc4ever/vterm-evil-C-n nil
  ""
  (interactive)
  (defvar dc4ever--start-pt nil)
  (let ((inhibit-read-only t))
    (setq dc4ever--start-pt
          (if (eq last-command this-command)
              dc4ever--start-pt
            (point)))
    (dabbrev-expand nil)
    (cl-flet ((dc4ever/vterm-commit-C-n
               nil
               (interactive)
               (vterm-send-string
                (buffer-substring-no-properties dc4ever--start-pt (point)))
               (define-key vterm-mode-map (kbd "SPC") #'vterm--self-insert)))
      (define-key vterm-mode-map (kbd "SPC") #'dc4ever/vterm-commit-C-n))))

(define-key vterm-mode-map (kbd "C-n") #'dc4ever/vterm-evil-C-n)
(define-key vterm-mode-map (kbd "C-n") #'vterm-send-C-n)

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

(defun disable-lsp-conn-msg-advice (func &rest r)
  (unless (string-prefix-p "Connected" (car r))
    (apply func r)))

(advice-add 'lsp--info :around #'disable-lsp-conn-msg-advice)
(advice-remove 'lsp--info #'disable-lsp-conn-msg-advice)

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

(defvar exp-feat/recent-branches (make-hash-table :test 'equal))

(defcustom exp-feat/recent-branches-limits 3
  "Limits" :type 'integer :risky t)

(defun exp-feat/magit-insert-recent-branches nil
  "Insert recent branches"
  (let* ((dir (magit-toplevel))
         (curr-branch (magit-get-current-branch))
         (prev-branch (magit-get-previous-branch))
         (rbs (--> (gethash dir exp-feat/recent-branches)
                   (nconc (list prev-branch curr-branch) it)
                   (-distinct it)
                   (-filter (lambda (a) (and a (not (equal a curr-branch)))) it))))
    (when rbs
      (when (> (length rbs) exp-feat/recent-branches-limits)
        (--> (1- exp-feat/recent-branches-limits)
             (nthcdr it rbs)
             (setcdr it nil)))
      (puthash dir rbs exp-feat/recent-branches)
      (magit-insert-section (rb "rb")
        (magit-insert-heading "Recent branches")
        (dolist (it-branch rbs)
          (let ((output (magit-rev-format "%h %s" it-branch)))
            (string-match "^\\([^ ]+\\) \\(.*\\)" output)
            (magit-bind-match-strings (commit summary) output
              (when (and t (equal summary ""))
                (setq summary "(no commit message)"))
              (magit-insert-section (branch it-branch)
                (insert (propertize commit
                                    'font-lock-face 'magit-hash) ?\s)
                (insert (propertize it-branch
                                    'font-lock-face 'magit-branch-local) ?\s)
                (insert (funcall magit-log-format-message-function
                                 it-branch summary) ?\n)))))))))

