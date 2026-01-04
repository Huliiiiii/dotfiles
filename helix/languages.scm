(require "helix/configuration.scm")
(require "utils.scm")

(define global-ls '("wakatime-ls" "typos"))
(define js-ls-base '("vtsls" "oxlint-language-server"))
(define html-ext-ls '("emmet-ls"))

(define-language "css"
                 (auto-format #t)
                 (formatter (command "prettier") (args '("--parser" "css")))
                 (language-servers (append global-ls '("vscode-css-language-server"))))

(define-language "hcl"
                 (language-id "terraform")
                 (language-servers (append global-ls '("terraform-ls"))))

(define-language "html"
                 (auto-format #t)
                 (formatter (command "prettier") (args '("--parser" "html")))
                 (language-servers (append global-ls '("vscode-html-language-server") html-ext-ls)))

(define-language "javascript"
                 (auto-format #t)
                 (formatter (command "prettier") (args '("--parser" "typescript")))
                 (language-servers (append global-ls js-ls-base)))

(define-language "json"
                 (auto-format #t)
                 (formatter (command "prettier") (args '("--parser" "json")))
                 (language-servers global-ls))

(define-language "jsx"
                 (auto-format #t)
                 (formatter (command "prettier") (args '("--parser" "typescript")))
                 (language-servers (append global-ls js-ls-base html-ext-ls)))

(define-language "markdown" (language-servers global-ls))

;; (define-language "markdown"
;;                  (auto-format #t)
;;                  (formatter (command "dprint") (args '("fmt" "--stdin" "md")))
;;                  (language-servers (append global-ls '("markdown-oxide"))))

(define-language "nix" (auto-format #t) (language-servers (append global-ls '("nil" "nixd"))))

(define-language "rust" (language-servers (append global-ls '("rust-analyzer"))))

(define-language "scheme"
                 (auto-format #t)
                 (formatter (command "raco") (args '("fmt" "-i")))
                 ; (formatter (command "schemat") (args '()))
                 (language-servers (append global-ls '("steel-language-server"))))

(define-language "tfvars"
                 (language-id "terraform-vars")
                 (language-servers (append global-ls '("terraform-ls"))))

(define-language "toml" (auto-format #f) (language-servers global-ls))

(define-language "tsx"
                 (auto-format #t)
                 (formatter (command "prettier") (args '("--parser" "typescript")))
                 (language-servers (append global-ls html-ext-ls js-ls-base)))

(define-language "typescript"
                 (auto-format #t)
                 (formatter (command "prettier") (args '("--parser" "typescript")))
                 (language-servers (append global-ls js-ls-base)))
