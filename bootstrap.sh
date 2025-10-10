#!/usr/bin/env bash
dnf_pkgs=(
  "git"
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
  "clang"
  "dnf5-plugins"
)

sudo dnf install ${dnf_pkgs[@]} -y

sudo dnf config-manager addrepo --from-repofile=https://cli.github.com/packages/rpm/gh-cli.repo
sudo dnf install gh --repo gh-cli

echo $(which fish) | sudo tee -a /etc/shells

chsh -s $(which fish)

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
  "bottom"
)

cargo binstall ${binstall_pkgs[@]} -y

if !corepack -v &> /dev/null; then
sudo npm install -g corepack
corepack enable pnpm
fi

pnpm_pkgs=(
  "@openai/codex"
)

pnpm install -g ${pnpm_pkgs[@]}

# psql
sudo dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/F-42-x86_64/pgdg-fedora-repo-latest.noarch.rpm
sudo dnf install -y postgresql18-server
sudo /usr/pgsql-18/bin/postgresql-18-setup initdb
sudo systemctl enable postgresql-18
sudo systemctl start postgresql-18

# uv
curl -LsSf https://astral.sh/uv/install.sh | sh
