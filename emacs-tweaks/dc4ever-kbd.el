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

(with-eval-after-load 'vterm
  (add-hook 'vterm-mode-hook
            (lambda nil
              (define-key vterm-mode-map (kbd "C-v") 'vterm-send-C-v)
              (define-key vterm-mode-map (kbd "C-c C-z") 'vterm-send-C-z))))

(global-set-key (kbd "M-/") 'yas-expand)

(provide 'dc4ever-kbd)
