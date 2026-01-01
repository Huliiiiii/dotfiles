set windows-shell := ["pwsh", "-NoLogo", "-Command"]

cfg := "./guix-config/home.scm"

home-ed:
    hx {{cfg}}

home-up:
    guix home reconfigure {{cfg}}
