;; -*- lexical-binding: t; -*-

(defvar zeal-at-point-mode-alist)
(defvar dc4ever/capf-prefix?)
(defvar eaf-proxy-host)
(defvar eaf-proxy-port)
(defvar eaf-proxy-type)

(eval-when-compile
  (require 'url)
  (require 'lsp-completion)
  (require 'projectile)
  (require 'zeal-at-point)
  (require 'counsel-projectile)
  (require 'eaf))

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
- We are trying to complete a string
- We are not trying to complete header files"
    (unless (and (and (boundp 'dc4ever/capf-prefix?) dc4ever/capf-prefix?)
                 (eq 'lsp-completion-at-point (car res))
                 (eq 'ccls (lsp--workspace-server-id (car (lsp-workspaces))))
                 (let ((bounds-start (nth 1 res))
                       (header/incl "#include "))
                   (save-excursion
                     (and (nth 3 (syntax-ppss bounds-start))
                          (not (equal "#include "
                                      (buffer-substring-no-properties
                                       (point-at-bol)
                                       (+ (point-at-bol) (length "#include ")))))))))
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
              :filter-return 'dc4ever/filter-capf-lsp-retval)

  (defun dc4ever//fix-macro-pointer-bug (func &rest r)
    "Temp fix for wrongly inserted \"->\" at `point-min' of current buffer,
until the time when I discover the real bug source."
    (prog1 (apply func r)
      (when (eq 'c++-mode major-mode)
        (let ((pt (1+ (point-min))))
          (when (and (eq ?- (char-before pt))
                     (eq ?> (char-after pt)))
            (delete-region (1- pt) (1+ pt))
            (save-excursion
              (search-backward "." nil t 1)
              (replace-match "->")))))))

  ;; (advice-remove #'lsp--apply-text-edit-replace-buffer-contents
  ;;                #'dc4ever//fix-macro-pointer-bug)
  (advice-add #'lsp--apply-text-edit-replace-buffer-contents
              :around #'dc4ever//fix-macro-pointer-bug))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (defun spacemacs//pyenv-mode-set-local-version ()
;;   (interactive)
;;   (setenv "PYENV_VERSION" nil)
;;   (let ((version
;;          (string-trim (shell-command-to-string "pyenv version-name"))))
;;     (pyenv-mode-set version)))

;; (with-eval-after-load 'projectile
;;   (advice-add 'projectile-ensure-project :filter-return
;;               (lambda (proj)
;;                 "If `default-directory' is not a project,
;; call `find-file' to PROJ first. Then call `expand-file-name' to PROJ and return."
;;                 (or (projectile-project-p default-directory) (find-file proj))
;;                 (expand-file-name proj))))

(with-eval-after-load 'zeal-at-point
  (add-to-list 'zeal-at-point-mode-alist '(cmake-mode . "cmake")))

(with-eval-after-load 'counsel-projectile
  (defun dc4ever//switch-proj-advice (func &rest r)
    "Open the most recent opened file when switching to new PROJ."
    (let ((counsel-projectile-switch-project-action
           (lambda (proj)
             (with-current-buffer (get-buffer-create "*scratch*")
               (let ((default-directory proj) err)
                 (let ((f (car (projectile-recently-active-files))))
                   (if f
                       (prog1
                           (find-file f)
                         (when current-prefix-arg
                           (projectile-recentf)))
                     (find-file proj)
                     (dc4ever/counsel-projectile-prefer-git))))))))
      (apply func r)))

  (advice-add 'counsel-projectile-switch-project
              :around #'dc4ever//switch-proj-advice))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; `smartparens-mode' & `hippie-expand' conflict work around
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(advice-add 'spacemacs//smartparens-disable-before-expand-snippet
            :after
            (lambda (&rest r)
              "Seems redundent work around since yas-snippet
has already fixed the very issue."
              (smartparens-mode (if spacemacs--smartparens-enabled-initially 1 -1))))

(with-eval-after-load 'slime
  (setq inferior-lisp-program "sbcl"))

(spacemacs/set-leader-keys "aac" 'eaf-open-camera)
(with-eval-after-load 'eaf
  (defun dc4ever//fix-eaf-focus (&rest r)
    (prog1 (shell-command-to-string
            (concat "wmctrl -i -a "
                    (shell-command-to-string "xdotool getwindowfocus") ))
      (message (concat (propertize "Focus acquired"
                                   'face '(:foreground "orange")) " on %s")
               (prin1-to-string (selected-window)))))
  (advice-add 'eaf--activate-emacs-linux-window :override #'dc4ever//fix-eaf-focus)
  (add-hook 'eaf-mode-hook (lambda nil (defvar rime-show-candidate)
                             (setq-local rime-show-candidate 'minibuffer)
                             (call-interactively #'evil-emacs-state)))
  ;; (advice-remove 'eaf--activate-emacs-linux-window #'dc4ever//fix-eaf-focus)
  (require 'eaf-all-the-icons))

(persp-mode 1)

(provide 'dc4ever-fix)
