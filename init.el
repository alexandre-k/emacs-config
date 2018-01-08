(setq inhibit-startup-message t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(electric-pair-mode 1)
(global-hl-line-mode t)
(global-set-key (kbd "M-=") 'count-words)
(linum-mode t)
(setq make-backup-files nil)
(setq auto-save-default nil) 


(require 'package)
(setq package-enable-at-startup nil)
(unless (assoc-default "melpa" package-archives)
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(use-package try
  :ensure t)

(use-package which-key
  :ensure t
  :config (which-key-mode))

(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(setq indo-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

(defalias 'list-buffers 'ibuffer)

(use-package ace-window
  :ensure t
  :init
  (progn
    (global-set-key [remap other-window] 'ace-window)
    ))

(use-package counsel
  :ensure t
  )

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

(use-package auto-complete
  :ensure t
  :init
  (progn
    (ac-config-default)
    (global-auto-complete-mode t)
    ))

(use-package spacemacs-theme
  :ensure t
  :config (load-theme 'spacemacs-dark))

(use-package ox-reveal
  :ensure ox-reveal)

(setq org-reveal-mathjax t)
(setq org-reveal-root "http://cdn.jsdelivr.net/reveal.js/3.0.0")

;; (use-package powerline
;;   :ensure t)
;; (powerline-center-evil-theme)
(use-package spaceline
  :demand t
  :init
  (setq powerline-default-separator 'arrow-fade)
  :config
  (require 'spaceline-config)
  (spaceline-spacemacs-theme))


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

(defun flycheck-python-setup ()
  (flycheck-mode))
(add-hook 'python-mode-hook #'flycheck-python-setup)

(use-package jedi
  :ensure t
  :init
  (add-hook 'python-mode-hook 'jedi:setup)
  (add-hook 'python-mode-hook 'jedi:ac-setup))

(use-package ace-popup-menu
  :ensure t)
(ace-popup-menu-mode 1)

(use-package elpy
  :ensure t)
(elpy-enable)

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

(use-package ghc-mode
  :ensure t)

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(use-package clojure-mode
  :ensure t)

(use-package cider
  :ensure t)

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

(use-package indium
  :ensure t)

(use-package js2-mode
  :ensure t
  :mode ("\\.js$" . js2-mode)
  :interpreter ("node" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

(use-package skewer-mode
  :ensure t)

(use-package simple-httpd
  :ensure t)

(use-package csv-mode
  :ensure t)

(use-package col-highlight
  :ensure t)

(use-package rjsx-mode
  :ensure t)
(add-to-list 'auto-mode-alist '(".*\.js'" . rjsx-mode))
(add-hook 'rjsx-mode-hook
	  (lambda ()
	    (setq indent-tabs-mode nil)
	    (setq js-indent-level 2)
	    (setq js2-strict-missing-semi-warning nil)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#0a0814" "#f2241f" "#67b11d" "#b1951d" "#4f97d7" "#a31db1" "#28def0" "#b2b2b2"])
 '(custom-enabled-themes (quote (spacemacs-dark)))
 '(custom-safe-themes
   (quote
    ("3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" default)))
 '(package-selected-packages
   (quote
    (evil-surround rjsx-mode col-highlight-flash col-highlight ghc-mode skewer-mode magit evil-iedit-state iedit expand-region hungry-delete beacon cider clojure-mode elpy ace-popup-menu hydra powerline flycheck-coala flycheck mode-line ox-reveal spacemacs-theme color-theme auto-complete counsel ace-window org-bullets which-key try use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
