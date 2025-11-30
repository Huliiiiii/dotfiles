#!/usr/bin/env bash
dnf_pkgs=(
  "nodejs"
  "du-dust"
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
  "yazi"
  "ghostty"
)

sudo dnf install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release -y
sudo dnf copr enable lihaohong/yazi -y
sudo dnf install ${dnf_pkgs[@]} -y --skip-unavailable

sudo dnf config-manager addrepo --from-repofile=https://cli.github.com/packages/rpm/gh-cli.repo
sudo dnf install gh --repo gh-cli

echo $(which fish) | sudo tee -a /etc/shells

if ! rustup -vV &> /dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  . "$HOME/.cargo/env"
fi

# install cargo binstall
if ! cargo-binstall -V &> /dev/null; then
curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
fi

cargo_pkgs=(
  "sea-orm-cli"
)

env RUSTFALGS="$RUSTFALGS -Ctarget-cpu=native"

# cargo install ${cargo_pkgs[@]}
# cargo install taplo-cli --features lsp

binstall_pkgs=(
  "wild-linker"
  "cargo-expand"
  "dotter"
  "sccache"
  "bottom"
  "cargo-semver-checks"
)

cargo binstall ${binstall_pkgs[@]} -y

if ! corepack -v &> /dev/null; then
sudo npm install -g corepack
corepack enable pnpm
pnpm setup
. ~/.bashrc
fi

pnpm_pkgs=(
  "@openai/codex"
)

pnpm install -g ${pnpm_pkgs[@]}

# psql
# sudo dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/F-42-x86_64/pgdg-fedora-repo-latest.noarch.rpm
# sudo dnf install -y postgresql18-server
# sudo /usr/pgsql-18/bin/postgresql-18-setup initdb
# sudo systemctl enable postgresql-18
# sudo systemctl start postgresql-18

# uv
if ! uv -V &> /dev/null; then
curl -LsSf https://astral.sh/uv/install.sh | sh
fi


if ! fish -v &> /dev/null; then
echo $(which fish) | sudo tee -a /etc/shells
chsh -s $(which fish)
fi
