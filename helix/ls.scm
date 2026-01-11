(require "helix/configuration.scm")
(require "./utils.scm")

(define-lsp "deno" (command "deno") (args '("lsp")))
(define-lsp "emmet-ls" (command "emmet-ls") (args '("--stdio")))
(define-lsp "terraform-ls" (command "terraform-ls") (args '("serve")))
(define-lsp "wakatime-ls" (command "wakatime-ls") (args '()))

(define-lsp "steel-language-server" (command "steel-language-server") (args '()))

(define-lsp "oxlint-language-server" (command "oxlint") (args '("--lsp")))

(define-lsp "tombi" (command "tombi") (args '("lsp")) (provideFormatter #t))

(define-lsp "typos"
            (command "typos-lsp")
            (environment (hash "RUST_LOG" "error"))
            (config (config "~/code/typos-lsp/crates/typos-lsp/tests/typos.toml")
                    (diagnosticSeverity "Warning")))

(define-lsp "rust-analyzer" (config (check (hash "workspace" #f "command" "clippy"))))

(define-lsp "vscode-css-language-server"
            (command "vscode-css-language-server")
            (args '("--stdio"))
            (config (provideFormatter #t)
                    (css (hash "validate" (hash "enable" #t)))
                    (less (hash "validate" (hash "enable" #t)))
                    (scss (hash "validate" (hash "enable" #t)))))

(define-lsp "vscode-html-language-server" (command "vscode-html-language-server") (args '("--stdio")))

(define-lsp "vscode-json-language-server"
            (command "vscode-json-language-server")
            (args '("--stdio"))
            (config (provideFormatter #t)
                    (json (hash "validate" (hash "enable" #t) "format" (hash "enable" #t)))))

(define-lsp "yaml-language-server"
            (command "yaml-language-server") (args '("--stdio"))
            (config
              (yaml (hash*
                      (("format" "enable") #t)
                      (("validation") #t)
                      (("schemas")
                       (hashmap ("https://json.schemastore.org/github-workflow.json" ".github/workflows/*.{yml,yaml}")
                                ("https://raw.githubusercontent.com/ansible-community/schemas/main/f/ansible-tasks.json" "roles/{tasks,handlers}/*.{yml,yaml}")))))))

(define-lsp "vtsls"
            (command "vtsls")
            (args '("--stdio"))
            (config (hostInfo "helix")
                    (typescript (hash* (("format" "enable") #f)
                                       (("inlayHints" "enumMemberValues" "enabled") #t)
                                       (("inlayHints" "functionLikeReturnTypes") #t)
                                       (("inlayHints" "parameterNames" "enabled") "all")
                                       (("inlayHints" "parameterTypes" "enabled") #t)
                                       (("inlayHints" "propertyDeclarationTypes" "enabled") #t)
                                       (("inlayHints" "variableTypes" "enabled") #t)
                                       (("preferences" "importModuleSpecifier") "non-relative")
                                       (("preferences" "importModuleSpecifierEnding") "auto")
                                       (("suggest" "completeFunctionCalls") #t)
                                       (("tsserver" "enableTracing") #t)
                                       (("tsserver" "pluginPaths") (list "typescript-plugin-css-modules"
                                                                         "./node_modules"))
                                       (("updateImportsOnFileMove" "enabled") "always")))))

