(require "helix/configuration.scm")

(define global-language-servers '("wakatime-ls"))
(define js-language-servers-base '("vtsls" "oxlint-language-server"))
(define html-language-servers-extra '("emmet-ls"))

(define-language "css"
                 (auto-format #t)
                 (formatter (command "prettier") (args '("--parser" "css")))
                 (language-servers (append global-language-servers '("vscode-css-language-server"))))

(define-language "hcl"
                 (language-id "terraform")
                 (language-servers (append global-language-servers '("terraform-ls"))))

(define-language "html"
                 (auto-format #t)
                 (formatter (command "prettier") (args '("--parser" "html")))
                 (language-servers (append global-language-servers
                                           '("vscode-html-language-server")
                                           html-language-servers-extra)))

(define-language "javascript"
                 (auto-format #t)
                 (formatter (command "prettier") (args '("--parser" "typescript")))
                 (language-servers (append global-language-servers js-language-servers-base)))

(define-language "json"
                 (auto-format #t)
                 (formatter (command "prettier") (args '("--parser" "json")))
                 (language-servers global-language-servers))

(define-language "jsx"
                 (auto-format #t)
                 (formatter (command "prettier") (args '("--parser" "typescript")))
                 (language-servers (append global-language-servers
                                           js-language-servers-base
                                           html-language-servers-extra)))

(define-language "markdown" (language-servers global-language-servers))

;; (define-language "markdown"
;;                  (auto-format #t)
;;                  (formatter (command "dprint") (args '("fmt" "--stdin" "md")))
;;                  (language-servers (append global-language-servers '("markdown-oxide"))))

(define-language "nix"
                 (auto-format #t)
                 (language-servers (append global-language-servers '("nil" "nixd"))))

(define-language "rust"
                 (language-servers (append global-language-servers '("rust-analyzer" "typos"))))

(define-language "scheme"
                 (auto-format #t)
                 (formatter (command "raco") (args '("fmt" "-i")))
                 ; (formatter (command "schemat") (args '()))
                 (language-servers (append global-language-servers '("steel-language-server"))))

(define-language "tfvars"
                 (language-id "terraform-vars")
                 (language-servers (append global-language-servers '("terraform-ls"))))

(define-language "toml" (auto-format #f) (language-servers global-language-servers))

(define-language "tsx"
                 (auto-format #t)
                 (formatter (command "prettier") (args '("--parser" "typescript")))
                 (language-servers (append global-language-servers
                                           html-language-servers-extra
                                           js-language-servers-base)))

(define-language "typescript"
                 (auto-format #t)
                 (formatter (command "prettier") (args '("--parser" "typescript")))
                 (language-servers (append global-language-servers js-language-servers-base)))
