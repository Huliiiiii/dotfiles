if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -x COLORTERM truecolor

set -x EDITOR hx
set -x SYSTEMD_EDITOR hx

# Package managers
## Bun
set -x BUN_INSTALL $HOME/.bun
fish_add_path "$BUN_INSTALL/bin"
# Bun end

## Pnpm
set -x PNPM_HOME $HOME/.local/share/pnpm
fish_add_path "$PNPM_HOME"
## Pnpm end

## Cargo
fish_add_path "$HOME/.cargo/bin"
## Cargo end

direnv hook fish | source
set -x DIRENV_LOG_FORMAT ''

fzf --fish | source

zoxide init fish | source
