if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -x COLORTERM truecolor

set -gx EDITOR hx
set -gx SYSTEMD_EDITOR hx

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

if command -q fcitx5
    set -gx XMODIFIERS @im=fcitx
    # set -gx GTK_IM_MODULE fcitx
    set -gx QT_IM_MODULE fcitx
    # set -gx GLFW_IM_MODULE ibus
    # set -gx SDL_IM_MODULE fcitx
    # set -gx WEBKIT_IM_MODULE fcitx
end

zoxide init fish --cmd cd | source
