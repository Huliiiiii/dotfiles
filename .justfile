set windows-shell := ["pwsh", "-NoLogo", "-Command"]

cfg := "./.config/guix/home.scm"

home-ed:
    hx {{cfg}}

home-up:
    guix home reconfigure {{cfg}}
