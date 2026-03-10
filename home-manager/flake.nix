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
    llm-agents.url = "github:numtide/llm-agents.nix";
    tombi.url = "github:tombi-toml/tombi";
    wakatime-ls = {
      url = "github:mrnossiom/wakatime-ls";
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
          # inputs.yazi.overlays.default
          inputs.fenix.overlays.default
          inputs.helix-flake.overlays.default
          inputs.llm-agents.overlays.default
          (
            _: prev:
            let
              getPkg = src: name: src.packages.${prev.stdenv.hostPlatform.system}.${name};
              getPkgs = src: src.packages.${prev.stdenv.hostPlatform.system};
            in
            {
              codex = getPkg inputs.llm-agents "codex";
              droid = getPkg inputs.llm-agents "droid";
              opencode = getPkg inputs.llm-agents "opencode";
              wakatime-ls = getPkg inputs.wakatime-ls "default";
              # tombi = getPkg inputs.tombi "default";
              tsutsumi = getPkgs inputs.tsutsumi;
              helix = (
                inputs.helix-flake.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (oldAttrs: {
                  cargoBuildFlags = (oldAttrs.cargoBuildFlags or [ ]) ++ [
                    "--features"
                    "steel,git"
                  ];
                })
              );
              steel = getPkg inputs.steel "default";
            }
          )
        ];
        config.allowUnfree = true;
      };

      baseTools = with pkgs; [
        bat
        bottom
        cachix
        cargo-binstall
        cargo-update
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
        hyperfine
        jq
        just-lsp
        kdlfmt
        lazygit
        mergiraf
        ripgrep
        steel
        systemd-manager-tui
        uv
        wakatime-cli
        wget
        yazi
        zellij
        zoxide
      ];
      buildTools = with pkgs; [
        sccache
      ];
      linkers = with pkgs; [
        mold
        wild-unwrapped
      ];
      rustTools = with pkgs; [
        cargo-expand
        cargo-semver-checks
      ];
      llmTools = with pkgs; [
        claude-code
        codex
        opencode
      ];
      baseLs = with pkgs; [
        marksman
        nil
        nixd
        nixfmt
        prettier
        taplo
        tombi
        wakatime-ls
        typos-lsp
        vscode-json-languageserver
      ];
      tsTools = with pkgs; [
        emmet-ls
        oxlint
        pnpm
        tailwindcss-language-server
        vtsls
      ];
      dockerTools = with pkgs; [
        docker-language-server
        dockerfile-language-server
        dockerfmt
      ];
      pythonTools = with pkgs; [
        ty
        ruff
      ];
      desktopPkgs = with pkgs; [
      ];

      defaultPkgs = baseTools ++ buildTools ++ baseLs ++ llmTools;
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
              ccr = import ./modules/ccr.nix {
                inherit
                  pkgs
                  lib
                  buildNpmPackage
                  ;
              };
            in
            {
              home.username = "Huliiiiii";
              home.homeDirectory = "/home/Huliiiiii";
              home.packages =
                defaultPkgs
                ++ tsTools
                ++ rustTools
                ++ dockerTools
                ++ pythonTools
                ++ linkers
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
                  podman-compose
                  clang
                  podman-tui
                  racket
                  nodejs
                  bun
                  rust-analyzer-nightly
                  llm-agents.agent-browser
                ])
                ++ [
                  ccr
                ];
            }
          )
        ];
      };

    };
  nixConfig = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
  };
}
