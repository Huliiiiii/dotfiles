set -gx no_proxy "$no_proxy,127.0.0.1,localhost"
if command -q sccache
    set -gx RUSTC_WRAPPER (which sccache)
end

# set -g CARGO_TARGET_DIR "$HOME/.cache/rustc-target"
