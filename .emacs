(defun system-is-linux ()
    "Linux system checking."
    (interactive)
    (string-equal system-type "gnu/linux"))

(defun system-is-mac ()
    "Mac OS X system checking."
    (interactive)
    (string-equal system-type "darwin"))

(defun system-is-windows ()
    "MS Windows system checking."
    (interactive)
    (string-equal system-type "windows-nt"))

;; Start Emacs server. Require Midnight
(unless (system-is-windows)
    (require 'server)
    (unless (server-running-p)
        (server-start)))
(require 'midnight)

;; User name and e-mail
(setq user-full-name   "Evgeniy Khodakov")
(setq user-mail-adress "e.hodakov@gmail.com")

;; Paths for SBCL
(setq unix-sbcl-bin    "/usr/bin/sbcl")
(setq windows-sbcl-bin "C:/sbcl/sbcl.exe")

;; Package manager
;; Initialise package and add Melpa repository
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t) ;; Репозиторий Melpa
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t) ;; Репозиторий Marmalade

(package-initialize) ;; Инициализируем пакетный менеджер

;; Package list
(defvar required-packages
  '(slime                 ;; Slime - IDE для Common Lisp
    powerline             ;; строка статуса и служебной информации
    projectile            ;; Менеджер проектов
    auto-complete         ;; Автодополнение
    sr-speedbar           ;; открывает буффер с простой навигацией по файловой системе
    ;; zenburn-theme
    php-mode              ;; php
    web-mode              ;; php/html/css/etc
    flycheck              ;; проверка синтаксиса
    yasnippet             ;; сниппеты
    php-auto-yasnippets   ;; сгенерированные сниппеты для php
    tramp                 ;; работа с ssh/ftp
    quickrun              ;; выполнение кода прямо в буфере
    expand-region         ;; умное выделение
    restclient            ;; REST клиент
    ;; пакеты из super-emacs
    helm                  ;; автодополнение всего и вся, продвинутая замена ido
    multiple-cursors      ;; одновременно несколько курсоров как в sublime и textmate
    ace-jump-mode         ;; быстрые переходы по буферу
    switch-window         ;; быстрое переключение между открытми окнами
    buffer-move           ;; быстрое перемещение между буферами
    ;; ztree              ;; дерево каталогов, кажется rs-speedbar удобнее
    undo-tree             ;; продвинутый режим undo/redo
    material-theme        ;; тема
    ;; meta-presenter
    ;; myterminal-controls
    ;; theme-looper
    magit))

