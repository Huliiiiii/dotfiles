(define-syntax hash-nest
  (syntax-rules ()
    [(_ (k) v) (hash k v)]
    [(_ (k ks ...) v) (hash k (hash-nest (ks ...) v))]))

(define-syntax hash-kv
  (syntax-rules ()
    [(_ (k) v) (list k v)]
    [(_ (k ks ...) v) (list k (hash-nest (ks ...) v))]))

(provide hash*)
(define-syntax hash*
  (syntax-rules ()
    [(_ (path value) ...) (apply hash (append (hash-kv path value) ...))]))

(provide hashmap)
(define-syntax hashmap
  (syntax-rules ()
    [(_ (k v) ...) (apply hash (append (list k v) ...))]))

