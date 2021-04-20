;; Better default configurations for me

(eval-after-load 'dash '(dash-enable-font-lock))
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

(treemacs-icons-dired-mode)
(spacemacs/toggle-highlight-long-lines-globally-on)

(with-eval-after-load 'dired
  (treemacs-icons-dired-mode))

(add-to-list 'auto-mode-alist '("\\.ccls\\'" . shell-script-mode))
(add-to-list 'auto-mode-alist '("\\.cu\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.cl\\'" . c-mode))
(add-to-list 'auto-mode-alist '("\\.[pP][dD][fF]\\'" .
                                (lambda nil
                                  (pdf-tools-install)
                                  (pdf-view-mode t))))

(add-hook 'org-mode-hook '(lambda () (setq-local evil-auto-indent nil)))
(with-eval-after-load 'gnus
  (pdf-tools-install)
  (add-hook 'pdf-view-mode-hook 'spacemacs/toggle-mode-line)
  )

(exec-path-from-shell-initialize)

(with-eval-after-load 'company
  (setq company-minimum-prefix-length 1)
  (global-company-mode 1)
  )

(require 'doom-modeline)
(doom-modeline-def-segment minor-modes
  (format-mode-line (and (bound-and-true-p company-mode) company-lighter)))

(evil-set-initial-state 'vterm-mode 'emacs)
;; (evil-set-initial-state 'Custom-mode 'emacs)
(evil-set-initial-state 'sunshine-mode 'emacs)

;; Set unicode for displaying cards
(set-fontset-font t 'playing-cards "DejaVu Sans")
(set-fontset-font t 'symbol "Noto Color Emoji")
(set-fontset-font t 'symbol "Symbola" nil 'append)

(with-eval-after-load 'centaur-tabs
  (defun dc4ever/centaur-tabs-hide-tab (func &rest r)
    "Add more buffers to hide."
    (or
     (let ((mm (with-current-buffer (car r) major-mode)))
       (or (eq 'Info-mode mm)
           (eq 'vterm-mode mm)))
     (apply func r)))
  (advice-add 'centaur-tabs-hide-tab :around
              #'dc4ever/centaur-tabs-hide-tab))

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

(provide 'dc4ever-better-defaults)
