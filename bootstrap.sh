#!/usr/bin/env bash
sudo dnf in fish
if ! fish -v &> /dev/null; then
echo $(which fish) | sudo tee -a /etc/shells
chsh -s $(which fish)
fi

cargo_pkgs=(
  "sea-orm-cli"
)

env RUSTFALGS="$RUSTFALGS -Ctarget-cpu=native"

# cargo install ${cargo_pkgs[@]}
# cargo install taplo-cli --features lsp

binstall_pkgs=(
  wild-linker
)

cargo binstall ${binstall_pkgs[@]} -y

# psql
# sudo dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/F-42-x86_64/pgdg-fedora-repo-latest.noarch.rpm
# sudo dnf install -y postgresql18-server
# sudo /usr/pgsql-18/bin/postgresql-18-setup initdb
# sudo systemctl enable postgresql-18
# sudo systemctl start postgresql-18

wget -P "~/.config/bat/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Latte.tmTheme
wget -P "~/.config/bat/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Frappe.tmTheme
wget -P "~/.config/bat/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme
wget -P "~/.config/bat/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme
