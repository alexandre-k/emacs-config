;;; Packages --- Summary

(setq inhibit-startup-message t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(electric-pair-mode 1)
(global-hl-line-mode t)
(global-set-key (kbd "M-=") 'count-words)
(linum-mode t)
(global-auto-revert-mode 1)
;; auto refresh dired when file changes
(add-hook 'dired-mode-hook 'auto-revert-mode)
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq column-number-mode t)
(setq show-trailing-whitespace t)
(setq-default indent-tabs-mode nil)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(blink-cursor-mode 0)
(delete-selection-mode 1) ;; very convenient to paste something and
                          ;; delete a region highlighted at the same time
(defun insert-standard-date ()
  "Inserts standard date time string."
  (interactive)
  (insert (format-time-string "%c")))
(global-set-key (kbd "C-c d") 'insert-standard-date)

(require 'package)
(setq package-enable-at-startup nil)
(unless (assoc-default "melpa" package-archives)
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(use-package which-key
  :ensure t
  :config (which-key-mode))

(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

(defalias 'list-buffers 'ibuffer)

(use-package ace-window :ensure t :init
  (progn
    (global-set-key [remap other-window] 'ace-window)))

(use-package company :ensure t)
(add-hook 'after-init-hook 'global-company-mode)
(setq company-tooltip-align-annotations t)
(add-hook 'prog-mode-hook 'company-mode)
(provide 'init-company-mode)
(use-package company-quickhelp :ensure t)
(setq company-quickhelp-mode t)

(use-package counsel :ensure t)

(use-package swiper
  :ensure t
  :bind (("C-s" . swiper)
	 ("C-r" . swiper)
	 ("C-c C-r" . ivy-resume)
	 ("M-x" . counsel-M-x)
	 ("C-x C-f" . counsel-find-file)
	 ("C-c g" . counsel-git)
         ("C-c j" . counsel-git-grep)
         ("C-c k" . counsel-ag)
	 )
  :config
  (progn
    (ivy-mode 1)
    (setq ivy-use-virtual-buffers t)
    (setq ivy-display-style 'fancy)
    (setq enable-recursive-minibuffers t)
    (define-key read-expression-map (kbd "C-r") 'counsel-expression-history)
    ))

(use-package avy
  :ensure t
  :bind ("M-s" . avy-goto-char-2))

(use-package spacemacs-common
    :ensure spacemacs-theme
    :config (load-theme 'spacemacs-dark t))

(use-package ocodo-svg-modelines
  :ensure t)

(use-package svg-mode-line-themes)
(smt/enable)
(smt/set-theme 'default)

(use-package evil
  :ensure t)
(evil-mode 1)

(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode t))

(use-package flycheck-inline
  :ensure t)
(with-eval-after-load 'flycheck
  (flycheck-inline-mode))

(use-package ace-popup-menu
  :ensure t)
(ace-popup-menu-mode 1)

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(use-package yasnippet
  :ensure t
  :init
    (yas-global-mode 1))

(use-package undo-tree
  :ensure t
  :init
  (global-undo-tree-mode))

(use-package beacon
  :ensure t
  :config
  (beacon-mode 1))

(use-package hungry-delete
  :ensure t
  :config
  (global-hungry-delete-mode))

(use-package expand-region
  :ensure t
  :config
  (global-set-key (kbd "C-=") 'er/expand-region))

(use-package iedit
  :ensure t)

(use-package evil-iedit-state
  :ensure t)

(use-package magit
  :ensure t)

(use-package rainbow-delimiters
  :ensure t)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; (use-package smartparens
;;   :ensure t)
;; (require 'smartparens-config)
;; (add-hook 'prog-mode-hook #'smartparens-mode)

(use-package skewer-mode
  :ensure t)

(use-package csv-mode
  :ensure t)

(use-package json-mode
  :ensure t)

(use-package yaml-mode
  :ensure t)

;; ************************** Ocaml *********************************************
(use-package tuareg
  :ensure t)
;; -- common-lisp compatibility if not added earlier in your .emacs
(require 'cl)

(use-package company
  :ensure t
  :custom
  (company-quickhelp-delay 0)
  (company-tooltip-align-annotations t)
  :hook
  ((prog-mode utop-mode) . company-mode)
  :config
  (company-quickhelp-mode 1)
  :bind
  ("M-o" . company-complete)
  )

(use-package company-quickhelp
  :ensure t
  :bind (:map company-active-map
              ("M-h" . company-quickhelp-manual-begin)))

(defun shell-cmd (cmd)
  "Returns the stdout output of a shell command or nil if the command returned
     an error"
  (car (ignore-errors (apply 'process-lines (split-string cmd)))))

(setq opam-p (shell-cmd "which opam"))
(setq reason-p (shell-cmd "which refmt"))

(if opam-p
    (let ((opam-share (ignore-errors (car (process-lines "opam" "config" "var" "share")))))
      (when (and opam-share (file-directory-p opam-share))
(add-to-list 'load-path (expand-file-name "emacs/site-lisp" opam-share)))))

(use-package reason-mode
  :if reason-p
  :ensure t
  :config
  (let* ((refmt-bin (or (shell-cmd "refmt ----where")
                        (shell-cmd "which refmt")))
         (merlin-bin (or (shell-cmd "ocamlmerlin ----where")
                         (shell-cmd "which ocamlmerlin")))
         (merlin-base-dir (when merlin-bin
                            (replace-regexp-in-string "bin/ocamlmerlin$" "" merlin-bin))))
    ;; Add npm merlin.el to the emacs load path and tell emacs where to find ocamlmerlin
    (when merlin-bin
      (add-to-list 'load-path (concat merlin-base-dir "share/emacs/site-lisp/"))
      (setq merlin-command merlin-bin))
    (when refmt-bin
      (setq refmt-command refmt-bin)))
)


(use-package merlin
  :custom
  (merlin-completion-with-doc t)
  :bind (:map merlin-mode-map
              ("M-." . merlin-locate)
              ("M-," . merlin-pop-stack)
              ("M-?" . merlin-occurrences)
              ("C-c C-j" . merlin-jump)
              ("C-c i" . merlin-locate-ident)
              ("C-c C-e" . merlin-iedit-occurrences)
              )
  :hook
  ;; Start merlin on ml files
  ((reason-mode tuareg-mode caml-mode) . merlin-mode)
  )

(use-package utop
  :custom
  (utop-edit-command nil)
  :hook
  (tuareg-mode . (lambda ()
                   (setq utop-command "utop -emacs")
                   (utop-minor-mode)))
  (reason-mode . (lambda ()
                   (setq utop-command "rtop -emacs")
                   (setq utop-prompt
                         (lambda ()
                           (let ((prompt (format "rtop[%d]> " utop-command-number)))
                             (add-text-properties 0 (length prompt) '(face utop-prompt) prompt)
                             prompt)))
                   (utop-minor-mode)))
)

;; ******************************************************************************


;; ******************** Rust ****************************************************

;; (use-package rust-mode
;;   :ensure t)

;; (use-package cargo
;;   :ensure t)
;; (add-hook 'rust-mode-hook 'cargo-minor-mode)

;; (use-package racer
;;   :ensure t)

;; (setq racer-cmd (concat (getenv "HOME") "/.cargo/bin/racer"))
;; (setenv "RUST_SRC_PATH"
;; 	(concat (getenv "HOME")
;; 		"/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src"))
;; (setq racer-rust-src-path (getenv "RUST_SRC_PATH"))

;; (add-hook 'rust-mode-hook #'racer-mode)
;; (add-hook 'racer-mode-hook #'eldoc-mode)
;; (add-hook 'racer-mode-hook  #'company-mode)

;; (use-package flycheck-rust
;;   :ensure t)
;; (with-eval-after-load 'rust-mode
;;   (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

;; (define-key rust-mode-map (kbd "TAB") #'company-indent-or-complete-common)

;; (add-hook 'rust-mode-hook
;;           '(lambda ()
;;              (local-set-key (kbd "TAB") #'company-indent-or-complete-common)
;; 	     (electric-pair-mode 1)))
;; (setq rust-format-on-save t)

;; (use-package toml-mode
;;   :ensure t)


;; ******************** Python ****************************************************

(use-package elpy
  :ensure t)
(elpy-enable)


;; ******************** Javascript ****************************************************


;; (use-package js2-mode
;;   :ensure t
;;   :mode ("\\.js$" . js2-mode)
;;   :interpreter ("node" . js2-mode))
;; (add-hook 'js2-mode-hook #'js2-imenu-extras-mode)
;; (setq js-indent-level 2)
;; (setq typescript-indent-level 2 typescript-expr-indent-offset 2)

;; (use-package xref-js2
;;   :ensure t)
;; ;; js-mode (which js2 is based on) binds "M-." which conflicts with xref, so
;; ;; unbind it.
;; (define-key js-mode-map (kbd "M-.") nil)

;; (add-hook 'js2-mode-hook (lambda ()
;;   (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t)))

;; (use-package company-tern
;;   :ensure t)
;; (add-to-list 'company-backends 'company-tern)
;; (add-hook 'js2-mode-hook (lambda ()
;;                            (tern-mode)
;;                            (company-mode)))
;; (define-key tern-mode-keymap (kbd "M-.") nil)
;; (define-key tern-mode-keymap (kbd "M-,") nil)


;; ****************** Typescript dev ********************************************

;; (use-package typescript-mode
;;   :ensure t)
;; (add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))

;; (use-package tide
;;   :ensure t)
;; (add-hook 'typescript-mode-hook
;;           (lambda ()
;;             (tide-setup)
;;             (flycheck-mode t)
;;             (setq flycheck-check-syntax-automatically '(save mode-enabled))
;;             (eldoc-mode t)
;;             (company-mode-on)))

;; ******************************************************************************


;; ****************** Solidity ********************************************
;; (use-package solidity-mode
;;   :ensure t)
;; ;
;; ******************************************************************************


;; ***************************** C++ ********************************************

;; (use-package irony-mode
;;   :ensure t)
;; (add-hook 'c++-mode-hook 'irony-mode)
;; (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

;; (use-package company-irony
;;   :ensure t)


;; (use-package company-irony-c-headers
;;   :ensure t)

;; (setq c-default-style "linux"
;;         c-basic-offset 4)

;; (add-hook 'c-mode-common-hook '(lambda () (c-toggle-auto-state 1)))

(use-package cmake-mode
  :ensure t)


;; (load "~/.emacs.d/google-c-style.el")

;; ******************************************************************************
;; (use-package indium
;;   :ensure t)

;; (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))


;; (use-package try
;;   :ensure t)

(use-package haskell-mode
  :ensure t)

(defun haskell-evil-open-above ()
  (interactive)
  (evil-digit-argument-or-evil-beginning-of-line)
  (haskell-indentation-newline-and-indent)
  (evil-previous-line)
  (haskell-indentation-indent-line)
  (evil-append-line nil))

(defun haskell-evil-open-below ()
  (interactive)
  (evil-append-line nil)
  (haskell-indentation-newline-and-indent))

(evil-define-key 'normal haskell-mode-map
  "o" 'haskell-evil-open-below
  "O" 'haskell-evil-open-above)

(use-package flycheck-ghcmod
  :ensure t)

(use-package company-ghc
  :ensure t)


;; Install Intero
(use-package intero
  :ensure t)
(add-hook 'haskell-mode-hook 'intero-mode)

;; (use-package clojure-mode
;;   :ensure t)

;; (use-package cider
;;   :ensure t)

;; (use-package simple-httpd
;;   :ensure t)


;; (defun flycheck-python-setup ()
;;   (flycheck-mode))
;; (add-hook 'python-mode-hook #'flycheck-python-setup)

;; (use-package jedi
;;   :ensure t
;;   :init
;;   (add-hook 'python-mode-hook 'jedi:setup)
;;   (add-hook 'python-mode-hook 'jedi:ac-setup))

;; (use-package rjsx-mode
;;   :ensure t)
;; ;; (add-to-list 'auto-mode-alist '("\\.js\\" . rjsx-mode))
;; ;; (add-to-list 'auto-mode-alist '("\\.jsx\\" . rjsx-mode))
;; (add-hook 'rjsx-mode-hook
;; 	  (lambda ()
;; 	    (setq js-indent-level 2)
;; 	    (setq js2-strict-missing-semi-warning nil)))

;; (use-package eclim
;;   :ensure t)
;; (global-eclim-mode)
;; regular auto-complete initialization

;; add the emacs-eclim source
;; (use-package ac-emacs-eclim-source
;;   :ensure t)
;; (ac-emacs-eclim-config)

;; ******************** Elm and Purescript ****************************************************
(use-package elm-mode
  :ensure t)
(add-to-list 'company-backends 'company-elm)

(use-package purescript-mode
  :ensure t)
(use-package psc-ide
  :ensure t)

(add-hook 'purescript-mode-hook
  (lambda ()
    (psc-ide-mode)
    (company-mode)
    (flycheck-mode)
    (turn-on-purescript-indentation)))
;; (setq psc-ide-use-npm-bin t)

;; (use-package ox-reveal
;;   :ensure ox-reveal)

;; (setq org-reveal-mathjax t)
;; (setq org-reveal-root "http://cdn.jsdelivr.net/reveal.js/3.0.0")

;; (use-package kaolin-themes
;;   :ensure t)
;; (load-theme 'kaolin-valley-dark)


;; *********************** OCaml dev ********************************************
;; (add-to-list 'auto-mode-alist '("\\.ml[iylp]?" . tuareg-mode))
;; (autoload 'tuareg-mode "tuareg" "Major mode for editing OCaml code" t)
;; (autoload 'tuareg-run-ocaml "tuareg" "Run an inferior OCaml process." t)
;; (autoload 'ocamldebug "ocamldebug" "Run the OCaml debugger" t)

;; (use-package ocp-indent
;;   :ensure t)

;; (use-package merlin
;;   :ensure t)

;; ******************************************************************************



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#0a0814" "#f2241f" "#67b11d" "#b1951d" "#4f97d7" "#a31db1" "#28def0" "#b2b2b2"])
 '(company-quickhelp-delay 0)
 '(company-tooltip-align-annotations t)
 '(custom-enabled-themes (quote (spacemacs-dark)))
 '(custom-safe-themes
   (quote
    ("b7d967c53f4e3dfc1f847824ffa3f902de44d3a99b12ea110e0ec2fcec24501d" "4455435a66dba6e81d55a843c9c7e475a7a935271bf63a1dfe9f01ed2a4d7572" "9076ed00a3413143191cb9324d9426df38d83fb6dba595afbd43983db1015ef4" "7e362b29da8aa9447b51c2b354d8df439db33b3612ddd5baa34ad3de32206d83" "c4d3cbd4f404508849e4e902ede83a4cb267f8dff527da3e42b8103ec8482008" "f72ccaa311763cb943de5f9f56a0d53b0009b772f4d05f47835aa08011797aa8" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" default)))
 '(merlin-completion-with-doc t t)
 '(package-selected-packages
   (quote
    (intero flycheck-ghcmod company-ghc purescript-mode cmake-mode cmake-project company-irony-c-headers company-irony-cheaders company-irony irony-server irony-mode irony vue-mode solidity-mode company-tern xref-js2 kaolin-themes ample-theme json-mode yaml-mode smartparens rainbow-delimiters company-quickhelp toml-mode ocodo-svg-modelines flycheck-inline racer company-mode cargo cargo-mode flycheck-rust rust-mode rust tide typescript-mode merlin ocp-indent elm-mode go-mode ac-emacs-eclim-source eclimd eclim meghanada tern-auto-complete tern evil-surround rjsx-mode ghc-mode skewer-mode magit evil-iedit-state iedit expand-region hungry-delete beacon cider clojure-mode elpy ace-popup-menu hydra powerline flycheck-coala flycheck mode-line ox-reveal spacemacs-theme color-theme auto-complete counsel ace-window org-bullets which-key try use-package)))
 '(utop-edit-command nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
