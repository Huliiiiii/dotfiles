(use-modules (gnu home)
             (gnu packages)
             (gnu services)
             (gnu home services shells)
             (guix gexp))

(home-environment
  (packages
    (specifications->packages
      (list
        "glibc-locales"
        "guile"
        "guile-wisp"
        "hello"
        "just"
        "nss-certs"
        "racket")))
  (services
    (append
      (list
        (service home-bash-service-type
          (home-bash-configuration
            (guix-defaults? #t)
          )))
      %base-home-services)))
