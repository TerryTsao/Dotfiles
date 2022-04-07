;;; dc4ever-uniq.el --- Unique settings according to my daily needs  -*- lexical-binding: t; -*-

;; Copyright (C) 2022  Xiaoxiang Cao

;; Author: Xiaoxiang Cao <xiaoxiangcao@ttwork>
;; Keywords: files

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

;;

;;; Code:

(with-eval-after-load 'prog-mode
  (defun dc4ever//auto-insert nil
    "Handle project specific `auto-insert'."
    (cond
     ((boundp 'miev-perception-style)
      (call-interactively #'evil-insert-state)
      (insert "cpr")
      (call-interactively #'yas-expand)
      (call-interactively #'yas-exit-all-snippets)
      (goto-char (point-max))
      (if (eq ?h (aref (f-ext buffer-file-name) 0))
          (progn
            (insert "\n\n\n")
            (insert "ifg")
            (call-interactively #'yas-expand)
            (call-interactively #'yas-exit-all-snippets))
        (insert "\n\n\n")))
     (t nil)))

  (defun dc4ever//miev-cpr nil
    "Handle project specific copyright notice for `auto-insert'."
    (let* ((f (f-join (f-parent (symbol-file 'dc4ever//auto-insert 'defun))
                      "assets/miev-LICENCE"))
           (s (f-read-text
               (if (f-file? f) f
                 (error "%s is not a proper file!" f)))))
      (setq s (replace-regexp-in-string "^" comment-start s))
      (replace-regexp-in-string " $" "" s)))

  (defun dc4ever//pragma-once nil
    "Defines project specific if guard for `cc-mode' headers."
    (let ((p (file-relative-name default-directory (projectile-project-root)))
          (f (f-filename (buffer-file-name))))
      (when (s-equals? "./" p)
        (setq p ""))
      (upcase (s-join "_"
                      (append
                       (s-split "/" p t)
                       (s-split "\\." f)
                       (list "")))))))

(provide 'dc4ever-uniq)
;;; dc4ever-uniq.el ends here
