(require "helix/configuration.scm")
(require (prefix-in helix. "helix/commands.scm"))

(require "utils.scm")

(helix.theme "catppuccin_macchiato")

(idle-timeout 800)
(auto-format #t)
(set-option! "auto-save" (hash 'focus-lost #t 'after-delay (hash 'enable #t 'timeout 2000)))
(bufferline 'multiple)
(color-modes #t)
(completion-replace #t)
(completion-timeout 50)
(cursorline #t)
(set-option! "end-of-line-diagnostics" "hint")
(line-number 'relative)
(true-color #t)

(cursor-shape #:normal 'block #:insert 'bar #:select 'underline)

(file-picker-kw #:hidden #f #:follow-symlinks #t #:deduplicate-links #f)

(whitespace (ws-visible #t)
            (ws-render (hash 'space #f 'nbsp #f 'nnbsp #f 'tab #t 'newline #f))
            (ws-chars (hash 'space #\· 'tab #\→)))

(indent-guides (ig-render #t))
(soft-wrap (sw-enable #t))

(set-option! "inline-diagnostics.cursor-line" "hint")
(set-option! "inline-diagnostics.max-diagnostics" 10)
(set-option! "inline-diagnostics.max-wrap" 20)
(set-option! "inline-diagnostics.prefix-len" 1)

(lsp (hashmap ('auto-signature-help #f)
              ('display-inlay-hints #t)
              ('display-messages #t)
              ('inlay-hints-length-limit 30)))

;; [editor.statusline]
;; Use `set-option!` to preserve Helix's defaults for unrelated statusline fields.
(set-option! "statusline.left"
             (list "mode"
                   "spinner"
                   "version-control"
                   "file-name"
                   "read-only-indicator"
                   "file-modification-indicator"))

(set-option! "statusline.right"
             (list "file-line-ending"
                   "file-encoding"
                   ; "spacer"
                   "diagnostics"
                   "selections"
                   "register"
                   "position"))

(set-option! "gutters.layout" (list "spacer" "diagnostics" "line-numbers" "spacer" "diff"))
