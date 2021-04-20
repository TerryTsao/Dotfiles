(spacemacs/set-leader-keys "om" 'dc4ever/make)
(spacemacs/set-leader-keys "os" #'counsel-search)
(spacemacs/set-leader-keys "oe" 'dc4ever/edit-makefile)
(spacemacs/set-leader-keys "bo" 'switch-buffer-other-window-without-purpose)
(spacemacs/set-leader-keys "oh" 'dc4ever/toggle-write-hook)
(spacemacs/set-leader-keys "qr" 'dc4ever/disable-restart)
(spacemacs/set-leader-keys "qR" 'dc4ever/disable-restart)
(spacemacs/set-leader-keys "or" 'lisp-state-eval-sexp-end-of-line)
(spacemacs/set-leader-keys "ow" 'sunshine-forecast)
(spacemacs/set-leader-keys "ot" 'dc4ever/org)
(spacemacs/set-leader-keys "od" 'zeal-at-point)

(define-key evil-insert-state-map (kbd "C-c C-c") 'evil-normal-state)
(define-key evil-insert-state-map (kbd "C-c C-f") 'company-files)
(define-key evil-normal-state-map (kbd "C-c C-c") 'evil-normal-state)
(define-key evil-insert-state-map (kbd "C-a") 'mwim-beginning-of-code-or-line)
(define-key evil-insert-state-map (kbd "C-e") 'mwim-end-of-line-or-code)
(define-key evil-motion-state-map (kbd "M-j") 'centaur-tabs-forward)
(define-key evil-motion-state-map (kbd "M-k") 'centaur-tabs-backward)

(defun dc4ever/vterm-def-key nil
  "Define keybindings for `vterm-mode'"
  (define-key vterm-mode-map (kbd "C-v") 'vterm-send-C-v)
  (define-key vterm-mode-map (kbd "C-c C-z") 'vterm-send-C-z)
  ;; (define-key vterm-mode-map (kbd "C-n")
  ;;   (lambda (&optional arg)
  ;;     "Allow `evil-complete-next' in `vterm-mode'."
  ;;     (interactive "P")
  ;;     (let* ((begin (point))
  ;;            (inhibit-read-only t)
  ;;            (end (funcall #'evil-complete-next arg))
  ;;            (s (buffer-substring-no-properties begin end)))
  ;;       (vterm-send-string s))))
  )
(with-eval-after-load 'vterm
  (add-hook 'vterm-mode-hook #'dc4ever/vterm-def-key))

(global-set-key (kbd "M-/") 'yas-expand)

(let ((f 'dc4ever/toggle-term))
  (global-set-key (kbd "C-'") f)
  (spacemacs/set-leader-keys "'" f))

(with-eval-after-load 'ivy
  (defun dc4ever//rg-add-option (opt)
    "Add option to `counsel-ag-command'"
    (when (minibufferp)
      (setq counsel-ag-command
            (counsel--format-ag-command opt "%s"))
      (setq ivy--old-text "")))

  (defun dc4ever--get-rg-type-list nil
    "Fetch type list for `dc4ever/rg-restrict-type'
cache inside `dc4ever//rg-type-cache'"
    (let (rlt lines)
      (with-temp-buffer
        (let ((res (call-process "rg" nil t nil "--type-list")))
          (unless (zerop res)
            (message "rg exited with error code %d" res)))
        (setq rlt (buffer-string)))
      (setq lines (split-string rlt "\n" t))
      (-map
       (lambda (line)
         (--> line
              (split-string it ":")
              (s-join "\t" it))) lines)))

  (defvar dc4ever//rg-type-cache
    (lazy-completion-table dc4ever//rg-type-cache dc4ever--get-rg-type-list)
    "Cache of `counsel-rg' type list.")

  (defcustom dc4ever//rg-common-types
    (list "c" "cpp" "elisp")
    "Common file types of `counsel-rg' searches."
    :type '(repeat string))

  (defun dc4ever--read-rg-type-list (arg)
    "Read file type from user input.
If arg is a cons cell, provide the full
candidate list `dc4ever//rg-type-cache' to the user,
and the completion requires a match;

otherwise, provide `dc4ever//rg-common-types' to the user,
and does not require match."
    (let ((s (ivy-read "File type: "
                       (if arg
                           dc4ever//rg-type-cache
                         dc4ever//rg-common-types)
                       :caller 'dc4ever/rg-restrict-type
                       :preselect "cpp.*"
                       :require-match (consp arg))))
      (if arg (car (split-string s "\t")) s)))

  (defun dc4ever/rg-restrict-type (arg)
    "Add \"-t <filetype>\" for `counsel-rg'.

With a prefix arg, must select from full list,
and completion must match;

Otherwise, provide a short list, and does not require
completion match.

Refer to helper function `dc4ever--read-rg-type-list'."
    (interactive "P")
    (when (eq 'counsel-rg (ivy-state-caller ivy-last))
      (let ((type (dc4ever--read-rg-type-list arg)))
        (dc4ever//rg-add-option (concat "-t " type)))))

  (defun dc4ever/rg-add-ignore nil
    "Turn on \"--no-ignore\" for `counsel-rg'"
    (interactive)
    (when (eq 'counsel-rg (ivy-state-caller ivy-last))
      (dc4ever//rg-add-option "--no-ignore")))

  (let ((map ivy-minibuffer-map))
    (ivy-define-key map (kbd "C-c <C-i>") #'dc4ever/rg-add-ignore)
    (ivy-define-key map (kbd "C-c C-t") #'dc4ever/rg-restrict-type)))

(provide 'dc4ever-kbd)
