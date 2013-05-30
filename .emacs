;; *.~ とかのバックアップファイルを作らない
(setq make-backup-files nil)
;; .#* とかのバックアップファイルを作らない
(setq auto-save-default nil)
;; 対応するかっこを光らせる
(show-paren-mode 1)
;; カーソル点滅
(blink-cursor-mode t)

(dolist (hook (list
              'scss-mode-hook
              'emacs-lisp-mode-hook
              'ruby-mode-hook
              'lisp-mode-hook
              'c-mode-hook
              'sh-mode-hook
              ))
(add-hook hook (lambda () (linum-mode t))))

(setq-default tab-width 4 indent-tabs-mode nil)
(setq c-default-style "linux")
(if window-system (progn

(set-face-foreground 'font-lock-comment-face "MediumSeaGreen")
(set-face-foreground 'font-lock-string-face "purple")
(set-face-foreground 'font-lock-keyword-face "blue")
(set-face-foreground 'font-lock-function-name-face "blue")
(set-face-bold-p 'font-lock-function-name-face t)
(set-face-foreground 'font-lock-variable-name-face "black")
(set-face-foreground 'font-lock-type-face "LightSeaGreen")
(set-face-foreground 'font-lock-builtin-face "purple")
(set-face-foreground 'font-lock-constant-face "black")
(set-face-foreground 'font-lock-warning-face "blue")
(set-face-bold-p 'font-lock-warning-face nil)

))

(setq load-path
      (append
       (list
        (expand-file-name "~/.emacs.d/")
        )
       load-path))
(setq exec-path (cons (expand-file-name "~/.rvm/gems/ruby-1.9.2-p290/bin/scss") exec-path))

;; slim-mode
(autoload 'slim-mode "slim-mode")
(add-to-list 'auto-mode-alist '("\\.slim\\'" . slim-mode))

;; coffee-mode
(autoload 'coffee-mode "coffee-mode")
(setq coffee-compile-at-save nil) ;; 自動コンパイルをオフにする
(add-to-list 'auto-mode-alist '("\\.coffee\\'" . coffee-mode))
(setq coffeem-indent-level 4)
(setq coffeem-indent-function #'cssm-c-style-indenter)

;; scss-mode
(autoload 'scss-mode "scss-mode")
(setq scss-compile-at-save nil) ;; 自動コンパイルをオフにする
(add-to-list 'auto-mode-alist '("\\.scss\\'" . scss-mode))
(setq scssm-indent-level 4)
(setq scssm-indent-function #'cssm-c-style-indenter)

;; ruby-mode
(autoload 'ruby-mode "ruby-mode"
  "Mode for editing ruby source files" t)
(setq auto-mode-alist
      (append '(("\\.rb$" . ruby-mode)) auto-mode-alist))
(setq interpreter-mode-alist (append '(("ruby" . ruby-mode))
                                     interpreter-mode-alist))

(setq ruby-indent-level 2)
(setq ruby-indent-tabs-mode nil)

(autoload 'run-ruby "inf-ruby"
  "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby"
  "Set local key defs for inf-ruby in ruby-mode")
(add-hook 'ruby-mode-hook
          '(lambda () (inf-ruby-keys)))

;; ruby-electric
(require 'ruby-electric)
(add-hook 'ruby-mode-hook '(lambda () (ruby-electric-mode t)))

;; rubydb
(autoload 'rubydb "rubydb3x"
 "run rubydb on program file in buffer *gud-file*.
the directory containing file becomes the initial working directory
and source-file directory for your debugger." t)

;; ruby-block
;(require 'ruby-block)
;(ruby-block-mode t)
;(setq ruby-block-highlight-toggle t)

;; オートコンプリートモード
(add-to-list 'load-path "/Users/moosan/.emacs.d/")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "/Users/moosan/.emacs.d//ac-dict")
(ac-config-default)
