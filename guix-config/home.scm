(use-modules
  (gnu home)
  (gnu packages)
  (gnu services)
  (gnu home services)
  (gnu home services shells)
  (guix gexp))

(define (lines . xs)
  (let loop ((xs xs) (acc ""))
    (if (null? xs)
        acc
        (loop (cdr xs) (string-append acc (car xs) "\n")))))

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
                 (lines
                   "export GUIX_LOCPATH=\"$HOME/.guix-home/profile/lib/locale\""
                   "export EDITOR=hx"
                   "export VISUAL=hx")))))
      %base-home-services)))
