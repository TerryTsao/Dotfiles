;; packages
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa-stable" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa-stable/"))
(add-to-list 'package-archives '("marmalade" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/marmalade/"))
(add-to-list 'package-archives '("gnu" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/"))
(add-to-list 'package-archives '("org" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/org/"))

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(defun cd4ever/open-init()
  (interactive)
  (find-file "~/.emacs.d/init.el")
  )

(defun cd4ever/load-init()
  (interactive)
  (load-file "~/.emacs.d/init.el")
  )

(defun cd4ever/planning()
  (interactive)
  (find-file "~/.org/todo.org")
  )

;;;;;;;;;;;;;;;;;; The EVIL rebellion ;;;;;;;;;;;;;;;;;;;;;;;
;; evil mode always run
(use-package evil
  :ensure t)
(require 'evil)
(evil-mode 1)

(use-package evil-leader
  :ensure t)
(require 'evil-leader)
(global-evil-leader-mode)

(evil-leader/set-leader "<SPC>")
(evil-leader/set-key
  "e" 'find-file
  "b" 'switch-to-buffer
  "r" 'recentf-open-files
  "init" 'cd4ever/open-init
  "ll" 'cd4ever/load-init
  "todo" 'cd4ever/planning
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package ivy
  :ensure t)
(require 'ivy)
(ivy-mode 1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package recentf
  :ensure t)
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-item 25)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; packages auto install
;; (use-package auto-complete
  ;; :ensure t)
(use-package magit
  :ensure t)
(use-package org-bullets
  :ensure t)
(use-package color-theme-monokai
  :ensure t)
(use-package solarized-theme
  :ensure t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package company
  :ensure t
  :defer t
  :init
  (global-company-mode)
  :config

  (defun org-keyword-backend (command &optional arg &rest ignored)
    "Company backend for org keywords.

COMMAND, ARG, IGNORED are the arguments required by the variable
`company-backends', which see."
    (interactive (list 'interactive))
    (cl-case command
      (interactive (company-begin-backend 'org-keyword-backend))
      (prefix (and (eq major-mode 'org-mode)
                   (let ((p (company-grab-line "^#\\+\\(\\w*\\)" 1)))
                     (if p (cons p t)))))
      (candidates (mapcar #'upcase
                          (cl-remove-if-not
                           (lambda (c) (string-prefix-p arg c))
                           (pcomplete-completions))))
      (ignore-case t)
      (duplicates t)))
  (add-to-list 'company-backends 'org-keyword-backend)

  (setq company-idle-delay 0.4)
  (setq company-selection-wrap-around t)
  (define-key company-active-map (kbd "ESC") 'company-abort)
  (define-key company-active-map [tab] 'company-complete-common-or-cycle)
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'after-init-hook 'global-company-mode)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; auto complete on
;; (ac-config-default)

;; org-bullets
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(inhibit-startup-screen t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;(load-theme 'solarized-dark)
(color-theme-monokai)

;; Set font size
(set-face-attribute 'default nil :height 170)
