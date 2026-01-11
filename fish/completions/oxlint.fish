set -l oxlint_categories correctness suspicious pedantic perf style restriction nursery all

complete -c oxlint -s c -l config -r -d "Oxlint configuration file"
complete -c oxlint -l tsconfig -r -d "TypeScript `tsconfig.json` path for reading path alias and project references for import plugin"
complete -c oxlint -l init -d "Initialize oxlint configuration with default values"

complete -c oxlint -s A -l allow -r -a "$oxlint_categories" -d "Allow the rule or category (suppress the lint)"
complete -c oxlint -s W -l warn -r -a "$oxlint_categories" -d "Deny the rule or category (emit a warning)"
complete -c oxlint -s D -l deny -r -a "$oxlint_categories" -d "Deny the rule or category (emit an error)"

complete -c oxlint -l disable-unicorn-plugin -d "Disable unicorn plugin, which is turned on by default"
complete -c oxlint -l disable-oxc-plugin -d "Disable oxc unique rules, which is turned on by default"
complete -c oxlint -l disable-typescript-plugin -d "Disable TypeScript plugin, which is turned on by default"
complete -c oxlint -l import-plugin -d "Enable import plugin and detect ESM problems. It is recommended to use alongside the `--tsconfig` option."
complete -c oxlint -l react-plugin -d "Enable react plugin, which is turned off by default"
complete -c oxlint -l jsdoc-plugin -d "Enable jsdoc plugin and detect JSDoc problems"
complete -c oxlint -l jest-plugin -d "Enable the Jest plugin and detect test problems"
complete -c oxlint -l vitest-plugin -d "Enable the Vitest plugin and detect test problems"
complete -c oxlint -l jsx-a11y-plugin -d "Enable the JSX-a11y plugin and detect accessibility problems"
complete -c oxlint -l nextjs-plugin -d "Enable the Next.js plugin and detect Next.js problems"
complete -c oxlint -l react-perf-plugin -d "Enable the React performance plugin and detect rendering performance problems"
complete -c oxlint -l promise-plugin -d "Enable the promise plugin and detect promise usage problems"
complete -c oxlint -l node-plugin -d "Enable the node plugin and detect node usage problems"
complete -c oxlint -l vue-plugin -d "Enable the vue plugin and detect vue usage problems"

complete -c oxlint -l fix -d "Fix as many issues as possible. Only unfixed issues are reported in the output."
complete -c oxlint -l fix-suggestions -d "Apply auto-fixable suggestions. May change program behavior."
complete -c oxlint -l fix-dangerously -d "Apply dangerous fixes and suggestions"

complete -c oxlint -l ignore-path -r -d "Specify the file to use as your `.eslintignore`"
complete -c oxlint -l ignore-pattern -r -d "Specify patterns of files to ignore (in addition to those in `.eslintignore`)"
complete -c oxlint -l no-ignore -d "Disable excluding files from `.eslintignore` files, --ignore-path flags and --ignore-pattern flags"

complete -c oxlint -l quiet -d "Disable reporting on warnings, only errors are reported"
complete -c oxlint -l deny-warnings -d "Ensure warnings produce a non-zero exit code"
complete -c oxlint -l max-warnings -r -d "Specify a warning threshold, which can be used to force exit with an error status if there are too many warning-level rule violations in your project"

complete -c oxlint -s f -l format -r -a "checkstyle default github gitlab json junit stylish unix" -d "Use a specific output format. Possible values: `checkstyle`, `default`, `github`, `gitlab`, `json`, `junit`, `stylish`, `unix`"

complete -c oxlint -l silent -d "Do not display any diagnostics"
complete -c oxlint -l threads -r -d "Number of threads to use. Set to 1 for using only 1 CPU core."
complete -c oxlint -l print-config -d "This option outputs the configuration to be used. When present, no linting is performed and only config-related options are valid."

complete -c oxlint -l report-unused-disable-directives -d "Report directive comments like `// oxlint-disable-line`, when no errors would have been reported on that line anyway"
complete -c oxlint -l report-unused-disable-directives-severity -r -d "Same as `--report-unused-disable-directives`, but allows you to specify the severity level of the reported errors. Only one of these two options can be used at a time."

complete -c oxlint -l rules -d "List all the rules that are currently registered"
complete -c oxlint -l lsp -d "Start the language server"
complete -c oxlint -l disable-nested-config -d "Disable the automatic loading of nested configuration files"
complete -c oxlint -l type-aware -d "Enable rules that require type information"
complete -c oxlint -l type-check -d "Enable experimental type checking (includes TypeScript compiler diagnostics)"

complete -c oxlint -s h -l help -d "Prints help information"
complete -c oxlint -s V -l version -d "Prints version information"
