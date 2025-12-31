(use-modules
  (gnu home)
  (gnu packages)
  (gnu services)
  (gnu home services)
  (gnu home services shells)
  (guix gexp))

(home-environment
  (packages
    (specifications->packages
      (list
        "git-delta"
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
        (simple-service 'extra-profile home-shell-profile-service-type
          (list (plain-file "shell-profile"
                 "export GUIX_LOCPATH=\"$HOME/.guix-home/profile/lib/locale\""))))
      %base-home-services)))
