;; Better default configurations for me

(eval-after-load 'dash '(dash-enable-font-lock))
(evil-escape-mode -1)
(global-company-mode)
(setq prettify-symbols-unprettify-at-point t)
(global-prettify-symbols-mode)
(setq powerline-default-separator 'arrow)
(setq company-minimum-prefix-length 1)
(add-hook 'emacs-lisp-mode-hook
          (lambda nil
            "This does several things:
- Disable `electric-pair-local-mode'
- Enable `paredit-mode'
- Set using keybindings"
            (electric-pair-local-mode -1)
            (paredit-mode t)
            (local-set-key (kbd "M-l") 'paredit-forward-slurp-sexp)))
(treemacs-icons-dired-mode)
(spacemacs/toggle-highlight-long-lines-globally-on)

(add-to-list 'auto-mode-alist '("\\.ccls\\'" . shell-script-mode))
(add-to-list 'auto-mode-alist '("\\.cu\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.cl\\'" . c-mode))

(add-hook 'org-mode-hook '(lambda () (setq-local evil-auto-indent nil)))
(add-hook 'pdf-view-mode-hook 'spacemacs/toggle-mode-line)
(pdf-tools-install)
(exec-path-from-shell-initialize)

(with-eval-after-load 'doom-modeline
  (require 'company)
  (doom-modeline-def-segment minor-modes
    (format-mode-line (and (bound-and-true-p company-mode) company-lighter))))

(evil-set-initial-state 'vterm-mode 'emacs)
(evil-set-initial-state 'sunshine-mode 'emacs)

(spacemacs/set-leader-keys "pf"
  (lambda ()
    (interactive)
    (or
     (ignore-errors (counsel-git))
     (counsel-projectile-find-file))))

;; Set unicode for displaying cards
(set-fontset-font t 'playing-cards "DejaVu Sans")
(set-fontset-font t 'symbol "Noto Color Emoji")
(set-fontset-font t 'symbol "Symbola" nil 'append)

(provide 'dc4ever-better-defaults)
