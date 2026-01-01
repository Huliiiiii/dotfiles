(require "helix/configuration.scm")
(require (prefix-in helix. "helix/commands.scm"))

(helix.theme "catppuccin_macchiato")

(idle-timeout 800)
(auto-format #t)
(set-option! "auto-save" (hash 'focus-lost #t 'after-delay (hash 'enable #t 'timeout 2000)))
(bufferline 'multiple)
;; (set-option! "clipboard-provider" "termcode")
(color-modes #t)
(completion-replace #t)
(completion-timeout 50)
(cursorline #t)
;; Not yet exposed as a dedicated helper in `helix/configuration.scm`
(set-option! "end-of-line-diagnostics" "hint")
(line-number 'relative)
;; (set-option! "shell" (list "pwsh" "-Command"))
(true-color #t)

;; [editor.cursor-shape]
(cursor-shape #:normal 'block #:insert 'bar #:select 'underline)

;; [editor.file-picker]
(file-picker-kw #:hidden #f #:follow-symlinks #t #:deduplicate-links #f)

;; [editor.whitespace.*]
;; TOML used `render.tab = "all"`; Scheme API currently exposes boolean render flags,
;; so this keeps parity by rendering tabs and leaving other whitespace disabled.
(whitespace (ws-visible #t)
            (ws-render (hash 'space #f 'nbsp #f 'nnbsp #f 'tab #t 'newline #f))
            (ws-chars (hash 'space #\· 'tab #\→)))

;; [editor.indent-guides]
(indent-guides (ig-render #t))
;; (indent-guides (ig-render #t) (ig-character #\┆))

;; [editor.soft-wrap]
(soft-wrap (sw-enable #t))
;; (soft-wrap (sw-enable #t) (sw-wrap-indicator ""))

;; [editor.inline-diagnostics]
;; Helix uses string severities here; set via `set-option!` for fidelity.
(set-option! "inline-diagnostics.cursor-line" "hint")
(set-option! "inline-diagnostics.max-diagnostics" 10)
(set-option! "inline-diagnostics.max-wrap" 20)
(set-option! "inline-diagnostics.prefix-len" 1)

;; [editor.lsp]
(lsp (hash 'auto-signature-help
           #f
           'display-inlay-hints
           #t
           'display-messages
           #t
           'inlay-hints-length-limit
           30))

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
                   ;; "spacer"
                   "diagnostics"
                   "selections"
                   "register"
                   "position"))

;; [editor.gutters]
(set-option! "gutters.layout" (list "spacer" "diagnostics" "line-numbers" "spacer" "diff"))
