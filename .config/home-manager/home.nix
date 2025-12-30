{
  pkgs,
  lib,
  ...
}:
let
  buildNpmPackage = pkgs.buildNpmPackage.override { nodejs = pkgs.nodejs_24; };
  pnpm_9 = pkgs.pnpm_9;
  ccr = import ./modules/ccr.nix {
    inherit
      pkgs
      lib
      buildNpmPackage
      pnpm_9
      ;
  };
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "Huliiiiii";
  home.homeDirectory = "/home/Huliiiiii";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages =
    with pkgs;
    [
      mergiraf
      emmet-language-server
      git-filter-repo
      pnpm
      vtsls
      oxlint
      delta
      difftastic
      uv
      speedtest-cli
      podman-compose
      fastfetch
      typos-lsp
      ast-grep
      bottom
      clang
      claude-code
      codex
      tombi
      dust
      gh
      gitui
      gitui
      helix
      kdlfmt
      lazygit
      markdown-oxide
      marksman
      mold
      nil
      nixd
      nixfmt-rfc-style
      nodejs
      opencode
      prettier
      taplo
      tsutsumi.wakatime-ls
      vscode-json-languageserver
      wget
      xclip
      xsel
      yazi
      zellij
      (fenix.complete.withComponents [
        "cargo"
        "clippy"
        "rust-src"
        "rustc"
        "rustfmt"
      ])
      rust-analyzer-nightly
    ]
    ++ [
      ccr
    ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/Huliiiiii/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "hx";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
