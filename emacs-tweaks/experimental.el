;; -*- lexical-binding: t; -*-

;; (advice-remove 'company-capf 'dc4ever/capf-wrapper)
;; (advice-remove 'company--capf-data 'dc4ever/filter-capf-lsp-retval)

🐍
(aref char-script-table ?🐍)
(aref char-script-table ?)
⃤
🛆

(let ((s "cudaMemcpy(${1:void *dst}, ${2:const void &s324rc}, ${33:size_t count_34}, ${4:enum cudaMemcpyKind _kind})$0"))
  (replace-regexp-in-string
   (rx
    "${"
    (group (+ digit))
    ":"
    (* (not "}"))
    " "
    (* (any "*&"))
    (group (+ (any alnum "_")) "}"))
   "${\\1:\\2"
   s))

(cond ((and (boundp 'once-yas-type)
            (eq once-yas-type 'jiangbin-style))
       "kdsjfkdsjf")
      (t
       (let ((root (if (boundp 'micah-clang-proj-root)
                       micah-clang-proj-root
                     ""))
             (p (file-relative-name default-directory (projectile-project-root)))
             (f (f-filename (buffer-file-name))))
         (upcase (s-join "_"
                         (append (cons root (s-split "/" p t)) (s-split "\\." f) (list "")))))))

(defun dc4ever/fix-eaf-refactor-autoload nil
  "EAF refactor brings autoload issues. This is my attempt to fix it."
  (interactive))
(let* ((root (f-dirname (find-lisp-object-file-name 'eaf-open 'defun)))
       (appdir (expand-file-name "app" root))
       (apps (-map (lambda (d) (f-filename d)) (f-directories appdir))))
  (cl-loop
   for app in apps
   do
   (let ((f (format "eaf-%s.el" app))
         (atl (expand-file-name "eaf-autoloads.el" root))
         (d (expand-file-name app appdir)))
     (let ((path (expand-file-name f d)))
       (when (f-exists? path)
         ;; (find-file path)
         ;; (goto-char (point-min))
         ;; (insert "(require 'eaf)")
         ;; (save-buffer)
         ;; (kill-buffer)
         (make-directory-autoloads d atl))))))

(list-fonts (font-spec :weight 'normal))
(set-fontset-font nil ?🐍 "Noto Color Emoji")
(set-fontset-font nil ?  "Linux Libertine Mono O" nil 'prepend)
(set-fontset-font nil 'symbol "Noto Color Emoji" nil 'prepend)
(set-fontset-font nil 'symbol "Symbola" nil 'prepend)

(lambda nil nil)

(-filter
 (lambda (name)
   (if-let ((spec (find-font (font-spec :name name)))
            (font (open-font spec)))
       (let ((ret (font-get-glyphs font 0 1 [?])))
         (not (equal [nil] ret)))))
 (-uniq (font-family-list)))

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

(defvar dc4ever--start-pt nil)

(defun dc4ever/vterm-dabbrev-commit nil
  (interactive)
  (define-key vterm-mode-map (kbd "SPC") #'vterm--self-insert)
  (setq-local inhibit-read-only nil)
  (vterm-insert
   (s-chop-prefix dabbrev--last-abbreviation dabbrev--last-expansion)))

(defun dc4ever/vterm-evil-C-n nil
  ""
  (interactive)
  ;; (define-key vterm-mode-map (kbd "SPC") #'dc4ever/vterm-dabbrev-commit)
  (let ((inhibit-read-only t))
    (dabbrev-expand nil)
    (vterm-insert
     (s-chop-prefix dabbrev--last-abbreviation dabbrev--last-expansion))))

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

(defun find-recent-dirs (dir)
  (interactive
   (list (completing-read "Recent dirs: "
                          (-uniq  (-filter (lambda (p) (and (not (file-remote-p p))
                                                       (f-directory? p)))
                                           (-map #'f-dirname recentf-list))))))
  (find-file dir))

(defun locate-my-url-proxy (urlobj host)
  (cond
   ((string-match-p "\\.ec2\\.internal" host)
    "PROXY ip-10-0-37-237.ec2.internal:8081")
   (t "DIRECT")))

;;; returns "http://ip-10-0-37-237.ec2.internal:8081/"
(let ((url-proxy-locator #'locate-my-url-proxy)
      (urlobj (url-generic-parse-url "https://sldjf.ec2.internal/jdsklfj")))
  (url-find-proxy-for-url urlobj (url-host urlobj)))

(let ((s (browse-url-file-url "/home/xiaoxiangcao/sandbox/emacs-workshop/README.html")))
  (cl-labels ((pred (s)
                    (let ((url (url-generic-parse-url s)))
                      (when (string-equal "file" (url-type url))
                        (let ((f (url-filename url)))
                          (f-file? (f-join (f-dirname f) (concat (f-base f) ".org"))))))))
    (pred s)))