;; Require Common Lisp extensions
(require 'cl)

;; Функция реализует проферку факта установки перечисленых выше пакетов:
;; slime, projectile, auto-complete
(defun packages-installed-p ()
    "Packages availability checking."
    (interactive)
    (loop for package in required-packages
          unless (package-installed-p package)
            do (return nil)
          finally (return t)))

;; Автоматическая установка пакетов slime, projectile, auto-complete
;; при первом запуске Emacs
;; Auto-install packages
(unless (packages-installed-p)
    (message "%s" "Emacs is now refreshing it's package database...")
    (package-refresh-contents)
    (message "%s" " done.")
    (dolist (package required-packages)
        (unless (package-installed-p package)
            (package-install package))))

;; Dired
(require 'dired)
(setq dired-recursive-deletes 'top)

;; Imenu
;; (require 'imenu)
;; (setq imenu-auto-rescan      t)
;; (setq imenu-use-popup-menu nil)

;; Display the name of the current buffer in the title
(setq frame-title-format "GNU Emacs: %b")

;; Org-mode
(require 'org)

;; Inhibit startup/splash screen
(setq inhibit-splash-screen   t)
(setq ingibit-startup-message t) ;; экран приветствия можно вызвать комбинацией C-h C-a

;; Show-paren-mode settings
(show-paren-mode t) ;; включить выделение выражений между {},[],()
(setq show-paren-style 'expression) ;; выделить цветом выражения между {},[],()

;; Electric-modes settings
(electric-pair-mode    1) ;; автозакрытие {},[],() с переводом курсора внутрь скобок
(electric-indent-mode -1) ;; отключить индентацию  electric-indent-mod'ом (default in Emacs-24.4)

;; Delete selection
(delete-selection-mode t)

;; Enable winner-mode
(winner-mode t)

;; Enable windmove
(windmove-default-keybindings)

;; Disable GUI components
(tooltip-mode      -1)
(menu-bar-mode     -1) ;; отключаем графическое меню
(tool-bar-mode     -1) ;; отключаем tool-bar
(scroll-bar-mode   -1) ;; отключаем полосу прокрутки
(blink-cursor-mode -1) ;; курсор не мигает
(setq use-dialog-box     nil) ;; никаких графических диалогов и окон - все через минибуфер
(setq redisplay-dont-pause t)  ;; лучшая отрисовка буфера
(setq ring-bell-function 'ignore) ;; отключить звуковой сигнал

;; Fringe settings
(fringe-mode '(8 . 0)) ;; органичиталь текста только слева
(setq-default indicate-empty-lines t) ;; отсутствие строки выделить глифами рядом с полосой с номером строки
(setq-default indicate-buffer-boundaries 'left) ;; индикация только слева

;; Window size. Set font
;; (add-to-list 'default-frame-alist '(width . 120))
;; (add-to-list 'default-frame-alist '(height . 40))
;; (when (member "DejaVu Sans Mono" (font-family-list))
;;     (set-frame-font "DejaVu Sans Mono-11" nil t))
(custom-set-faces '(default ((t (:height 140)))))

;; Disable backup/autosave files
(setq make-backup-files        nil)
(setq auto-save-default        nil)
(setq auto-save-list-file-name nil) ;; я так привык... хотите включить - замените nil на t

;; переносы строк
(setq-default truncate-lines t)
(setq-default global-visual-line-mode t)

;; Coding-system
(set-language-environment 'UTF-8)
(if (or (system-is-linux) (system-is-mac))
    (progn
        (setq default-buffer-file-coding-system 'utf-8)
        (setq-default coding-system-for-read    'utf-8)
        (setq file-name-coding-system           'utf-8)
        (set-selection-coding-system            'utf-8)
        (set-keyboard-coding-system        'utf-8-unix)
        (set-terminal-coding-system             'utf-8)
        (prefer-coding-system                   'utf-8))
    (progn
        (prefer-coding-system                   'windows-1251)
        (set-terminal-coding-system             'windows-1251)
        (set-keyboard-coding-system        'windows-1251-unix)
        (set-selection-coding-system            'windows-1251)
        (setq file-name-coding-system           'windows-1251)
        (setq-default coding-system-for-read    'windows-1251)
        (setq default-buffer-file-coding-system 'windows-1251)))

;; Linum plugin - нумерация строк
(require 'linum) ;; вызвать Linum
(line-number-mode   t)            ;; показать номер строки в mode-line
(global-linum-mode  t)            ;; показывать номера строк во всех буферах
(column-number-mode t)            ;; показать номер столбца в mode-line
(setq linum-format " %d")         ;; задаем формат нумерации строк

;; Display file size/time in mode-line
(setq display-time-24hr-format t) ;; 24-часовой временной формат в mode-line
(display-time-mode             t) ;; показывать часы в mode-line
(size-indication-mode          t) ;; размер файла в %-ах

;; Line wrapping
(setq word-wrap          t) ;; переносить по словам
(global-visual-line-mode t)
(setq-default fill-column 80)

;; IDO plug-in - интерактивный поиск и открытие файлов
;; (require 'ido)
;; (ido-mode                      t)
;; (icomplete-mode                t)
;; (ido-everywhere                t)
;; (setq ido-vitrual-buffers      t)
;; (setq ido-enable-flex-matching t)

;; Buffer Selection and ibuffer settings
;; (require 'bs)
;; (require 'ibuffer)
;; (defalias 'list-buffers 'ibuffer) ;; отдельный список буферов при нажатии C-x C-b

;; Syntax highlighting
(require 'font-lock)
(global-hl-line-mode               t)
(global-font-lock-mode             t)
(setq font-lock-maximum-decoration t)

;; Indentation - отступы
(defalias 'perl-mode 'cperl-mode)
(setq-default indent-tabs-mode nil)
(setq-default tab-width            4)
(setq-default python-indent        4)
(setq-default c-basic-offset       4)
(setq-default standart-indent      4)
(setq-default lisp-body-indent     4)
(setq-default cperl-indent-level   4)
(setq-default python-indent-offset 4)
(setq lisp-indent-function 'common-lisp-indent-function)

;; Scrolling settings - плавный скроллинг
(setq scroll-step               1) ;; вверх-вниз по 1 строке
(setq scroll-margin            10) ;; сдвигать буфер верх/вниз когда курсор в 10 шагах от верхней/нижней границы
(setq scroll-conservatively 10000)

;; Short messages
(defalias 'yes-or-no-p 'y-or-n-p)

;; Clipboard settings
(setq x-select-enable-clipboard t)

;; End of file newlines
(setq require-final-newline    t) ;; добавить новую пустую строку в конец файла при сохранении
(setq next-line-add-newlines nil) ;; не добавлять новую строку в конец при смещении курсора  стрелками

;; Highlight search resaults
(setq search-highlight        t)
(setq query-replace-highlight t)

;; Easy transition between buffers: M-{arrow keys}
(unless (equal major-mode 'org-mode)
    (windmove-default-keybindings 'meta))

(defun format-buffer ()
    "Format buffer."
    (interactive)
    (save-excursion (delete-trailing-whitespace)
                    (unless (equal major-mode 'python-mode)
                        (indent-region (point-min) (point-max)))
                    (unless indent-tabs-mode
                        (untabify (point-min) (point-max))))
    nil)
(add-to-list 'write-file-functions 'format-buffer)

;; Bookmarks
(require 'bookmark)
(setq bookmark-save-flag t)
(when (file-exists-p (concat user-emacs-directory "bookmarks"))
    (bookmark-load bookmark-default-file t))
(setq bookmark-default-file (concat user-emacs-directory "bookmarks"))

;; Skeletons:
;; PHP skeleton
;; (define-skeleton php-skeleton
;;     "PHP initialise skeleton" nil
;;     "<?php\n\n\n"
;;     "?>\n"_)

;; Auto-insert mode
;; (require 'autoinsert)
;; (auto-insert-mode)
;; (setq auto-insert-query nil)
;; (define-auto-insert "\\.php\\'" 'php-skeleton)

;; tramp
(require 'tramp)

(when (packages-installed-p)

    ;; Zenburn color theme
    ;; (load-theme 'zenburn t)

    ;; Material color theme
    (load-theme 'material t)

    ;; Powerline
    (require 'powerline)
    ;;(powerline-default-theme)
    (powerline-center-theme)
    ;; (setq powerline-default-separator 'wave)
    (setq powerline-default-separator 'slant)

    ;; Auto-complete
    (require 'auto-complete)
    (require 'auto-complete-config)
    (ac-config-default)
    (setq ac-auto-start        t)
    (setq ac-auto-show-menu    t)
    (global-auto-complete-mode t)
    (add-to-list 'ac-modes 'lisp-mode)

    ;; SLIME
    (require 'slime)
    (require 'slime-autoloads)
    (setq slime-net-coding-system 'utf-8-unix)
    (slime-setup '(slime-fancy slime-asdf slime-indentation))
    (if (or (file-exists-p unix-sbcl-bin) (file-exists-p windows-sbcl-bin))
        (if (system-is-windows)
            (setq inferior-lisp-program windows-sbcl-bin)
            (setq inferior-lisp-program unix-sbcl-bin))
        (message "%s" "SBCL not found..."))
    (add-to-list 'auto-mode-alist '("\\.cl\\'" . lisp-mode))

    ;; Projectile
    (require 'projectile)
    (projectile-global-mode)

    ;; sr-speedbar
    (require 'sr-speedbar)
    (setq speedbar-show-unknown-files t)                ;; показывать все типы файлов
    (setq speedbar-use-images nil)                      ;; не использовать изображения
    (setq sr-speedbar-right-side nil)                   ;; спидбар слева
    (global-set-key (kbd "<f12>") 'sr-speedbar-toggle)

    ;; php-mode
    (require 'php-mode)

    ;; web-mode
    (require 'web-mode)
    (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

    ;; flycheck
    (add-hook 'after-init-hook #'global-flycheck-mode)

    ;; yasnippet and php-auto-yasnippets
    (require 'yasnippet)
    (yas-global-mode 1)
    (require 'php-auto-yasnippets)
    (setq php-auto-yasnippet-php-program "~/.emacs.d/Create-PHP-YASnippet.php")  ;; скрипт генерации сниппетов
    (payas/ac-setup)                                                             ;; интеграция с auto-complete

    ;; quickrun
    (require 'quickrun)

    ;; expand-region
    (require 'expand-region)
    (global-set-key (kbd "C-=") 'er/expand-region)

    ;; restclient
    (require 'restclient)

    ;; helm
    (require 'helm-config)
    (helm-mode 1)
    (helm-autoresize-mode 1)
    (setq helm-split-window-in-side-p t)
    (global-set-key (kbd "M-x") 'helm-M-x)
    (global-set-key (kbd "C-x b") 'helm-mini)
    (global-set-key (kbd "C-x C-b") 'helm-buffers-list)
    (global-set-key (kbd "C-x C-f") 'helm-find-files)
    (global-set-key (kbd "C-x C-r") 'helm-recentf)
    (global-set-key (kbd "M-y") 'helm-show-kill-ring)

    ;; multiple-cursors
    (require 'multiple-cursors)
    (global-set-key (kbd "C-}") 'mc/mark-next-like-this)
    (global-set-key (kbd "C-{") 'mc/mark-previous-like-this)
    (global-set-key (kbd "C-|") 'mc/mark-all-like-this)

    ;; ace-jump-mode
    (autoload 'ace-jump-mode "ace-jump-mode" "Emacs quick move minor mode" t)
    (autoload 'ace-jump-mode-pop-mark "ace-jump-mode" "Ace jump back :-)" t)
    (global-set-key (kbd "C->") 'ace-jump-mode)
    (global-set-key (kbd "C-<") 'ace-jump-mode-pop-mark)

    ;; switch-window
    (require 'switch-window)
    (global-set-key (kbd "C-x o") 'switch-window)

    ;; buffer-move
    (require 'buffer-move)
    (global-set-key (kbd "C-S-<up>") 'buf-move-up)
    (global-set-key (kbd "C-S-<down>") 'buf-move-down)
    (global-set-key (kbd "C-S-<left>") 'buf-move-left)
    (global-set-key (kbd "C-S-<right>") 'buf-move-right)

    ;;undo-tree
    (require 'undo-tree)
    (global-undo-tree-mode)
    (global-set-key (kbd "M-/") 'undo-tree-visualize))


(setq-default lisp-body-indent 4)
(setq lisp-indent-function 'common-lisp-indent-function)

;; Буфер обмена
;; Включаем использование иксового буфера обмена
(setq x-select-enable-clipboard t)

;; Из консоли предыдущая команда работать не будет. Решается данная проблема
;; с помощью утилиты xsel (её нужно предварительно установить)
(unless window-system
    ;; Callback for when user cuts
    (defun xsel-cut-function (text &optional push)
        ;; Insert text to temp-buffer, and "send" content to xsel stdin
        (with-temp-buffer
            (insert text)
            ;; I prefer using the "clipboard" selection (the one the
            ;; typically is used by c-c/c-v) before the primary selection
            ;; (that uses mouse-select/middle-button-click)
            (call-process-region (point-min) (point-max) "xsel" nil 0 nil "--clipboard" "--input")))
    ;; Call back for when user pastes
    (defun xsel-paste-function()
        ;; Find out what is current selection by xsel. If it is different
        ;; from the top of the kill-ring (car kill-ring), then return
        ;; it. Else, nil is returned, so whatever is in the top of the
        ;; kill-ring will be used.
        (let ((xsel-output (shell-command-to-string "xsel --clipboard --output")))
            (unless (string= (car kill-ring) xsel-output)
                xsel-output )))
    ;; Attach callbacks to hooks
    (setq interprogram-cut-function 'xsel-cut-function)
    (setq interprogram-paste-function 'xsel-paste-function))
