if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -x COLORTERM truecolor

set -x EDITOR hx
set -x SYSTEMD_EDITOR hx

# Package managers
## Bun
set -x BUN_INSTALL $HOME/.bun
set -x PATH $BUN_INSTALL/bin $PATH
## Bun end

## Pnpm
set -x PNPM_HOME $HOME/.local/share/pnpm
if not contains $PNPM_HOME $PATH
    set -x PATH $PNPM_HOME $PATH
end
## Pnpm end

## Cargo
if not contains $HOME/.cargo/bin $PATH
    set -gx PATH $HOME/.cargo/bin $PATH
end
## Cargo end

## Rust
set -gx RUSTC_WRAPPER $HOME/.cargo/bin/sccache
## Rust

direnv hook fish | source
set -x DIRENV_LOG_FORMAT ''

fzf --fish | source

zoxide init fish | source
