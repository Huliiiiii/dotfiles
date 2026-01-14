(require "helix/editor.scm")
(require (prefix-in helix. "helix/commands.scm"))
(require (prefix-in helix.static. "helix/static.scm"))
(require (prefix-in helix.misc. "helix/misc.scm"))
(require-builtin helix/core/text as text.)

(define (current-path)
  (let* ([focus (editor-focus)]
         [focus-doc-id (editor->doc-id focus)])
    (editor-document->path focus-doc-id)))

(provide yank-path-abs)
;;@doc
;; Copy the current file path (absolute) to the clipboard.
(define (yank-path-abs)
  (let ([path (current-path)])
    (if path
        (set-register! #\+ (list path))
        (helix.misc.set-status! "No current file"))))

(provide yank-path)
;;@doc
;; Copy the current file path relative to the workspace root to the clipboard.
(define (yank-path)
  (let ([path (current-path)]
        [root (find-workspace)])
    (if (and path root)
        (let* ([root-len (string-length root)]
               [root-slash (if (and (> root-len 0) (char=? (string-ref root (- root-len 1)) #\/))
                               root
                               (string-append root "/"))]
               [root-slash-len (string-length root-slash)]
               [path-len (string-length path)])
          (if (and (>= path-len root-slash-len)
                   (string=? (substring path 0 root-slash-len) root-slash))
              (set-register! #\+ (list (substring path root-slash-len path-len)))
              (begin
                (helix.misc.set-status! "Current file is outside workspace; copied absolute path")
                (set-register! #\+ (list path)))))
        (helix.misc.set-status! "No current file or workspace"))))

(define (ascii-alphabetic? ch)
  (let ([code (char->integer ch)])
    (or (and (<= 65 code) (<= code 90))
        (and (<= 97 code) (<= code 122)))))

(define (ascii-numeric? ch)
  (let ([code (char->integer ch)])
    (and (<= 48 code) (<= code 57))))

(define (symbol-char? ch)
  (or (ascii-alphabetic? ch)
      (ascii-numeric? ch)
      (memv ch '(#\_ #\- #\? #\! #\* #\+ #\/ #\: #\< #\> #\= #\$))))

(define (extract-symbol-at rope cursor-pos)
  (let* ([len (text.rope-len-chars rope)]
         [pos (if (> cursor-pos len) len cursor-pos)]
         [idx (cond
                [(and (< pos len) (symbol-char? (text.rope-char-ref rope pos))) pos]
                [(and (> pos 0) (> len 0) (symbol-char? (text.rope-char-ref rope (- pos 1)))) (- pos 1)]
                [else #f])])
    (if (not idx)
        #f
        (let* ([start (let loop ([i idx])
                        (if (and (> i 0) (symbol-char? (text.rope-char-ref rope (- i 1))))
                            (loop (- i 1))
                            i))]
               [end (let loop ([i (+ idx 1)])
                      (if (and (< i len) (symbol-char? (text.rope-char-ref rope i)))
                          (loop (+ i 1))
                          i))]
               [slice (text.rope->slice rope start end)])
          (text.rope->string slice)))))

(define (path-relative-to-workspace path root)
  (if (and path root)
      (let* ([root-len (string-length root)]
             [root-slash (if (and (> root-len 0) (char=? (string-ref root (- root-len 1)) #\/))
                             root
                             (string-append root "/"))]
             [root-slash-len (string-length root-slash)]
             [path-len (string-length path)])
        (if (and (>= path-len root-slash-len)
                 (string=? (substring path 0 root-slash-len) root-slash))
            (substring path root-slash-len path-len)
            path))
      path))

(provide yank-symbol)
;;@doc
;; Copy the symbol under cursor + file path to the clipboard.
(define (yank-symbol)
  (let* ([focus (editor-focus)]
         [focus-doc-id (editor->doc-id focus)]
         [path (editor-document->path focus-doc-id)]
         [root (find-workspace)]
         [rope (editor->text focus-doc-id)]
         [pos (helix.misc.cursor-position)]
         [symbol (extract-symbol-at rope pos)])
    (cond
      [(not path) (helix.misc.set-status! "No current file")]
      [(not symbol) (helix.misc.set-status! "No symbol under cursor")]
      [else
       (let ([path* (path-relative-to-workspace path root)])
         (set-register! #\+ (list (string-append path* " " symbol))))])))

(provide yank-location)
;;@doc
;; Copy the current file path + cursor line number to the clipboard.
(define (yank-location)
  (let* ([focus (editor-focus)]
         [focus-doc-id (editor->doc-id focus)]
         [path (editor-document->path focus-doc-id)]
         [root (find-workspace)])
    (if (not path)
        (helix.misc.set-status! "No current file")
        (let* ([rope (editor->text focus-doc-id)]
               [pos (helix.misc.cursor-position)]
               [len (text.rope-len-chars rope)]
               [pos* (if (> pos len) len pos)]
               [line (+ 1 (text.rope-char->line rope pos*))]
               [path* (path-relative-to-workspace path root)])
          (set-register! #\+ (list (string-append path* ":" (number->string line))))))))

