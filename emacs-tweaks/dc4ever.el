;; Here lies newly added functions for my own needs

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
            (async-shell-command
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
  (slack-register-team
   :name "deepmotion"
   :default t
   :client-id "xiaoxiangcao@deepmotion.ai"
   :client-secret (shell-command-to-string "cd ~/.ssh/secret/; openssl rsautl -in pass.enc -inkey key.pem -decrypt")
   :token (shell-command-to-string "cd ~/.ssh/secret/; openssl rsautl -in token.enc -inkey key.pem -decrypt")
   :subscribed-channels '(slackbot))
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
(setq org-capture-templates
      '(("w" "work" entry (file "~/Dropbox/org/work.org")
         "* TODO %?\n" :prepend t)
        ("l" "life" entry (file "~/Dropbox/org/life.org")
         "* TODO %?\n" :prepend t)
        ("b" "balance" entry (file "~/Dropbox/org/balance.org")
         "* TODO %?\n" :prepend t)))

(provide 'dc4ever)
