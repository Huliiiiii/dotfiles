{
  description = "Home Manager configuration of Huliiiiii";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tsutsumi = {
      url = "github:Fuwn/tsutsumi";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    codex.url = "github:sadjow/codex-cli-nix";
    llm-agents.url = "github:numtide/llm-agents.nix";
    tombi.url = "github:tombi-toml/tombi";
    yazi = {
      url = "github:sxyazi/yazi";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix-flake = {
      url = "github:mattwparas/helix/steel-event-system";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    steel = {
      url = "github:mattwparas/steel";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      ...
    }:
    let
      pkgs = import nixpkgs {

        system = "x86_64-linux";
        overlays = [
          inputs.yazi.overlays.default
          inputs.fenix.overlays.default
          inputs.helix-flake.overlays.default
          (
            _: prev:
            let
              getPkg = src: name: src.packages.${prev.stdenv.hostPlatform.system}.${name};
              getPkgs = src: src.packages.${prev.stdenv.hostPlatform.system};
            in
            {
              codex = getPkg inputs.codex "default";
              droid = getPkg inputs.llm-agents "droid";
              opencode = getPkg inputs.llm-agents "opencode";
              # tombi = getPkg inputs.tombi "default";
              tsutsumi = getPkgs inputs.tsutsumi;
              helix = (inputs.helix-flake.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (oldAttrs: {
cargoBuildFlags = (oldAttrs.cargoBuildFlags or []) ++ ["--features" "steel,git"];
}))
;
            }
          )
        ];
        config.allowUnfree = true;
      };

      defaultPkgs = with pkgs; [
        bat
        bottom
        cargo-binstall
        cargo-expand
        cargo-semver-checks
        cargo-update
        clang
        codex
        delta
        difftastic
        direnv
        dotter
        dust
        fastfetch
        fd
        fzf
        gh
        git
        helix
        jq
        kdlfmt
        lazygit
        mergiraf
        mold
        nil
        nixd
        nixfmt-rfc-style
        nodejs
        pnpm
        prettier
        ripgrep
        sccache
        steel
        taplo
        typos-lsp
        uv
        tsutsumi.wakatime-ls
        vscode-json-languageserver
        vtsls
        wget
        xclip
        xsel
        zellij
        zoxide
      ];
      desktopPkgs = with pkgs; [
        typora
      ];
      codePkgs = with pkgs; [
        clang
        claude-code
        emmet-language-server
        markdown-oxide
        marksman
        opencode
        oxlint
        tombi
      ];
    in
    {
      homeConfigurations."huli@huli-panasonic" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
          (_: {
            home.username = "huli";
            home.homeDirectory = "/home/huli";
            home.packages = defaultPkgs ++ desktopPkgs;
          })
        ];
      };
      homeConfigurations."root@huli-panasonic" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
          (_: {
            home.username = "root";
            home.homeDirectory = "/home/root";
            home.packages = defaultPkgs;
          })
        ];
      };
      homeConfigurations."Huliiiiii@pca-workstation" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
          (
            { pkgs, lib, ... }:
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
              home.username = "Huliiiiii";
              home.homeDirectory = "/home/Huliiiiii";
              home.packages =
                defaultPkgs
                ++ codePkgs
                ++ [
                  (pkgs.fenix.complete.withComponents [
              "cargo"
              "clippy"
              "rust-src"
              "rustc"
              "rustfmt"
            ])
                ]
                ++ (with pkgs; [
                  rust-analyzer-nightly
                  podman-compose
                  yazi
                ])
                ++ [
                  ccr
                ];
            }
          )

        ];
      };

    };
}
