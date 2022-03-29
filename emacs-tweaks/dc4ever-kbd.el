;; -*- lexical-binding: t; -*-

(eval-when-compile
  (require 'ivy)
  (require 'evil)
  (require 'dash))

(defvar evil-insert-state-map)
(defvar evil-motion-state-map)
(defvar evil-normal-state-map)
(defvar counsel-ag-command)

(defcustom dc4ever//rg-common-types
  (list "c" "cpp" "elisp")
  "Common file types of `counsel-rg' searches."
  :type '(repeat string))

(spacemacs/set-leader-keys "om" 'dc4ever/make)
(spacemacs/set-leader-keys "os" #'counsel-search)
(spacemacs/set-leader-keys "oe" 'dc4ever/edit-makefile)
(spacemacs/set-leader-keys "bo" 'switch-to-buffer-other-window)
(spacemacs/set-leader-keys "oh" 'dc4ever/toggle-write-hook)
(spacemacs/set-leader-keys "qr" 'dc4ever/disable-restart)
(spacemacs/set-leader-keys "qR" 'dc4ever/disable-restart)
(spacemacs/set-leader-keys "or"
  (lambda nil
    (interactive)
    (redshift-indent-mode -1)
    (redshift-indent-mode 2)))
(spacemacs/set-leader-keys "ow" 'sunshine-forecast)
(spacemacs/set-leader-keys "ot" 'dc4ever/org)
(spacemacs/set-leader-keys "od" 'zeal-at-point)

;; (define-key evil-insert-state-map (kbd "C-c C-c") 'evil-normal-state)
(define-key evil-insert-state-map (kbd "C-c C-f") 'company-files)
;; (define-key evil-normal-state-map (kbd "C-c C-c") 'evil-normal-state)
(define-key evil-insert-state-map (kbd "C-a") 'mwim-beginning-of-code-or-line)
(define-key evil-insert-state-map (kbd "C-e") 'mwim-end-of-line-or-code)
;; (define-key evil-motion-state-map (kbd "M-j") 'centaur-tabs-forward)
;; (define-key evil-motion-state-map (kbd "M-k") 'centaur-tabs-backward)

(with-eval-after-load 'vterm
  (defvar dc4ever--vterm-info nil)
  (defun dc4ever/vterm-dabbrev-commit nil
    "Commit info back to `vterm' buffer."
    (interactive)
    (let ((s (buffer-substring-no-properties (cdr dc4ever--vterm-info) (point))))
      (kill-buffer-and-window)
      (switch-to-buffer (car dc4ever--vterm-info))
      (vterm-insert s)))

  (defun dc4ever/vterm-evil-C-n (arg)
    "Create a helper buffer to use `evil-complete-next' for `vterm-insert'.
With prefix arg, enable \"I'm Feeling Lucky\"."
    (interactive "P")
    (let ((buf (get-buffer-create "vterm-dabbrev"))
          (vb (current-buffer))
          (start (+ 2 (save-excursion (beginning-of-line) (point))))
          (end (point)))
      (switch-to-buffer-other-window buf)
      (insert-buffer-substring vb start end)
      (let ((inhibit-message t))
        (call-interactively #'evil-append-line))
      (setq dc4ever--vterm-info (cons vb (point)))
      (if arg
          (progn
            (ignore-errors (dabbrev-expand nil))
            (dc4ever/vterm-dabbrev-commit))
        (local-set-key (kbd "RET") #'dc4ever/vterm-dabbrev-commit))))

  (define-key vterm-mode-map (kbd "C-n") #'dc4ever/vterm-evil-C-n)

  (defun dc4ever//vterm-enable-C-n nil
    "Enable `dc4ever/vterm-evil-C-n'"
    (define-key evil-insert-state-local-map (kbd "C-n") #'dc4ever/vterm-evil-C-n)
    (define-key evil-insert-state-local-map (kbd "C-u") #'universal-argument))
  (add-hook 'vterm-mode-hook #'dc4ever//vterm-enable-C-n))

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
      (-map (lambda (l) (--> l
                     (split-string it ":")
                     (s-join "\t" it))) lines)))

  (defvar dc4ever//rg-type-cache
    (lazy-completion-table dc4ever//rg-type-cache dc4ever--get-rg-type-list)
    "Cache of `counsel-rg' type list.")

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
    (ivy-define-key map (kbd "C-c C-c") #'ivy-toggle-calling)
    (ivy-define-key map (kbd "C-c C-t") #'dc4ever/rg-restrict-type)))

(with-eval-after-load 'paredit
  (global-set-key (kbd "M-l") #'paredit-forward-slurp-sexp)
  (global-set-key (kbd "M-h") #'paredit-forward-barf-sexp))

(global-set-key (kbd "C-SPC") #'toggle-input-method)
(global-set-key (kbd "C-x C-p") #'previous-buffer)
(global-set-key (kbd "C-x C-n") #'next-buffer)

(with-eval-after-load 'prog-mode
  (defun dc4ever//prev-or-next-line-empty-p (num)
    (save-excursion
      (if (> num 0) (next-logical-line) (previous-logical-line))
      (beginning-of-line)
      (looking-at-p "[[:space:]]*$")))

  (defun dc4ever//meta (num)
    "Go up or down!!!"
    (unless (dc4ever//prev-or-next-line-empty-p num)
      (save-excursion
        (let ((a (point-at-bol))
              (b (point-at-eol))
              c d)
          (if (> num 0) (next-logical-line) (previous-logical-line))
          (setq c (point-at-bol)
                d (point-at-eol))
          (transpose-regions a b c d)))))

  (define-key global-map (kbd "M-k")
    (lambda nil (interactive) (dc4ever//meta -1)))
  (define-key global-map (kbd "M-j")
    (lambda nil (interactive) (dc4ever//meta 1))))

(with-eval-after-load 'help-mode
  (add-hook
   'help-mode-hook
   (lambda nil (define-key evil-motion-state-local-map (kbd "K")
            #'elisp-slime-nav-describe-elisp-thing-at-point))))

(provide 'dc4ever-kbd)

