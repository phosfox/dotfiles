
(setq inhibit-startup-message t)
(add-to-list 'default-frame-alist '(ns-appearance . dark))
(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room

(menu-bar-mode -1)            ; Disable the menu bar

;; Set up the visible bell
(setq visible-bell nil)
;; Do not ring bell
(setq ring-bell-function 'ignore)
(set-face-attribute 'default nil :font "Fira Code" :height 150)

;; Highlight current line
(global-hl-line-mode -1)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Do not create backup files
(setq-default backup-inhibited t)
(setq create-lockfiles nil)

(toggle-frame-maximized)

(setq modus-themes-bold-constructs t)
(setq modus-themes-paren-match '(bold intense))
(setq modus-themes-region '(bg-only))
(load-theme 'modus-operandi t)

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)


(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))



(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done) 
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(setq ivy-use-virtual-buffers t)
;(setq ivy-count-format "(%d/%d)")

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 10)))

(use-package all-the-icons)

;(use-package doom-themes
;  :init (load-theme 'doom-ayu-dark t))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))


(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.5))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history)))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("631c52620e2953e744f2b56d102eae503017047fb43d65ce028e88ef5846ea3b" default))
 '(package-selected-packages
   '(amx lsp-ivy lsp-treemacs company-box company evil-nerd-commenter lsp-ui typescript-mode lsp-mode evil-magit magit key-chord hydra evil-collection evil general all-the-icons helpful which-key use-package rainbow-delimiters ivy-rich doom-themes doom-modeline counsel))
 '(warning-suppress-types '((comp))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))


(use-package general
  :config
  (general-create-definer rune/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC"))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-undo-system 'undo-redo)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-nerd-commenter
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))

(use-package key-chord)
(key-chord-mode 1)
(key-chord-define evil-insert-state-map "jk" #'evil-normal-state)


(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

(cond
 ((string-equal system-type "darwin")
  (setq mac-command-modifier 'meta
	mac-option-modifier 'none
	default-input-method "MacOSX")))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/code")
    (setq projectile-project-search-path '("~/code")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package amx
  :ensure t
  :after ivy
  :config (amx-mode 1))

(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(defun efs/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

;;LSP
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . efs/lsp-mode-setup)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

(use-package lsp-treemacs
  :after lsp)

(use-package lsp-ivy)

;;Typescript
(use-package typescript-mode
  :mode "\\.tsx?$"
  :hook (typescript-mode . lsp-deferred)
  :config
  (setq typescript-indent-level 2))

;;Company
(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))

;;Custom Commands
(defun switch-to-previous-buffer ()
  "Switch to previously open buffer. Repeated invocations toggle between the two most recently open buffers."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))

;;Keybinds
(general-define-key
  :keymaps '(normal insert emacs)
  "M-p" 'projectile-find-file)

(rune/leader-keys
    "" nil
    "SPC" '(counsel-M-x :which-key "Counsel-M-x")
    "." '(counsel-find-file :which-key "Find file")
    "*" '(counsel-projectile-rg  :which-key "Find in Project")
    "," '(switch-to-previous-buffer :which-key "Switch to previous buffer")
    "TAB" '(switch-to-previous-buffer :which-key "Switch to previous buffer")
    "<" '(counsel-switch-buffer :which-key "Show all buffers")
    "x" '(switch-to-scratch-buffer :which-key "Switch to *scratch* buffer")
    "d" '(dired :which-key "Open dired")
    "g" '(magit :which-key "Open magit")
    "t" '(neotree-toggle :which-key "Toggle neotree")
    "p" '(:keymap projectile-command-map :which-key "Projectile commands")
    "c" '(:ignore t :which-key "Code commands")
    "s" '(swiper :which-key "Swiper")
    "c l" '(:keymap lsp-command-map :package lsp-mode :which-key "LSP commands")
    "c d" '(lsp-find-definition :which-key "LSP find definition")
    "c r" '(lsp-find-references :which-key "LSP find references")
    "c f" '(yafolding-hide-element :which-key "Fold block")
    "c u" '(yafolding-show-element :which-key "Unfold block")
    "p a" '(projectile-add-known-project :which-key "Add new project")
    "b" '(:ignore t :which-key "Buffers")
    "b k" '(kill-current-buffer :which-key "Kill buffer")
    "b r" '(revert-buffer :which-key "Revert buffer")
    "w" '(:ignore t :which-key "Window management")
    "w v" '(split-window-right :which-key "Split window vertically")
    "w s" '(split-window-below :which-key "Split window horizontally")
    "w h" '(evil-window-left :which-key "Move to left window")
    "w j" '(evil-window-down :which-key "Move to lower window")
    "w k" '(evil-window-up :which-key "Move to upper window")
    "w l" '(evil-window-right :which-key "Move to right window")
    "w q" '(evil-window-delete :which-key "Delete a window")
    "w o" '(delete-other-windows :which-key "Delete all other windows")
    "f" '(:ignore t :which-key "File operations")
    "f s" '(save-buffer :which-key "Save Buffer")
    ;"f h" '(open-emacs-home :which-key "Open emacs.d folder")
    ;"f c" '(open-emacs-settings :which-key "Open emacs settings.org")
    "q" '(:ignore t :whick-key "Quit Emacs")
    "q q" '(save-buffers-kill-terminal :which-key "Quit Emacs"))
