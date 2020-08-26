;; Bunch of fixes, advice and rewrites of functions

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Fix `company-capf' catching string unwillingly
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(with-eval-after-load 'lsp-completion
  (defun dc4ever/filter-capf-lsp-retval (res)
    "Filter return value to `nil' in the following conditions:
- We are dealing with `company-capf' `pcase' `prefix'
- We are using `lsp-completion-at-point' as capf
- We are using `ccls' as lsp server
- We are trying to complete a string starting with \"
- We are not trying to complete header files"
    (unless (and (and (boundp 'dc4ever/capf-prefix?) dc4ever/capf-prefix?)
                 (eq 'lsp-completion-at-point (car res))
                 (eq 'ccls (lsp--workspace-server-id (car (lsp-workspaces))))
                 (let ((bounds-start (nth 1 res)))
                   (save-excursion
                     (goto-char bounds-start)
                     (unless (= (point) (point-at-bol))
                       (and
                        (not (equal "#include "
                                    (buffer-substring-no-properties
                                     (point-at-bol)
                                     (+ (point-at-bol) (length "#include ")))))
                        (equal "\"" (buffer-substring-no-properties
                                     (- (point) 1) (point))))))))
      res))
  (defun dc4ever/capf-wrapper (func &rest r)
    "Wrap `company-capf' with a special tmp variable `dc4ever/capf-prefix?'
when we are calling with 'prefix command"
    (if (eq 'prefix (car r))
        (let ((dc4ever/capf-prefix? t))
          (apply func r))
      (apply func r)))

  (advice-add 'company-capf
              :around 'dc4ever/capf-wrapper)
  (advice-add 'company--capf-data
              :filter-return 'dc4ever/filter-capf-lsp-retval))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
