;; -*- lexical-binding: t; -*-

;; Here lies newly added functions for my own needs

(defun dc4ever/toggle-term (arg)
  "Easily show/hide terminal buffer. With a prefix argument,
open project root or current directory, depending on ARG value."
  (interactive "P")
  (defvar dc4ever--vterm-buf nil
    "Store vterm buffer obj singleton")
  (defvar dc4ever--buf-b4-term nil
    "Store prev buf obj for internal use.")
  (prefix-numeric-value nil)
  (when arg
    (setq current-prefix-arg nil)
    (setq arg (prefix-numeric-value arg)))
  (cl-flet ((term-on nil
                     (setq dc4ever--buf-b4-term (current-buffer))
                     (cond
                      ((or (not (buffer-live-p dc4ever--vterm-buf))
                           arg)
                       (if (and arg (>= arg 10))
                           (spacemacs/projectile-shell-pop)
                         (spacemacs/default-pop-shell)))
                      (t (switch-to-buffer dc4ever--vterm-buf)))
                     (delete-other-windows)
                     (setq dc4ever--vterm-buf (current-buffer)))
            (term-off nil
                      (let ((buf dc4ever--buf-b4-term))
                        (unless (buffer-live-p buf)
                          (setq buf (other-buffer)))
                        (if (and buf (not (eq buf (current-buffer))))
                            (switch-to-buffer buf)
                          (spacemacs/switch-to-scratch-buffer)))))
    (if (eq major-mode 'vterm-mode) (term-off) (term-on))))

(defun dc4ever/org()
  (interactive)
  (find-file "/home/xiaoxiangcao/.org/todo.org"))

(defun dc4ever/get-rule-file (filename)
  "Get rule file of current proj or nil"
  (let ((pdir (projectile-project-p)))
    (and pdir (concat (locate-dominating-file pdir ".") filename))))
(defun dc4ever/make ()
  "Make current project."
  (interactive)
  (let* ((filename (dc4ever/get-rule-file "tt-special.make")))
    (if filename
        (prog2
            (message "Make start...")
            (compile
             (concat "cd " (projectile-project-p) "; make -f " filename)))
      (error "No rule to make!"))))
(defun dc4ever/edit-makefile ()
  "Edit rule file of current project"
  (interactive)
  (let* ((filename (dc4ever/get-rule-file "tt-special.make")))
    (if filename
        (find-file filename)
      (error "Not in project!"))))

(defun dc4ever/disable-restart ()
  (interactive)
  (message "Restart has been disabled for obvious reasons!"))

(with-eval-after-load 'slack
  (defvar slack-enable-wysiwyg)
  (defvar slack-emoji-master)
  (defvar slack-teams-by-token)
  (slack-register-team
   :name "deepmotion"
   :default t
   :client-id "xiaoxiangcao@deepmotion.ai"
   :token (shell-command-to-string "cd ~/.ssh/secret/; openssl rsautl -in token.enc -inkey key.pem -decrypt")
   :subscribed-channels '(slackbot hardcore-deployment))
  (setq slack-enable-wysiwyg t)
  (defun dc4ever/slack-select-emoji (team)
    (if (and (fboundp 'emojify-completing-read)
             (fboundp 'emojify-download-emoji-maybe))
        (progn (emojify-download-emoji-maybe)
               (cl-labels
                   ((select ()
                            (emojify-completing-read "Select Emoji: ")))
                 (if (< 0 (hash-table-count slack-emoji-master))
                     (select)
                   (slack-emoji-fetch-master-data (car (hash-table-values slack-teams-by-token)))
                   (select))))
      (read-from-minibuffer "Emoji: ")))
  (advice-add 'slack-select-emoji :override 'dc4ever/slack-select-emoji)
  (spacemacs/set-leader-keys "oo" 'slack-im-select))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; `org-capture-templates' setup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar org-capture-templates)

(setq org-capture-templates
      '(("w" "work" entry (file "~/Dropbox/org/work.org")
         "* TODO %?\n" :prepend t)
        ("l" "life" entry (file "~/Dropbox/org/life.org")
         "* TODO %?\n" :prepend t)
        ("b" "balance" entry (file "~/Dropbox/org/balance.org")
         "* TODO %?\n" :prepend t)))

(require 'url)
(url-do-setup)
(url-scheme-register-proxy "http")
(url-scheme-register-proxy "https")

;; (use-package rime
;;   :ensure t
;;   :custom
;;   (default-input-method "rime"))

(with-eval-after-load 'compile
  (defun dc4ever//comp-ff:advice (args)
    "Advice `compilation-find-file' when running on server."
    (let ((filename (cadr args)))
      (when (and
             (f-absolute? filename)
             (not (f-exists? filename)))
        (let ((flist (cons "." (s-split "/" filename :ignore-empty))))
          (setq filename
                (catch 'ret
                  (while t
                    (let ((fn (s-join "/" flist)))
                      (print fn)
                      (when (f-file? fn) (throw 'ret fn)))
                    (setcdr flist (cddr flist)))))))
      (setcdr args (cons filename (cddr args))))
    args)
  (advice-add #'compilation-find-file
              :filter-args #'dc4ever//comp-ff:advice))

(provide 'dc4ever)
