#!/usr/bin/env bash
dnf_pkgs=(
  "fish"
  "bat"
  "direnv"
  "fd"
  "fzf"
  "gitui"
  "helix"
  "jq"
  "ripgrep"
  "tokei"
  "zoxide"
  "openssl-devel"
  "npm"
)

sudo dnf install ${dnf_pkgs[@]} -y

sudo chsh -s $(which fish)

if ! rustup -vV &> /dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  . "$HOME/.cargo/env"
fi

cargo_pkgs=(
  "cargo-binstall"
  "sea-orm-cli"
)

cargo install ${cargo_pkgs[@]} 

binstall_pkgs=(
  "wild-linker"
  "cargo-expand"
  "dotter"
  "sccache"
)

cargo binstall ${binstall_pkgs[@]} -y

sudo npm install -g corepack
