;; -*- lexical-binding: t; -*-

;; Better default configurations for me

(eval-when-compile
  (require 'dash)
  (require 'bind-key)
  (require 'use-package)
  (require 'ivy))

(defvar company-minimum-prefix-length)
(defvar company-lighter)

(eval-after-load 'dash '(global-dash-fontify-mode))
(setq prettify-symbols-unprettify-at-point t)
(with-eval-after-load 'prog-mode
  (spacemacs/toggle-highlight-long-lines-globally-on)
  (global-prettify-symbols-mode))
;; (setq powerline-default-separator 'arrow)

(defun dc4ever/better-lisp-editor nil
  "This does several things:
- Disable `electric-pair-local-mode'
- Enable `paredit-mode'
- Set using keybindings"
  (electric-pair-local-mode -1)
  (paredit-mode t)
  (local-set-key (kbd "M-l") 'paredit-forward-slurp-sexp)
  (local-set-key (kbd "M-h") 'paredit-forward-barf-sexp))
(add-hook 'emacs-lisp-mode-hook #'dc4ever/better-lisp-editor)

(with-eval-after-load 'make-mode
  (add-hook 'makefile-gmake-mode-hook
            (lambda nil (setq-local comment-style 'plain))))

(treemacs-icons-dired-mode)
(spacemacs/toggle-highlight-long-lines-globally-on)

(with-eval-after-load 'dired
  (treemacs-icons-dired-mode))

(add-to-list 'auto-mode-alist '("\\.ccls\\'" . conf-mode))
(add-to-list 'auto-mode-alist '("\\.cu[h]*\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.cl\\'" . c-mode))

(add-hook 'org-mode-hook '(lambda () (setq-local evil-auto-indent nil)))
(exec-path-from-shell-initialize)

(with-eval-after-load 'company
  (setq company-minimum-prefix-length 1)
  (global-company-mode 1)
  (unbind-key (kbd "C-n") company-active-map)
  (unbind-key (kbd "C-p") company-active-map))

(run-with-idle-timer 17 nil #'display-time-mode 1)
(run-with-idle-timer 1 nil #'require 'eaf)
(run-with-idle-timer 7 nil #'require 'eaf-pdf-viewer)
(run-with-idle-timer 7 nil #'require 'eaf-image-viewer)

(require 'doom-modeline)
(doom-modeline-def-segment minor-modes
  (format-mode-line (and (bound-and-true-p company-mode) company-lighter)))

;; (evil-set-initial-state 'vterm-mode 'emacs)
;; (evil-set-initial-state 'Custom-mode 'emacs)
(evil-set-initial-state 'sunshine-mode 'emacs)
(evil-set-initial-state '2048-mode 'emacs)
;; (evil-set-initial-state 'eaf-mode 'emacs)

;; Set unicode for displaying cards
(set-fontset-font t 'playing-cards "DejaVu Sans")
(set-fontset-font t 'symbol "Noto Color Emoji")
(set-fontset-font t 'symbol "Symbola" nil 'append)

;; (with-eval-after-load 'centaur-tabs
;;   (defun dc4ever/centaur-tabs-hide-tab (func &rest r)
;;     "Add more buffers to hide."
;;     (or
;;      (let ((mm (with-current-buffer (car r) major-mode)))
;;        (or (eq 'Info-mode mm)
;;            (unless buffer-file-name
;;              (not (eq 'dired-mode mm)))
;;            (eq 'vterm-mode mm)))
;;      (apply func r)))
;;   (advice-add 'centaur-tabs-hide-tab :around
;;               #'dc4ever/centaur-tabs-hide-tab))

(with-eval-after-load 'counsel-projectile
  (defun dc4ever/counsel-projectile-prefer-git nil
      "Try `counsel-git'. If failed,
fall back to `counsel-projectile-find-file'."
    (interactive)
    (or
     (ignore-errors (counsel-git))
     (counsel-projectile-find-file)))
  (spacemacs/set-leader-keys "pf" #'dc4ever/counsel-projectile-prefer-git)
  (spacemacs/set-leader-keys "pF" #'counsel-projectile-find-file))

(with-eval-after-load 'rime
  (register-input-method "rime" "euc-cn" 'rime-activate "韻"))

(eval-when-compile
  (require 'ivy))
(defun dc4ever--ivy-call-always-recenter (func &rest r)
  "Always recenter after `ivy-call', i.e. same functionality
as `ivy-call-and-recenter'."
  (prog1
      (apply func r)
    (when (and
           (not (minibufferp (window-buffer (ivy--get-window ivy-last))))
           (eq 'counsel-rg (ivy-state-caller ivy-last)))
      (with-ivy-window
        (recenter-top-bottom)))))
(advice-add 'ivy-call :around #'dc4ever--ivy-call-always-recenter)
(defalias 'ivy-call-and-recenter 'ivy-call)

(with-eval-after-load 'org
  (unbind-key "C-'" org-mode-map)
  (add-hook 'org-mode-hook
            (lambda nil
              "Turn off `electric-indent-mode' in org buffers"
              (electric-indent-local-mode -1))))

(with-eval-after-load 'prog-mode
  (require 'paredit))

(with-eval-after-load 'text-mode
  (auto-insert-mode 1))

(with-eval-after-load 'counsel
  (defun counsel-search-action (x)
    "Search for X."
    (funcall (if (fboundp 'eaf-open-browser) 'eaf-open-browser 'browse-url)
     (concat
      (nth 2 (assoc counsel-search-engine counsel-search-engines-alist))
      (url-hexify-string x)))))

(setq shell-scripts-backend 'dont-use-lsp)

(defun dc4ever//switch-msg-buf-advice (func &rest r)
  "Force `*Message*' buffer to use `evil-insert-state'; also
set `window-point-insertion-type' to t locally."
  (apply func r)
  (with-current-buffer (messages-buffer)
    (evil-insert-state 1)
    (goto-char (point-max))
    (setq-local window-point-insertion-type t)))

(advice-add #'spacemacs/switch-to-messages-buffer
            :around #'dc4ever//switch-msg-buf-advice)

;; cd-all-the-way
(defcustom dc4ever-cd-all-the-way t
  "Whether to enable cd-all-the-way feature." :type 'boolean)
(defvar dc4ever--cd-all-the-way-flag nil "Internal flag for cd-all-the-way.")

(defun dc4ever//ivy-magic-slash-advice (func &rest r)
  "Set `dc4ever--cd-all-the-way-flag' for `ivy--magic-file-slash'."
  (let ((dc4ever--cd-all-the-way-flag dc4ever-cd-all-the-way))
    (apply func r)))
(advice-add #'ivy--magic-file-slash :around #'dc4ever//ivy-magic-slash-advice)

(defun dc4ever//ivy--cd-advice (func &rest r)
  "Advice `ivy--cd' to do cd-all-the-way."
  (if (not dc4ever--cd-all-the-way-flag) (apply func r)
    (cl-labels ((get-only-dir
                 (dir)
                 (let* ((entries (f-entries dir))
                        (onlyent (when (= 1 (length entries))
                                   (concat (expand-file-name (car entries) dir)
                                           "/"))))
                   (cond
                    ((null onlyent) dir)
                    ((f-dir? onlyent) (get-only-dir onlyent))
                    (t dir)))))
      (funcall func (get-only-dir (car r))))))
(advice-add #'ivy--cd :around #'dc4ever//ivy--cd-advice)

(with-eval-after-load 'cc-mode
  (defun dc4ever//FUCK-Google-indent-BS nil
    "2-space indentation is bull shit!!! Fuck you, Google!!!"
    (add-hook 'hack-local-variables-hook
              (lambda nil
                (when (and (boundp 'fuck-google)
                           fuck-google)
                  (redshift-indent 2))) nil :local))
  (add-hook 'c++-mode-hook #'dc4ever//FUCK-Google-indent-BS)

  (defun dc4ever//unfuck-FUCK-Google (indent)
    "Divide indent by 2 if `fuck-google' is t."
    (if (and (boundp 'fuck-google) fuck-google) (/ indent 2) indent))
  (advice-add #'c-get-syntactic-indentation
              :filter-return #'dc4ever//unfuck-FUCK-Google))

(with-eval-after-load 'python
  (defun dc4ever//disable-ipython (func &rest r)
    "Force `spacemacs/pyenv-executable-find' to return nil
when query ipython"
    (unless (s-equals? "ipython" (car r))
      (apply func r)))
  (advice-add #'spacemacs/pyenv-executable-find
              :around #'dc4ever//disable-ipython))

(with-eval-after-load 'undo-tree
  (defun dc4ever//undo-tree-shutTheFuckUp (func &rest r)
    "Shut your damn mouth, `undo-tree-save-history'"
    (let ((inhibit-message t))
      (apply func r)))
  (advice-add #'undo-tree-save-history
              :around #'dc4ever//undo-tree-shutTheFuckUp))

(provide 'dc4ever-better-defaults)
