;; Bunch of fixes, advice and rewrites of functions

(defun spacemacs//pyenv-mode-set-local-version ()
  (interactive)
  (setenv "PYENV_VERSION" nil)
  (let ((version
         (string-trim (shell-command-to-string "pyenv version-name"))))
    (pyenv-mode-set version)))

(with-eval-after-load 'projectile
  (advice-add 'projectile-ensure-project :filter-return
              (lambda (proj)
                "If `default-directory' is not a project,
call `find-file' to PROJ first. Then call `expand-file-name' to PROJ and return."
                (or (projectile-project-p default-directory) (find-file proj))
                (expand-file-name proj))))

(with-eval-after-load 'zeal-at-point
  (add-to-list 'zeal-at-point-mode-alist '(cmake-mode . "cmake")))

(with-eval-after-load 'counsel-projectile
  (advice-add 'counsel-projectile-switch-project-action
              :around
              (lambda (func proj)
                "Open PROJ in dired mode. Try `counsel-git' first;
If not in a git repo, use plain old `counsel-projectile'"
                (find-file proj)
                (let ((projectile-switch-project-action
                       (lambda nil
                         (or (ignore-errors (counsel-git))
                             (counsel-projectile ivy-current-prefix-arg)))))
                  (counsel-projectile-switch-project-by-name proj)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; `smartparens-mode' & `hippie-expand' conflict work around
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(advice-add 'auto-completion/init-hippie-exp
            :after
            (lambda (&rest r)
              "Use `yas-expand' directly"
              (global-set-key (kbd "M-/") 'yas-expand)))
(advice-add 'spacemacs//smartparens-disable-before-expand-snippet
            :after
            (lambda (&rest r)
              "Seems redundent work around since yas-snippet
has already fixed the very issue."
              (smartparens-mode (if spacemacs--smartparens-enabled-initially 1 -1))))

(provide 'dc4ever-fix)
