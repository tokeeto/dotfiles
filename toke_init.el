(setq inhibit-startup-message t)

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

	(use-package ivy
      :diminish
	  :bind (("C-F" . swiper)
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
	    (ivy-mode 1)
	)
	(use-package all-the-icons)

	(use-package doom-modeline
	  :init (doom-modeline-mode 1)
	  :custom ((doom-modeline-height 54))
	)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay .2))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :bind (
         ("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
           ("C-r" . 'counsel-minibuffer-history)
        )
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


(global-unset-key (kbd "C-SPC"))
(use-package general
  :config
  (general-create-definer ivo/leader-keys
    :prefix "C-SPC")

  (ivo/leader-keys
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme"))
  )

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/workspace")
    (setq projectile-project-search-path '("~/workspace")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(setq-default truncate-lines t)

	(setq visible-bell t)
	(set-face-attribute 'default nil :font "Victor Mono" :height 110)
	(load-theme 'wombat t)
	(when (display-graphic-p) 
    	(use-package doom-themes)
		(load-theme 'doom-dracula t))
	(global-linum-mode t)               ;; Enable line numbers globally

	;; Org Mode Configuration ------------------------------------------------------
	(defun efs/org-font-setup ()
	;; Set faces for heading levels
	  (dolist (face '((org-level-1 . 1.2)
          (org-level-2 . 1.1)
          (org-level-3 . 1.05)
          (org-level-4 . 1.0)
          (org-level-5 . 1.1)
          (org-level-6 . 1.1)
          (org-level-7 . 1.1)
          (org-level-8 . 1.1)))
	   )

    ;; Ensure that anything that should be fixed-pitch in Org files appears that way
    (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
	(set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
	(set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
	(set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
	(set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
	(set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
	(set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

(use-package org
  :hook (org-mode . efs/org-mode-setup)
  :config
  (setq org-ellipsis " ▼"
        org-hide-emphasis-markers t)
  (efs/org-font-setup))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "⦾" "⦿" "○" "●")))

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))

;; enable CUA mode (ctrl-c/v/x/z for copy, paste, cut, undo
;; use shift+ctrl+ c/v/x/z for standard emacs behavior
(cua-mode t)
(setq cua-keep-region-after-copy t) ;; Standard Windows behaviour

;; make cursor movement stop in between camelCase words. (don't)
(global-subword-mode 0)

;; Always highlight matching parenthesis. This is a necessity when using multiple-cursors because
;;  if show-paren-mode is disabled, typing multiple closing parentheses takes a long time due to
;;  the pause to highlight after each one
(show-paren-mode 1)

;; make typing delete/overwrite selected text
(delete-selection-mode 1)

;; remember cursor position, for emacs 25.1 or later
(save-place-mode 1)

;; Automatically revert buffers if file changes underneath (unless there are unsaved changes)
(global-auto-revert-mode 1)

;; Store recently opened files so we can easily reopen them
(recentf-mode 1)
;; Store more recent files
(setq recentf-max-saved-items 100)

;;
;; Tabs and indentation
;;
;; Delete tabs instead of converting them to spaces
(setq backward-delete-char-untabify-method nil)
;; From https://dougie.io/emacs/indentation (with some modifications
;; Two callable functions for enabling/disabling tabs in Emacs
(defun disable-tabs ()
  (interactive)
  (setq indent-tabs-mode nil))

(defun enable-tabs ()
  (interactive)
  ;; (local-set-key (kbd "TAB") 'tab-to-tab-stop)
  (setq indent-tabs-mode t)
  (setq tab-width 4))

;; Hooks to Enable Tabs
(add-hook 'c-mode-hook 'enable-tabs)
(add-hook 'c++-mode-hook 'enable-tabs)
(add-hook 'lua-mode-hook 'enable-tabs)
(add-hook 'python-mode-hook 'enable-tabs)
(add-hook 'lisp-mode-hook 'disable-tabs)
(add-hook 'emacs-lisp-mode-hook 'disable-tabs)
(add-hook 'org-mode 'enable-tabs)

(defun ivo-insert-tab ()
    "Make it possible to easily input raw tabs instead of having to do C-q <tab>"
    (interactive)
    (insert "	"))

  ;(global-set-key (kbd "<tab>") 'ivo-insert-tab)

  ;; Ctrl shift P like sublime for commands
  ;; Added alt P for console, was nil
  (use-package smex)
(global-set-key (kbd "C-P") 'smex)
(global-set-key (kbd "M-p") 'smex)

  
  ;; Close. was kill-region
  (global-set-key (kbd "C-w") 'kill-this-buffer)

  ;; Select All. was move-beginning-of-line
  (global-set-key (kbd "C-a") 'mark-whole-buffer)

  ;; Open. was open-line
  (global-set-key (kbd "C-o") 'ido-find-file)

  ;; Save. was isearch-forward
  (global-set-key (kbd "C-s") 'save-buffer)

  ;; Find. was forward-char
  (global-set-key (kbd "C-f") 'isearch-forward)

  ;; Switch buffers. Was backward-char
  (global-set-key (kbd "C-b") 'ido-switch-buffer)

  ;; Open ibuffer (good for killing many buffers)
  (global-set-key (kbd "M-w") 'kill-buffer)

  ;; Switch windows via ctrl tab
  (global-set-key (kbd "C-<tab>") 'other-window)
  (global-set-key (kbd "C-S-<tab>") 'previous-multiframe-window)

  ;; Find file in project (via projectile) was previous-line
  (global-set-key (kbd "C-p") 'projectile-find-file)

  ;; Toggle comment lines (same keybind as Sublime). This also works for regions
  (global-set-key (kbd "C-'") 'comment-line)

  (defun macoy-kill-subword ()
    "Temporarily enable subword mode to kill camelCase subword"
    (interactive)
    (subword-mode 1)
    (call-interactively 'kill-word)
    (subword-mode 0))

  (defun macoy-kill-subword-backward ()
    "Temporarily enable subword mode to kill camelCase subword"
    (interactive)
    (subword-mode 1)
    (call-interactively 'backward-kill-word)
    (subword-mode 0))

  (global-set-key (kbd "M-<delete>") 'macoy-kill-subword)
  (global-set-key (kbd "M-<backspace>") 'macoy-kill-subword-backward)

  ;; jump to function (was reverse search)
  (global-set-key (kbd "C-r") 'imenu)

  ;; Occur
  (define-key occur-mode-map (kbd "<f3>") 'occur-next)
  (define-key occur-mode-map (kbd "S-<f3>") 'occur-prev)

  ;; Move to beginning/end of function
  ;; TODO: This is a little too disorienting. It should only recenter if the line
  ;; is near the bottom or top (i.e. the function scrolled the window, losing your place)
  (global-set-key (kbd "M-<up>") 'beginning-of-defun)
  (global-set-key (kbd "M-<down>") 'end-of-defun)
  (global-set-key (kbd "C-<prior>") 'beginning-of-defun)
  (global-set-key (kbd "C-<next>") 'end-of-defun)

  ;; Window management
  ;; Split horizonal (was transpose-chars)
  (global-set-key (kbd "C-t") 'split-window-horizontally)
  (global-set-key (kbd "M-t") 'split-window-vertically)
  (global-set-key (kbd "C-S-w") 'delete-window)

  ;; Replace all of a tag in all files
  (global-set-key (kbd "M-a") 'tags-query-replace)

  ;;
  ;; Multiple cursors
  ;;
  (when (require 'multiple-cursors)
    ;; Make sure to change this in my-keys-minor-mode-map too
    (global-set-key (kbd "C-d") 'mc/mark-next-like-this)
    ;;(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
    (global-set-key (kbd "M-<f3>") 'mc/mark-all-like-this)
    ;; Adds one cursor to each line in the current region.
	(global-set-key (kbd "C-l") 'mc/edit-lines)

	(define-key mc/keymap (kbd "C-d") 'mc/skip-to-next-like-this)
	;; Make <return> insert a newline; multiple-cursors-mode can still be disabled with C-g.
    (define-key mc/keymap (kbd "<return>") nil)
    ;; Clear these so that expand-region can have them
    (define-key mc/keymap (kbd "C-'") nil)
    (define-key mc/keymap (kbd "C-\"") nil)
    ;;(define-key mc/keymap (kbd "C-SPC") 'mc-hide-unmatched-lines-mode)

    ;; Ignore wrapping when doing motions in multiple-cursors
    (define-key mc/keymap (kbd "<end>") 'end-of-line)
    (define-key mc/keymap (kbd "<down>") 'next-logical-line)
    (define-key mc/keymap (kbd "<up>") 'previous-logical-line)
  )

  (defun move-text-down (arg)
    "Move region (transient-mark-mode active) or current line arg lines down."
    (interactive "*p")
    (move-text-internal arg))

  (defun move-text-up (arg)
    "Move region (transient-mark-mode active) or current line arg lines up."
    (interactive "*p")
    (move-text-internal (- arg)))

  (global-set-key [(meta up)]  'move-text-up)
  (global-set-key [(meta down)]  'move-text-down)

  (setq org-support-shift-select 't)

  ;; Ctrl-g as Goto-line, was Quit
  (global-set-key (kbd "C-g") 'goto-line)

;; Hide toolbar
(tool-bar-mode -1)
(toggle-scroll-bar -1)
(menu-bar-mode -1)

;; Set cursor to I-beam
(modify-all-frames-parameters (list (cons 'cursor-type '(bar . 2))))

;; Scrolling
;; https://www.emacswiki.org/emacs/SmoothScrolling
(setq mouse-wheel-scroll-amount '(2 ((shift) . 2))) ;; Two lines at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling


;; Make scrolling less jumpy: this makes it so emacs never centers the cursor if you go scroll off
;;  screen, instead, it will scroll by one line. This isn't ideal (smooth-scrolling is ideal), but
;;  performance is more important in this case
;(setq scroll-step 1)
;(setq scroll-conservatively 10000)
;; This causes next-line to be ridiculously slow when turned on, so I've disabled it
(setq auto-window-vscroll nil)

;; Instead of wrapping at character, wrap at word. This slightly improves readability
(setq visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow))
(global-visual-line-mode -1)

;; Toggle off wrapping (useful for multiple-cursors operations)
(defun macoy-toggle-wrapping ()
  "Toggle line wrapping for the current buffer"
  (interactive)
  (toggle-truncate-lines)
)

;; --- LATE ---
;; This should be executed after custom-set-variables

;;
;; Macoy's custom theme overrides
;; These give emacs a more minimal, less contrast-y appearance
;; I put it down here so it happens after custom-set-variables sets the theme

;; Whole-window transparency
;; The first number is transparency while active
;; The second number is transparency while inactive
(defun macoy-normal-transparency ()
  (interactive)
  (set-frame-parameter (selected-frame) 'alpha '(95 95)))
(defun macoy-no-transparency ()
  (interactive)
  (set-frame-parameter (selected-frame) 'alpha '(100 100)))

;; Note that names need to be unique (they should be anyways)
(setq macoy-transparency-list (list
                               '(95 90)
                               '(80 75)
                               '(90 85)
                               '(100 100)))

(setq macoy-transparency-index 0)
(defun macoy-cycle-transparency (&optional index)
  (interactive)
  (if index
      (setq macoy-transparency-index index)
    (setq macoy-transparency-index (+ macoy-transparency-index 1)))
  ;; Loop around
  (unless (< macoy-transparency-index (safe-length macoy-transparency-list))
    (setq macoy-transparency-index 0))
  (let ((transparency-settings (nth macoy-transparency-index macoy-transparency-list)))
    (set-frame-parameter (selected-frame) 'alpha transparency-settings)
    (message "Transparency now %s" transparency-settings)))

;; Set default transparency
(macoy-cycle-transparency 0)
(global-set-key (kbd "<f9>") 'macoy-cycle-transparency)

;; Add a slight border to give us some breathing room on the edges
(set-frame-parameter (selected-frame) 'internal-border-width 10)

(set-face-foreground 'escape-glyph (face-foreground 'font-lock-warning-face))

;; Bad whitespace display
(setq-default show-trailing-whitespace t)
;; Ensure whitespace isn't shown in e.g. ido vertical (the ido-specific hooks didn't do the trick)
(add-hook 'minibuffer-inactive-mode-hook (lambda () (setq show-trailing-whitespace nil)))
(add-hook 'compilation-mode-hook (lambda () (setq show-trailing-whitespace nil)))
(add-hook 'eshell-mode-hook (lambda () (setq show-trailing-whitespace nil)))

(set-face-foreground 'trailing-whitespace (face-foreground 'font-lock-comment-delimiter-face))
(set-face-background 'trailing-whitespace (face-foreground 'font-lock-comment-delimiter-face))

;; Update default python to 3
(setq python-shell-interpreter "python3")

;; Elpy
(elpy-enable)
(setq elpy-rpc-python-command "python3")

;; Enable Flycheck
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

(setq-default indent-tabs-mode t)
(setq-default tab-width 4)
(setq indent-line-function #'insert-tab)
(setq python-indent-guess-indent-offset t)
