;;; dc4ever-hack.el --- Hack & experimental          -*- lexical-binding: t; -*-

;; Copyright (C) 2022  Xiaoxiang Cao

;; Author: Xiaoxiang Cao <xiaoxiangcao@ttwork>
;; Keywords: languages

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Hacks

;;; Code:

(eval-when-compile
  (require 'bind-key)
  (require 'lsp-bridge)
  (require 'lsp-completion)
  (require 'company)
  (require 'rx))

(with-eval-after-load 'lsp-mode
  (require 'awesome-pair)
  (require 'yasnippet)
  (require 'orderless)
  (require 'lsp-bridge)

  (defun dc4ever//lsp-bridge-hack nil
    "Bind keys for `lsp-bridge'."
    (unless (bufferp "*lsp-bridge*")
      (setq lsp-bridge-is-starting nil))
    (lsp-completion-mode -1)
    (lsp-bridge-mode 1)
    (setq company-backends
          '(company-files company-dabbrev))

    (define-key evil-normal-state-local-map
      (kbd ", w r") #'lsp-bridge-restart-process)
    (define-key evil-normal-state-local-map
      (kbd ", r r") #'lsp-bridge-rename)
    (define-key evil-normal-state-local-map
      (kbd ", g r") #'lsp-bridge-find-references)
    (define-key evil-normal-state-local-map
      (kbd ", g g") #'lsp-bridge-find-def)
    (define-key evil-normal-state-local-map
      (kbd "C-]") #'lsp-bridge-find-def)
    (define-key evil-normal-state-local-map
      (kbd "C-t") #'lsp-bridge-return-from-def)

    (pcase major-mode
      ((or 'c-mode 'c++-mode)
       (setq-local lsp-bridge-completion-hide-characters
                   '(";" "(" ")" "[" "]" "{" "}" "," "\""))))

    (message "lsp-mode hacked by lsp-bridge."))

  (defun dc4ever//lsp-bridge-init (ret)
    "Init `lsp-bridge' in a hacky way."
    (when ret
      (run-with-timer 1 nil #'dc4ever//lsp-bridge-hack))
    ret)

  (advice-add #'lsp
              :filter-return #'dc4ever//lsp-bridge-init)

  (defun dc4ever//lsp-bridge-hack-str-pred (func &rest r)
    "Select when to turn on `company-auto-begin'."
    (let ((inhibit-message t))
      (cond
       ((nth 4 (syntax-ppss))
        (company-mode 1)
        nil)
       ((and (or (eq major-mode 'c++-mode)
                 (eq major-mode 'c-mode))
             (eq ?# (char-after (line-beginning-position))))
        (company-mode -1)
        t)
       (t
        (let ((isNotStr (apply func r)))
          (if isNotStr (company-mode -1) (company-mode 1))
          isNotStr)))))

  (advice-add #'lsp-bridge-not-in-string
              :around #'dc4ever//lsp-bridge-hack-str-pred)

  (defun dc4ever//lsp-bridge-fix-ccls-macro-pt-arrow (func &rest r)
    "Temp fix for wrongly inserted \"->\" at `point-min' of current buffer,
until the time when I discover the real bug source."
    (prog1 (apply func r)
      (when (or (eq 'c++-mode major-mode)
                (eq 'c-mode major-mode))
        (let ((pt (1+ (point-min))))
          (when (and (eq ?- (char-before pt))
                     (eq ?> (char-after pt)))
            (delete-region (1- pt) (1+ pt))
            (save-excursion
              (search-backward "." nil t 1)
              (replace-match "->")))))))
  (advice-add #'acm-backend-lsp-candidate-expand
              :around #'dc4ever//lsp-bridge-fix-ccls-macro-pt-arrow)

  (define-key acm-mode-map (kbd "TAB") #'acm-insert-common)
  (define-key acm-mode-map (kbd "C-j") #'acm-select-next)
  (define-key acm-mode-map (kbd "C-k") #'acm-select-prev)

  (defvar dc4ever--should-hack-snippet nil)

  (defun dc4ever//hack-acm-lsp-exp (func &rest r)
    (defvar dc4ever--should-hack-snippet)
    (let ((dc4ever--should-hack-snippet t))
      (apply func r)))
  (advice-add #'acm-backend-lsp-candidate-expand
              :around #'dc4ever//hack-acm-lsp-exp)

  (defun dc4ever//hack-acm-candidate-doc (func &rest r)
    "Hack `acm-backend-lsp-candidate-doc' do display full label in doc."
    (let* ((candidate (car r))
           (doc (plist-get candidate :documentation)))
      (concat (plist-get candidate :label) "\n\n" (if doc doc ""))))
  (advice-add #'acm-backend-lsp-candidate-doc
              :around #'dc4ever//hack-acm-candidate-doc)

  (defun dc4ever/lb-refresh nil
    "Refresh `lsp-bridge' completion"
    (interactive)
    (let ((right (point)) left str)
      (save-excursion
        (re-search-backward (rx (not (any alnum "_"))))
        (setq left (+ 2 (point))))
      (if (= left right)
          (progn (insert ?a)
                 (call-interactively #'delete-backward-char))
        (setq str (buffer-substring-no-properties left right))
        (delete-backward-char (- right left))
        (insert str))))
  (define-key acm-mode-map (kbd "C-s") #'dc4ever/lb-refresh)

  (defun dc4ever//hack-yas (func &rest r)
    (defvar dc4ever--should-hack-snippet)
    (when dc4ever--should-hack-snippet
      (setq r
            (list (save-match-data
                    (replace-regexp-in-string
                     (rx
                      (seq "${"
                           (group (+ digit))
                           ":"
                           (* (not "}"))
                           " "
                           (* (any "*&"))
                           (group (+ (any alnum "_")) "}")))
                     "${\\1:\\2"
                     (car r))))))
    (apply func r))
  (advice-add #'yas-expand-snippet
              :around #'dc4ever//hack-yas))

(provide 'dc4ever-hack)
;;; dc4ever-hack.el ends here
