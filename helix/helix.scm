(require "helix/editor.scm")
(require (prefix-in helix. "helix/commands.scm"))
(require (prefix-in helix.static. "helix/static.scm"))
(require (prefix-in helix.misc. "helix/misc.scm"))

(provide yank-curpath
         yank-curpath-abs)

(define (current-path)
  (let* ([focus (editor-focus)]
         [focus-doc-id (editor->doc-id focus)])
    (editor-document->path focus-doc-id)))

;;@doc
;; Copy the current file path (absolute) to the clipboard.
(define (yank-curpath-abs)
  (let ([path (current-path)])
    (if path
        (set-register! #\+ (list path))
        (helix.misc.set-status! "No current file"))))

;;@doc
;; Copy the current file path relative to the workspace root to the clipboard.
(define (yank-curpath)
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
