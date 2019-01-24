;; Intended for GNU Emacs, but might work on other Emacs variants too.
;; Feel free to copy, distribute, and make modifications to this file.

;; KDE users: If you use this .emacs file and find that the background
;; color is black except where there is text (then the background
;; color is white), then you need to go to Control Center | Look &
;; Feel | Style.  Then, uncheck the box labeled "Apply fonts and
;; colors to non-KDE apps."  Then, restart KDE.  Depending on your
;; version of KDE, the steps described here might be different.

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ns-command-modifier (quote meta))
 '(package-selected-packages (quote (dash magit scala-mode2)))
 '(user-emacs-directory-warning nil))

(set 'my-user-name (getenv "USER"))

(if (eq system-type 'darwin)
    (set 'my-home (concat "/Users/" my-user-name))
  (if (eq system-type 'windows-nt)
      (set 'my-home (concat "C:/Users/" my-user-name))
    (set 'my-home (concat "/home/" my-user-name))))

(set 'my-emacs-home (file-truename (concat my-home "/.emacs.d")))
(set 'my-vendor-path (concat my-emacs-home "/vendor"))
(add-to-list 'load-path my-vendor-path)

(message my-home)
(message my-emacs-home)
(message my-vendor-path)

(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)
;; (setq-default TeX-Pdf-mode t)

(setq default-fill-column 79)
(setq default-tab-width 4)
(require 'column-marker)
(require 'psvn)
(require 'cmake-mode)
(require 'rst)
(require 'yasnippet)
(require 'dropdown-list)

(autoload 'adoc-mode "adoc-mode" nil t)
(autoload 'yaml-mode "yaml-mode" nil t)

; make searches case insensitive
(setq case-fold-search t)

(ido-mode)
(yas/initialize)

(setq-default indent-tabs-mode nil)

(add-to-list 'load-path (concat my-vendor-path "/neotree"))
(yas/load-directory (concat my-vendor-path "/snippets"))
(setq default-directory (concat my-home "/code"))
(setq temporary-file-directory (concat my-home "/.emacs.tmp"))

(unless (file-exists-p temporary-file-directory)
  (make-directory temporary-file-directory))

; (require 'neotree)
; (global-set-key [f8] 'neotree-toggle)
(setq yas/prompt-functions '(yas/dropdown-prompt
 			                    yas/ido-prompt
					              yas/completing-prompt))

;; Start quietly
(setq inhibit-startup-message t)


(global-set-key "\C-x\C-o" 'other-window)
(global-set-key "\C-c\C-k" 'edit-kbd-macro)
(global-set-key "\C-x\C-k" 'kill-this-buffer)
(global-set-key "\C-c>" 'py-shift-region-right)
(global-set-key "\C-c<" 'py-shift-region-left)
;; (global-set-key "\C-c\C-g" 'grep-find)
;; (global-set-key [?\C-x ?\C-1] 'delete-other-windows)
;; (global-set-key [?\C-x ?\C-2] 'split-window-vertically)
(global-set-key [M-up] 'backward-paragraph)
(global-set-key [M-down] 'forward-paragraph)
(global-set-key [C-tab] 'other-window)
(global-set-key [M-s] 'search-forward-regexp)
(global-set-key [M-r] 'search-backward-regexp)


;; Remove menubar
(menu-bar-mode 0)
(scroll-bar-mode -1)

;; if using a graphical window (ie. not using -nw)(
(if window-system
    (progn

      ;; Remove graphical toolbar (if version 21 or higher)
      (if (> emacs-major-version 20)
	  (tool-bar-mode 0))

      ;; If Emacs "hangs" for a few seconds while starting, you might have
      ;; to comment out or change the following line that tries to set the
      ;; font to a fixed width font:
      ;; (set-default-font "monaco")
      ;; (set-default-font "9x15")  ;; high resolution monitor, bigger fonts
      ;; (set-default-font "-xos4-terminus-medium-r-normal--14-140-72-72-c-80-iso8859-1")
      ;; (set-default-font "Terminus-12")
      (set-default-font (getenv "EMACS_FONT"))

      ;; don't show tooltips
      (if (or (and (> emacs-major-version 20)
		   (> emacs-minor-version 0))
	      (> emacs-major-version 21))
	  (tooltip-mode 0))

      ;; show entire file path in frame title
      (setq frame-title-format "Emacs - %f")

      ;; use mouse wheel to scroll
      (if (> emacs-major-version 20)
	  (mouse-wheel-mode t))

      ;; Default: scroll with middle,  page-up with left click, page down with right
      ;; Scroll with left mouse button
      ;; This only works with the plain scroll bar, not the Xaw3d variety
      (global-set-key [vertical-scroll-bar down-mouse-1] 'scroll-bar-drag)

      ;; Page down with middle button
      (global-set-key [vertical-scroll-bar mouse-2] 'scroll-bar-scroll-up)
      (global-set-key [vertical-scroll-bar drag-mouse-2] 'scroll-bar-scroll-up)
      (global-unset-key [vertical-scroll-bar down-mouse-2])

      ;; Page up with right button
      (global-set-key [vertical-scroll-bar mouse-3] 'scroll-bar-scroll-down)
      (global-set-key [vertical-scroll-bar drag-mouse-3] 'scroll-bar-scroll-down)

      ;; basic colors
      (set-background-color "black")
      (set-foreground-color "white")
      (set-cursor-color "white")

       (setq default-frame-alist '((cursor-type . box)
				  (width . 100)
				  (height . 80)))

      ;; modeline colors
      ;; (set-face-background 'modeline "gray")
      ;; (set-face-foreground 'modeline "black")

      ;;  (mouse-avoidance-mode 'animate) ;; Cool...but annoying

      ))  ;; end if window-system


;; ----File associations----
(setq auto-mode-alist
      (append '(("\\.C$"     . c++-mode)
                ("\\.cc$"    . c++-mode)
                ("\\.cpp$"   . c++-mode)
                ("\\.cxx$"   . c++-mode)
                ("\\.hxx$"   . c++-mode)
                ("\\.hh$"    . c++-mode)
                ("\\.idl$"   . c++-mode)
                ("\\.c$"     . c-mode)
                ("\\.h$"     . c++-mode)
                ("\\.cg$"    . c-mode)    ; nvidia cg
                ("\\.java$"  . java-mode)
                ("\\.adoc$"  . adoc-mode)
                ("\\.asciidoc$"  . adoc-mode)
				("\\.pyx\\'" . cython-mode)
				("\\.pxd\\'" . cython-mode)
				("\\.pxi\\'" . cython-mode)
				("CMakeLists\\.txt\\'" . cmake-mode)
				("\\.cmake\\'" . cmake-mode)
				("\\.cu\\'" . c++-mode)
				("\\.m$"     . octave-mode)
				("\\.html$"  . html-mode)
				("\\.htm$"   . html-mode)
				;; ("\\.xml$"   . sgml-mode)
				("\\.\\(xml\\|xsl\\|rng\\|xhtml\\)\\'" . nxml-mode)
				("\\.log$"   . text-mode)
				;; ("\\.sty$"   . latex-mode)
				;; ("\\.tex$"   . latex-mode)
				;; ("\\.latex$" . latex-mode)
				("\\.diff$"  . diff-mode)
				("\\.patch$" . diff-mode)
				("\\.txt$"   . doc-mode)
                ("\\.yaml$"  . yaml-mode)
                ("\\.yml$"  . yaml-mode))
              auto-mode-alist))

(prefer-coding-system 'utf-8)

;; To use manually: M-x doc-mode
;; a mode designed for editing text file documents that contain a lot
;; of text to spell check, etc.
(defun doc-mode ()
  (interactive)
  (text-mode)       ;; use regular text mode
  (auto-fill-mode)  ;; wrap lines
  ;; (refill-mode)  ;; wrap lines (more aggressive)
  (flyspell-mode))  ;; underline misspelled words
                    ;; run M-x flyspell-buffer for it to underline all
                    ;; words in the file instead of the words your
                    ;; cursor moves over.


;; ----Programming mode settings----
;; If you want to change indention of your code, go to the place in code
;; where indention is wrong and press C-C C-o to see the symbol you need
;; to change.
;; I prefer that curly braces are put on the line after the loop statement
;; and that it is lined up with the statement.  The following reflects
;; this preference.

;; change this variable to be how much you want to indent
;; when in a programming mode below
(setq my-indent-width 4)

;; Set up java mode
(add-hook 'java-mode-hook
          '(lambda ()
	     ;; automatically indent when return is pressed while coding
	     (define-key java-mode-map "\C-m" 'newline-and-indent)

             (c-set-style "BSD")
             (setq c-basic-offset my-indent-width)
             (c-set-offset 'inline-open 0)
	     (c-set-offset 'case-label 'my-indent-width)
	     (c-set-offset 'substatement 'my-indent-width)
	     (set (make-local-variable 'compile-command)
             (concat "javac " buffer-file-name))))

;; NOTE:  To call gmake in a different directory other than
;; the current one, try
;; "gmake -C /home/user/my-c-stuff"
;; in place of
;; (concat "gmake " buffer-file-name)

;; Set up C mode
;; (add-hook 'c-mode-hook
;;           '(lambda ()
;; 	     ;; automatically indent when return is pressed while coding
;; 	     (define-key c-mode-map "\C-m" 'newline-and-indent)

;;              (c-set-style "BSD")
;;              (setq c-basic-offset my-indent-width)
;; 			 (setq indent-tabs-mode nil)
;;              (c-set-offset 'inline-open 0)
;; 	     (c-set-offset 'case-label 'my-indent-width)
;;              (set (make-local-variable 'compile-command)
;;              (concat "gmake " buffer-file-name))))

;; ;; Set up c++ mode
;; (add-hook 'c++-mode-hook
;;           '(lambda ()
;; 			 ;; automatically indent when return is pressed while coding
;;              (set (make-local-variable 'compile-command)
;; 				  (concat "gmake " buffer-file-name))))


;; Conforming to Google C/C++ Style for Cloudera
(require 'google-c-style)

;; C tweaks for Impala
(defconst my-cc-style
  '("Google" (c-offsets-alist .
                              (
                               (innamespace . [0])
                            ;; (arglist-cont-nonempty . 4)
                            ;; (arglist-intro . 4)
                            (access-label . -1)
                            (member-init-intro . 4)
                            )
                           )))
(c-add-style "my-cc-style" my-cc-style)
(defun set-my-cc-style () (interactive) (google-set-c-style) (c-set-style "my-cc-style"))
(add-hook 'c-mode-common-hook 'set-my-cc-style)

(require 'clang-format)
(global-set-key [C-M-Return] 'clang-format-region)

;; turn on fly spell in latex mode by default.
;; run M-x flyspell-buffer for it to underline all
;; words in the file instead of the words your
;; cursor moves over.
(add-hook 'latex-mode-hook
	  '(lambda ()
	     (set (make-local-variable 'compile-command)
		  (concat "latex " buffer-file-name))
	     (flyspell-mode)
	     (TeX-PDF-mode)))

(add-hook 'TeX-mode-hook '(lambda () (TeX-PDF-mode 1)))

;; FIX ENUM CLASS in > C++0x

(defun inside-class-enum-p (pos)
  "Checks if POS is within the braces of a C++ \"enum class\"."
  (ignore-errors
    (save-excursion
      (goto-char pos)
      (up-list -1)
      (backward-sexp 1)
      (looking-back "enum[ \t]+class[ \t]+[^}]+"))))

(defun align-enum-class (langelem)
  (if (inside-class-enum-p (c-langelem-pos langelem))
      0
    (c-lineup-topmost-intro-cont langelem)))

(defun align-enum-class-closing-brace (langelem)
  (if (inside-class-enum-p (c-langelem-pos langelem))
      '-
    '+))

(defun fix-enum-class ()
  "Setup `c++-mode' to better handle \"class enum\"."
  (add-to-list 'c-offsets-alist '(topmost-intro-cont . align-enum-class))
  (add-to-list 'c-offsets-alist
               '(statement-cont . align-enum-class-closing-brace)))

(add-hook 'c++-mode-hook 'fix-enum-class)
(add-hook
 'c++-mode-hook
 '(lambda()
    ;; We could place some regexes into `c-mode-common-hook', but note that their evaluation order
    ;; matters.
    (font-lock-add-keywords
     nil '(;; complete some fundamental keywords
           ("\\<\\(void\\|unsigned\\|signed\\|char\\|short\\|bool\\|int\\|long\\|float\\|double\\)\\>" . font-lock-keyword-face)
           ;; namespace names and tags - these are rendered as constants by cc-mode
           ("\\<\\(\\w+::\\)" . font-lock-function-name-face)
           ;;  new C++11 keywords
           ("\\<\\(alignof\\|alignas\\|constexpr\\|decltype\\|noexcept\\|nullptr\\|static_assert\\|thread_local\\|override\\|final\\)\\>" . font-lock-keyword-face)
           ("\\<\\(char16_t\\|char32_t\\)\\>" . font-lock-keyword-face)
           ;; PREPROCESSOR_CONSTANT, PREPROCESSORCONSTANT
           ("\\<[A-Z]*_[A-Z_]+\\>" . font-lock-constant-face)
           ("\\<[A-Z]\\{3,\\}\\>"  . font-lock-constant-face)
           ;; hexadecimal numbers
           ("\\<0[xX][0-9A-Fa-f]+\\>" . font-lock-constant-face)
           ;; integer/float/scientific numbers
           ("\\<[\\-+]*[0-9]*\\.?[0-9]+\\([ulUL]+\\|[eE][\\-+]?[0-9]+\\)?\\>" . font-lock-constant-face)
           ;; c++11 string literals
           ;;       L"wide string"
           ;;       L"wide string with UNICODE codepoint: \u2018"
           ;;       u8"UTF-8 string", u"UTF-16 string", U"UTF-32 string"
           ("\\<\\([LuU8]+\\)\".*?\"" 1 font-lock-keyword-face)
           ;;       R"(user-defined literal)"
           ;;       R"( a "quot'd" string )"
           ;;       R"delimiter(The String Data" )delimiter"
           ;;       R"delimiter((a-z))delimiter" is equivalent to "(a-z)"
           ("\\(\\<[uU8]*R\"[^\\s-\\\\()]\\{0,16\\}(\\)" 1 font-lock-keyword-face t) ; start delimiter
           (   "\\<[uU8]*R\"[^\\s-\\\\()]\\{0,16\\}(\\(.*?\\))[^\\s-\\\\()]\\{0,16\\}\"" 1 font-lock-string-face t)  ; actual string
           (   "\\<[uU8]*R\"[^\\s-\\\\()]\\{0,16\\}(.*?\\()[^\\s-\\\\()]\\{0,16\\}\"\\)" 1 font-lock-keyword-face t) ; end delimiter

           ;; user-defined types (rather project-specific)
           ("\\<[A-Za-z_]+[A-Za-z_0-9]*_\\(type\\|ptr\\)\\>" . font-lock-type-face)
           ("\\<\\(xstring\\|xchar\\)\\>" . font-lock-type-face)
           ))))

;; always prompt for compile command
(setq compilation-read-command t)

;; Press M-1 to compile
(global-set-key "\M-1" 'compile)
;; (global-set-key [f5] 'flymake-display-err-menu-for-current-line)


;;----Color set up----
;; Turn on pretty font colors
(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)
;; (lazy-lock-mode)

;; Scroll faster, colors won't appear correctly right away
;; (setq lazy-lock-defer-on-scrolling t)

(setq search-highlight t)                ; incremental search highlights
(setq query-replace-highlight t)         ; highlight during query

;; set highlight color
(set-face-background 'region "MidnightBlue")

;; Isearch highlight colors
(copy-face 'default  'isearch)
(set-face-background 'isearch "DarkGreen")
(set-face-foreground 'isearch "white")

;; Isearch lazy highlight colors
;; (if (> emacs-major-version 20)
;;    (progn (set-face-background 'isearch-lazy-highlight-face "DimGray")
;;	   (set-face-foreground 'isearch-lazy-highlight-face "white")))

;; Some new colors for font-lock
;; For list of colors, use M-x list-colors-display
;; The "nil 1" after the make-face-italic and make-face-bold
;; prevents errors from being reported (I saw this problem
;; with Emacs 20.7.2 in -nw mode).  The errors don't appear
;; on 21.2.1
(copy-face 'default  'font-lock-string-face)
(make-face-italic 'font-lock-string-face nil 1)
(set-face-foreground 'font-lock-string-face "green3")

(copy-face 'default  'font-lock-variable-name-face)
(set-face-foreground 'font-lock-variable-name-face "sky blue")

(copy-face 'default  'font-lock-preprocessor-face)
(set-face-foreground 'font-lock-preprocessor-face "dark turquoise")

(copy-face 'default  'font-lock-comment-face)
(set-face-foreground 'font-lock-comment-face "Tan")

(copy-face 'default  'font-lock-function-name-face)
(make-face-bold 'font-lock-function-name-face nil 1)
(set-face-foreground 'font-lock-function-name-face "Coral")

(copy-face 'default  'font-lock-keyword-face)
(set-face-foreground 'font-lock-keyword-face "deep sky blue")

(copy-face 'default  'font-lock-type-face)
(make-face-bold 'font-lock-type-face nil 1)
(set-face-foreground 'font-lock-type-face "LimeGreen")

(copy-face 'default  'font-lock-reference-face)
(set-face-foreground 'font-lock-reference-face "LightSkyBlue1")

(copy-face 'default  'font-lock-doc-string-face)
(make-face-italic 'font-lock-doc-string-face nil 1)
(set-face-foreground 'font-lock-doc-string-face "wheat")

(copy-face 'default  'font-lock-constant-face)
(set-face-foreground 'font-lock-constant-face "cornflower blue")

(copy-face 'default  'font-lock-type-name-face)
(make-face-italic 'font-lock-type-name-face nil 1)
(set-face-foreground 'font-lock-type-name-face "Red")

(copy-face 'default  'font-lock-builtin-face)
(make-face-bold 'font-lock-builtin-face nil 1)
(set-face-foreground 'font-lock-builtin-face "OrangeRed3")

(copy-face 'default  'show-paren-match-face)
(set-face-background 'show-paren-match-face "dim gray")

(copy-face 'default  'show-paren-mismatch-face)
(set-face-background 'show-paren-mismatch-face "magenta")

(copy-face 'default  'minibuffer-prompt)
(make-face-bold 'minibuffer-prompt nil 1)
(set-face-foreground 'minibuffer-prompt "LemonChiffon")

(copy-face 'default  'ediff-even-diff-face-A)
(set-face-foreground 'ediff-even-diff-face-A "white")
(set-face-background 'ediff-even-diff-face-A "SlateGray4")

(copy-face 'default  'ediff-odd-diff-face-A)
(set-face-foreground 'ediff-odd-diff-face-A "white")
(set-face-background 'ediff-odd-diff-face-A "SteelBlue4")

(copy-face 'ediff-even-diff-face-A 'ediff-even-diff-face-B)
(copy-face 'ediff-odd-diff-face-A 'ediff-odd-diff-face-B)
(copy-face 'ediff-even-diff-face-A 'ediff-odd-diff-face-C)
(copy-face 'ediff-odd-diff-face-A 'ediff-odd-diff-face-C)

(copy-face 'default 'ediff-current-diff-face-A)
(set-face-foreground 'ediff-current-diff-face-A "white")
(set-face-background 'ediff-current-diff-face-A "IndianRed4")

(copy-face 'default 'ediff-current-diff-face-B)
(set-face-foreground 'ediff-current-diff-face-B "white")
(set-face-background 'ediff-current-diff-face-B "sienna4")

(copy-face 'default 'ediff-current-diff-face-C)
(set-face-foreground 'ediff-current-diff-face-C "white")
(set-face-background 'ediff-current-diff-face-C "firebrick4")

(copy-face 'default 'ediff-fine-diff-face-A)
(set-face-foreground 'ediff-fine-diff-face-A "white")
(set-face-background 'ediff-fine-diff-face-A "SpringGreen4")

(copy-face 'ediff-fine-diff-face-A 'ediff-fine-diff-face-B)
(copy-face 'ediff-fine-diff-face-A 'ediff-fine-diff-face-C)

;; Turn on selection
(setq transient-mark-mode 't highlight-nonselected-windows 't)

;; Emacs is silly
;; (when (fboundp 'zone)
;;  (require 'zone)
;;  (setq zone-idle 10) ;; seconds to wait till zoning
;;  (zone-when-idle 10)
;;  )



;;----Delete/Backspace settings----
;; Delete deleted char right of cursor
(global-set-key [delete] 'delete-char)
(global-set-key [(shift backspace)] 'delete-char)

;; Backspace deletes previous char
(global-set-key [backspace] 'delete-backward-char)
(global-set-key [(shift delete)] 'delete-backward-char)

;; helpful when using emacs with "-nw" over ssh.
;; (global-set-key "\C-h" 'delete-backward-char)

;; Change help command to [F1]  (it is usually C-h)
(global-set-key [f1] 'help-command)

;; Pressing backspace during an Isearch will delete the previous
;; character typed (or do a reverse isearch if something matches the
;; current word).  Without this, it will delete the highlighted text.
(define-key isearch-mode-map [backspace] 'isearch-delete-char)


;;----Modeline settings----
;; Show 24-hour time and date on status bar
;; (setq display-time-24hr-format t)
;; (setq display-time-day-and-date t)
;; (display-time)

;; Show line and column number
(line-number-mode 1)
(column-number-mode 1)



;;----Misc stuff----
(when (= emacs-major-version 20)
  ;; resize the miniwindow if required
  (resize-minibuffer-mode 1))

;; Enable completions
(load-library "completion")
(initialize-completions)

;; Don't beep at me
(setq visible-bell t)

;; Replace highlighted/marked areas
(delete-selection-mode t)

;; show paren matches
(setq blink-matching-paren t)
(setq show-paren-delay 0)
(show-paren-mode t)

;; Typing "yes" or "no" takes too long---use "y" or "n"
(fset 'yes-or-no-p 'y-or-n-p)



;;----Moving around---
;; Scroll one line at a time
(setq scroll-step 1)

;; Don't insert new lines when scrolling
(setq next-line-add-newlines nil)

;; Set C-c, g to goto-line
(global-set-key "\C-cg" 'goto-line)

;; Set up home/end keys
(global-set-key [end] 'end-of-buffer)
(global-set-key [home] 'beginning-of-buffer)

;; Moving around more easily
(global-set-key [C-right] 'forward-word)
(global-set-key [C-left] 'backward-word)


;;----Ediff stuff----
;; Use M-x ediff-buffers or M-x ediff-files to compare two files
;; don't open up new window
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

;; show files side by side
(setq ediff-split-window-function 'split-window-horizontally)

;; use a wide window
(add-hook 'ediff-startup-hook 'ediff-toggle-wide-display)

;; ignore differences in whitespace
(setq ediff-diff-options "-w")


;;----Shell stuff----

;; hide passwords
(add-hook 'comint-output-filter-functions 'comint-watch-for-password-prompt)

;; Don't show ^M when on windows machines in plain shell mode
(add-hook 'comint-output-filter-functions 'comint-strip-ctrl-m)

;; truncate shell buffer to comint-buffer-maximum-size
(add-hook 'comint-output-filter-functions 'comint-truncate-buffer)

;; set maximum-buffer size for shell-mode
(setq comint-buffer-maximum-size 10240)

;; don't allow shell prompt to be erased
(setq comint-prompt-read-only "y")

(copy-face 'default 'comint-highlight-prompt)
(set-face-foreground 'comint-highlight-prompt "firebrick1")
(set-face-background 'comint-highlight-prompt "black")


;; Shell mode: M-x shell
;; If you don't like this try: M-x eshell
;;
;; In order to supress the color codes from being displayed as "junk"
;; on the screen, you'll probably want like this at the bottom of one
;; of your dot files for your shell (if you use bash,
;; /home/user/.bashrc):
;;
;; # If you want to check to see if you are running a shell inside of
;; Emacs in bash shell scripts, use the following if statement:
;;
;; if [ $EMACS ]; then
;;    TERM=dumb;
;;    PS1="[\u@\h \W]\$ "   # normal prompt
;;    alias ls='ls -F'      # no colors for ls
;; else
;;    alias ls='ls -F --color=tty'
;; fi
;;


;; Actually display colors when programs output colored text.  Without
;; this command, emacs prints the actual control characters.
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(add-hook 'shell-mode-hook
      (setq tab-width 2)
	  (function (lambda ()
		      (setq comint-scroll-to-bottom-on-input t)
		      (setq comint-scroll-to-bottom-on-output t)
		      (setq comint-scroll-show-maximum-output t)
		      (compilation-shell-minor-mode)
		      (rename-buffer "shell" t))))

(add-hook 'gdb-mode-hook
	  (function (lambda ()
		      (setq comint-scroll-to-bottom-on-input t)
		      (setq comint-scroll-to-bottom-on-output t)
		      (setq comint-scroll-show-maximum-output t))))

;; If a shell is already open, it will pop up.
;; If a shell isn't open yet, open one and make it pop up
(defun to-shell ()
  (interactive)
  (setq shell-is-open 0)

  ;; check for buffer named shell
  (mapcar (lambda (buffer)
	    (if (string-equal (buffer-name buffer) "shell")
		(setq shell-is-open 1)))
	    (buffer-list))

  ;; if shell isn't open, open one up, bury it
  (if (= shell-is-open 0)
      (progn
	(shell)
	(bury-buffer)))

  ;; pop the shell so it takes up part of screen
  (pop-to-buffer "shell"))

;; Press M-2 to get shell
(global-set-key "\M-2" 'to-shell)


;;----Saving Files----
;; Put a newline at end of file if it isn't there.
;; (setq require-final-newline t)

(defun strip-eol-whitespace ()
    (interactive)
    (save-excursion          ;; don't move cursor
      (beginning-of-buffer)  ;; start at top of buffer
      (replace-regexp "[ \t]+$" ""))) ;; strip spaces & tabs

;; Strip whitespace at end of lines when saving.
;; WARNING: Might be a BAD idea with some files!
;(add-hook 'write-file-hooks
;  (function
;   (lambda ()
;     (strip-eol-whitespace))))

;;(save-excursion          ;; don't move cursor
;;       (beginning-of-buffer)  ;; start at top of buffer
;;       (replace-regexp "[ \t]+$" ""))))) ;; strip spaces & tabs

;; Replace all tabs with spaces when saving.
;; WARNING: Can cause problems with makefiles
;; (add-hook 'write-file-hooks
;;     (function (lambda () (untabify (point-min) (point-max)))))


;; Don't make backup files
(setq make-backup-files nil backup-inhibited t)

;; backup files
(setq backup-directory-alist
			`((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
			`((".*" ,temporary-file-directory t)))

(message "Deleting old backup files...")
(let ((week (* 60 60 24 7))
      (current (float-time (current-time))))
  (dolist (file (directory-files temporary-file-directory t))
    (when (and (backup-file-name-p file)
               (> (- current (float-time (fifth (file-attributes file))))
                  week))
      (message "%s" file)
      (delete-file file))))

;; auto-save stuff
;; (setq auto-save-interval 100)
;; (setq auto-save-timeout nil)
;; (setq auto-save-list-file-prefix ".saves/")
;; backup version stuff
;; (setq version-control t)
;; (setq kept-old-versions 3)
;; (setq kept-new-versions 5)
;; (setq delete-old-versions t)



;;----Custom functions----
;; Remove tabs from entire buffer
(defun untabify-buffer ()
    (interactive)
    (untabify (point-min) (point-max)))

;; converts <, >, and & to &lt;, &gt; &amp
(defun html-tag-escape (point mark)
  (interactive "*r")
  (if (< (mark) (point))
      (exchange-point-and-mark))
  (save-restriction
    (narrow-to-region point mark)
    (save-excursion
      (while (search-forward "\&" nil t)
	(replace-match "&amp;" nil t)))
    (save-excursion
      (while (search-forward "<" nil t)
	(replace-match "&lt;" nil t)))
    (save-excursion
      (while (search-forward ">" nil t)
	(replace-match "&gt;" nil t)))))

;; reverse of html-tag-escape
(defun html-tag-unescape (point mark)
  (interactive "*r")
  (if (< (mark) (point))
      (exchange-point-and-mark))
  (save-restriction
    (narrow-to-region point mark)
    (save-excursion
      (while (search-forward "&lt;" nil t)
	(replace-match "<" nil t)))
    (save-excursion
      (while (search-forward "%gt;" nil t)
	(replace-match "<" nil t)))
    (save-excursion
      (while (search-forward "&amp;" nil t)
	(replace-match "&" nil t)))))


;; Prints the string "string" "n" times.
(defun repeat-insert (n string)
  (while (> n 0)
    (insert string)
    (setq n (- n 1))))


;; Uncomment region (undos comment-region command)
(define-key global-map "\C-c\C-v" 'uncomment-region)


;; makes nice C comments in the form:
;; /* * * * * * * * * * * * * *
;;  *
;;  *
;;  *
;;  * * * * * * * * * * * * * */
;;
;; If called with no selection, a comment 'template'
;; will be printed to the buffer.  Otherwise, the selection
;; will be put inside of the comment
(define-key global-map "\C-cb" 'block-comment-region)
(defun block-comment-region (mark point)
(interactive "*r")
  (if (and mark-active (not (char-equal (mark) (point))))
      (progn   ;; if there is a selection
	(if (< (mark) (point))
	    (exchange-point-and-mark))
	(fill-individual-paragraphs (point) (mark))
	(prefix-region (point) (mark) " * ") ;; put this at the beginning of lines
	(goto-char (point))  (insert "/") (repeat-insert 39 "* " ) (insert "\n")
	(goto-char (mark)) (end-of-line) (insert "\n")  (repeat-insert 39 " *" ) (insert "/")(forward-line)
	(deactivate-mark)
	(message ""))   ;; don't show how many things were replaced
    (progn ;; if there isn't a selection, just do a template
      (goto-char (point))
      (insert "/") (repeat-insert 39 "* ") (insert "\n")
      (repeat-insert 3 " * \n")
      (repeat-insert 39 " *") (insert "/\n")
      (forward-line -4) (end-of-line))))

;; makes nice C comments in the form:
;; /*
;;  *
;;  */
;;
;; If called with no selection, a comment 'template'
;; will be printed to the buffer.  Otherwise, the selection
;; will be put inside of the comment
(define-key global-map "\C-cl" 'long-comment-region)
(defun long-comment-region (mark point)
  (interactive "*r")
  (if (and mark-active (not (char-equal (mark) (point))))
      (progn   ;; if there is a selection
	(if (< (mark) (point))
	    (exchange-point-and-mark))
	(fill-individual-paragraphs (point) (mark))
	(prefix-region (point) (mark) " * ") ;; put this at the beginning of lines
	(goto-char (point)) (insert "/*\n") ;; beginning of comment
	(goto-char (mark)) (end-of-line) (insert "\n */") ;; end of comment
	(forward-line)
	(deactivate-mark)
	(message ""))   ;; don't show how many things were replaced
    (progn ;; if there isn't a selection, just do a template
      (goto-char (point))
      (insert "/*\n * \n */")
      (forward-line -1) (end-of-line))))

(defun prefix-region (point mark string)
  "Prefix the region between [point] and [mark] with [string]"
  (interactive "*r\nsPrefix: ")
  (save-excursion
    (save-restriction
      (narrow-to-region point mark)
        (replace-regexp "^" string))))


;; don't wrap long lines, M-x no-wrap
(defun no-wrap()
  (interactive)
  (progn
    ;; truncate lines if they are too long
    (setq truncate-lines t)

    ;; trucate even even when screen is split into multiple windows
    (setq truncate-partial-width-windows nil)

    ;; load auto-show (shows lines when cursor moves to right of long line)
    (require 'auto-show)
    (auto-show-mode 1)

    ;; position cursor to end of output in shell mode
    (auto-show-make-point-visible)
    ))

;; wrap long lines, M-x wrap
(defun wrap()
  (interactive)
  (setq truncate-lines nil))

;; To convert file types:  C-x RET f type RET
;; Or, use one of the following functions
(defun unix () ;; M-x unix
  "Use UNIX line endings"
  (interactive)
  (set-buffer-file-coding-system 'undecided-unix))

(defun dos () ;; M-x dos
  "Use DOS line endings"
  (interactive)
  (set-buffer-file-coding-system 'undecided-dos))

(defun mac () ;; M-x mac
  "Use MAC line endings"
  (interactive)
  (set-buffer-file-coding-system 'undecided-mac))




(defun swap-values (symbol1 symbol2)
  "Swap the values of SYMBOL1 and SYMBOL2.
Return the former value of SYMBOL1, the final value of SYMBOL2."
  (let ((x (symbol-value symbol1)))
    (set symbol1 (symbol-value symbol2))
    (set symbol2 x)))

(defun transpose-regions-allow-empty (startr1 endr1 startr2 endr2 &optional
leave-markers)
  "Like `transpose-regions', but allow empty regions."
  (if (> startr1 endr1)
      (swap-values 'startr1 'endr1))
  (if (> startr2 endr2)
      (swap-values 'startr2 'endr2))
  (if (> startr1 startr2)
      (progn (swap-values 'startr1 'startr2)
             (swap-values 'endr1 'endr2)))
  (if (= startr1 endr1)
      (setq endr1 startr2))
  (if (= startr2 endr2)
      (setq startr2 endr1))
  (if (and (/= startr1 endr1) (/= startr2 endr2))
      (transpose-regions startr1 endr1 startr2 endr2 leave-markers)))

(defun shuffle-regions (regions &optional leave-markers)
  "Randomly permute REGIONS given as a list of (BEG . END) cells.

The caller must ensure
 (i)   the regions don't overlap,
 (ii)  BEG is never greater than END,
 (iii) the regions are listed in the reverse order they appear in the buffer.

See `transpose-regions' for LEAVE-MARKERS."
  (let ((n (length regions)))
    (while (> n 1)
      (let ((r (random n)))
        (if (zerop r)
            (setq regions (cdr regions))
          (let* ((a (car regions)) (b (elt regions r))
                 (x (- (- (cdr a) (car a)) (- (cdr b) (car b)))))
            (transpose-regions-allow-empty
             (car a) (cdr a) (car b) (cdr b) leave-markers)
            (setq regions (cdr regions))
            (let ((iter regions))
              (while iter
                (let ((i (car iter)))
                  (if (eq i b)
                      (progn (setcdr i (+ x (cdr i)))
                             (setq iter nil))
                    (setcar i (+ x (car i)))
                    (setcdr i (+ x (cdr i)))))
                (setq iter (cdr iter)))))))
      (setq n (1- n)))))

(defun shuffle-lines (beg end)
  "Randomly permute lines in region."
  (interactive "r")
  (save-excursion
    (save-restriction
      (narrow-to-region beg end)
      (goto-char (point-min))
      (let (lines)
        (while (not (eobp))
          (let ((beg (point)))
            (end-of-line)
            (let ((end (point)))
              (setq lines (cons (cons beg end) lines))))
          (forward-line))
        (shuffle-regions lines t)))))

;;;; `Cython' mode.

(define-derived-mode cython-mode python-mode "Cython"
  (font-lock-add-keywords
   nil
   `((,(concat "\\<\\(NULL"
               "\\|c\\(def\\|har\\|typedef\\)"
               "\\|e\\(num\\|xtern\\)"
               "\\|float"
               "\\|in\\(clude\\|t\\)"
               "\\|object\\|public\\|struct\\|type\\|union\\|void\\|cpdef"
               "\\)\\>")
      1 font-lock-keyword-face t))))


(defun kill-whitespace ()
  "Kill the whitespace between two non-whitespace characters"
  (interactive "*")
  (save-excursion
    (save-restriction
      (save-match-data
	(progn
	  (re-search-backward "[^ \t\r\n]" nil t)
	  (re-search-forward "[ \t\r\n]+" nil t)
	  (replace-match "" nil nil))))))

(global-set-key "\M-[" 'kill-whitespace)
(global-set-key (kbd "C-<") 'decrease-left-margin)
(global-set-key (kbd "C->") 'increase-left-margin)

(setq-default c-subword-mode t)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(global-set-key (kbd "C-c C-d") 'svn-file-show-svn-diff)
(global-set-key (kbd "C-#") 'comment-region)
(global-set-key (kbd "M-#") 'uncomment-region)
(global-set-key (kbd "M-$") 'uncomment-region)


(add-hook 'python-mode-hook (lambda () (interactive) (column-marker-1 79)))

;; save a list of open files in ~/.emacs.desktop
;; save the desktop file automatically if it already exists
(setq desktop-save 'if-exists)
(desktop-save-mode 1)

;; save a bunch of variables to the desktop file
;; for lists specify the len of the maximal saved data also
(setq desktop-globals-to-save
      (append '((extended-command-history . 30)
                (file-name-history        . 100)
                (grep-history             . 30)
                (compile-history          . 30)
                (minibuffer-history       . 50)
                (query-replace-history    . 60)
                (read-expression-history  . 60)
                (regexp-history           . 60)
                (regexp-search-ring       . 20)
                (search-ring              . 20)
                (shell-command-history    . 50)
                tags-file-name
                register-alist)))

; (load "ess/lisp/ess-site.el")

;; pylint sucks too much cpu

(require 'compile)

;; user definable variables
;; vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

(defgroup pylint nil
  "Emacs support for the Pylint Python checker"
  :group 'languages
  :prefix "pylint-")

(defcustom pylint-options "--output-format=parseable"
  "*Command line options to be used with pylint call"
  :type 'string
  :group 'pylint)


;; adapted from pychecker for pylint
(defun pylint-python-hook ()
  (defun pylint ()
    "Run pylint against the file behind the current buffer after
    checking if unsaved buffers should be saved."

    (interactive)
    (let* ((file (buffer-file-name (current-buffer)))
           (command (concat "pylint " pylint-options " \"" file "\"")))
      (save-some-buffers (not compilation-ask-about-save) nil) ; save  files.
      (compilation-start command)))

  (let ((python-mode-map (cond ((boundp 'py-mode-map) py-mode-map)
                               ((boundp 'python-mode-map) python-mode-map))))

    ;; shortcuts in the tradition of python-mode and ropemacs
    (define-key python-mode-map (kbd "C-c m l") 'pylint)
    (define-key python-mode-map (kbd "C-c m p") 'previous-error)
    (define-key python-mode-map (kbd "C-c m n") 'next-error)

  (let ((map))
    (if(boundp 'py-mode-map)
        (setq map py-mode-map)
      (setq map python-mode-map)
      (define-key
        map
        [menu-bar Python pylint-separator]
        '("--" . pylint-seperator))
      (define-key
        map
        [menu-bar Python next-error]
        '("Next error" . next-error))
      (define-key
        map
        [menu-bar Python prev-error]
        '("Previous error" . previous-error))
      (define-key
        map
        [menu-bar Python lint]
        '("Pylint" . pylint))
      ))
    ))

;; (add-hook 'python-mode-hook 'pylint-python-hook)


(add-hook 'python-mode-hook
	  '(lambda ()
	     (define-key python-mode-map "\C-m" 'newline-and-indent)
		 (pylint-python-hook)
	     (flymake-mode)
	     (define-key python-mode-map "\M-n" 'flymake-goto-next-error)
	     (define-key python-mode-map "\M-p" 'flymake-goto-prev-error)
))


;; Configure flymake for python
(when (load "flymake" t)
  (defun flymake-pylint-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list "flake8" (list local-file))))

  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.py\\'" flymake-pylint-init)))

;; Set as a minor mode for python
;; (add-hook 'python-mode-hook '(lambda () (flymake-mode)))

;; (when (load "flymake" t)
;;          (defun flymake-pyflakes-init ()
;;            (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                               'flymake-create-temp-inplace))
;;               (local-file (file-relative-name
;;                            temp-file
;;                            (file-name-directory buffer-file-name))))
;;              (list "pylint" (list local-file))))

;;          (add-to-list 'flymake-allowed-file-name-masks
;;                   '("\\.py\\'" flymake-pyflakes-init)))

;; (add-hook 'find-file-hook 'flymake-find-file-hook)

(setq TeX-PDF-mode t)
(setq TeX-view-program-selection
      '(((output-dvi style-pstricks)
	 "dvips and PDF Viewer")
	(output-dvi "xdvi")
	(output-pdf "PDF Viewer")
	(output-html "Safari")))
(setq TeX-view-program-list
      '(("dvips and PDF Viewer" "%(o?)dvips %d -o && open %f")
	("PDF Viewer" "open %o")
	("Safari" "open %o")))

(setq-default line-spacing 1)

(set-face-background 'rst-level-1-face "black")
(set-face-background 'rst-level-2-face "black")
(set-face-background 'rst-level-3-face "black")
(set-face-background 'rst-level-4-face "black")

;; gross hack

;; http://hugoheden.wordpress.com/2009/03/08/copypaste-with-emacs-in-terminal/
;; I prefer using the "clipboard" selection (the one the
;; typically is used by c-c/c-v) before the primary selection
;; (that uses mouse-select/middle-button-click)
(setq x-select-enable-clipboard t)

;; If emacs is run in a terminal, the clipboard- functions have no
;; effect. Instead, we use of xsel, see
;; http://www.vergenet.net/~conrad/software/xsel/ -- "a command-line
;; program for getting and setting the contents of the X selection"
(unless window-system
 (when (getenv "DISPLAY")
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
  (setq interprogram-paste-function 'xsel-paste-function)
  ;; Idea from
  ;; http://shreevatsa.wordpress.com/2006/10/22/emacs-copypaste-and-x/
  ;; http://www.mail-archive.com/help-gnu-emacs@gnu.org/msg03577.html
 ))

;; Docbook XML / nXML stuff

;; some hack attack in here...

(add-hook 'nxml-mode-hook
          '(lambda ()
			 (load "docbook-xml-mode.el" nil t t)
             (define-key nxml-mode-map (kbd "C-!")	'docbook-xml-insert-comment)
			 (define-key nxml-mode-map "\C-ci1"	'docbook-xml-insert-sect1)
			 (define-key nxml-mode-map "\C-ci2"	'docbook-xml-insert-sect2)
			 (define-key nxml-mode-map "\C-ci3"	'docbook-xml-insert-sect3)
			 (define-key nxml-mode-map "\C-ci4"	'docbook-xml-insert-sect4)
			 (define-key nxml-mode-map "\C-cic"	'docbook-xml-insert-computeroutput)
			 (define-key nxml-mode-map "\C-cie"	'docbook-xml-insert-example)
			 (define-key nxml-mode-map "\C-ciE"	'docbook-xml-insert-emphasis)
			 (define-key nxml-mode-map "\C-cil"	'docbook-xml-insert-link)
			 (define-key nxml-mode-map "\C-cip"	'docbook-xml-insert-para)
			 (define-key nxml-mode-map "\C-cir"	'docbook-xml-insert-replaceable)
			 (define-key nxml-mode-map "\C-cii"	'docbook-xml-insert-ipython)
			 (define-key nxml-mode-map "\C-cig"	'docbook-xml-insert-programlisting)
			 (define-key nxml-mode-map "\C-cil"	'docbook-xml-insert-literal)
			 (define-key nxml-mode-map "\C-cit"	'docbook-xml-insert-title)
			 (define-key nxml-mode-map "\C-cu"	'docbook-xml-insert-under-construction)
			 (define-key nxml-mode-map "\C-civ"	'docbook-xml-insert-varname)
			 (define-key nxml-mode-map "\C-cix"	'docbook-xml-insert-xref)
			 (define-key nxml-mode-map "\C-c\C-j" 'docbook-xml-insert-listitem)
			 ;; (define-key nxml-mode-map "\C-c\C-t\C-E"	'docbook-xml-insert-emphasis)
			 ;; (define-key nxml-mode-map (kbd "C-c C-t C-p")	'docbook-xml-insert-para
			 ;; (define-key nxml-mode-map "\C-c\C-t\C-i"	'docbook-xml-insert-para)
			 ;; (rng-set-schema-file-and-validate "schemas/docbook.rnc")))
			 ))


(eval-after-load 'rng-loc
  (lambda ()
	(message "it works!")
	(add-to-list 'rng-schema-locating-files "~/.schema/schemas.xml")))

(global-set-key [C-return] 'completion-at-point)

(delete-if
 (lambda (x)
   (or (eq (cdr x) 'tramp-completion-file-name-handler)
       (eq (cdr x) 'tramp-file-name-handler)))
 file-name-handler-alist)

;; Coffeescript stuff

(defun my-coffee-mode-hook ()
  (setq tab-width 2)
  (auto-complete-mode 1))
(add-hook 'coffee-mode-hook 'my-coffee-mode-hook)

(defun node-format ()
  (interactive)
  (save-excursion
	(shell-command-on-region (mark) (point) "node -e \"process.stdin.resume(); process.stdin.setEncoding('utf8'); process.stdin.on('data', function (chunk) { eval('foo = ' + chunk); console.log(JSON.stringify(foo, null, 2));});\""  (buffer-name) t)
	)
  )

(global-set-key "\C-c\C-j" 'node-format)

;; scala-mode package

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)
(unless (package-installed-p 'scala-mode2)
  (package-refresh-contents) (package-install 'scala-mode2))

(if (eq system-type 'darwin)
	(custom-set-faces
	 ;; custom-set-faces was added by Custom.
	 ;; If you edit it by hand, you could mess it up, so be careful.
	 ;; Your init file should contain only one such instance.
	 ;; If there is more than one, they won't work right.
	 '(default ((t (:inherit nil :stipple nil :background "black" :foreground "white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 160 :width normal :foundry "nil" :family "Terminus (TTF)"))))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
