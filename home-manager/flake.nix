{
  description = "Home Manager configuration of Huliiiiii";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    skills-catalog = {
      url = "path:./skills";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents.url = "github:numtide/llm-agents.nix";
    kero-release = {
      url = "file+https://api.github.com/repos/egoist/kero/releases/latest";
      flake = false;
    };
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
      inputs.systems.url = "github:nix-systems/x86_64-linux";
    };
    hunk = {
      url = "path:./modules/hunk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zed-extensions.url = "github:DuskSystems/nix-zed-extensions";
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
          inputs.llm-agents.overlays.shared-nixpkgs
          (
            _: prev:
            let
              getPkg = src: name: src.packages.${prev.stdenv.hostPlatform.system}.${name};
              getPkgs = src: src.packages.${prev.stdenv.hostPlatform.system};
            in
            {
              codex = prev.llm-agents.codex;
              opencode = prev.llm-agents.opencode;
              codex-acp = prev.llm-agents.codex-acp;
              kero =
                let
                  release = builtins.fromJSON (builtins.readFile inputs.kero-release);
                  version = prev.lib.removePrefix "v" release.tag_name;
                  asset =
                    prev.lib.findSingle (asset: asset.name == "kero-server-${version}-linux-amd64.tar.gz")
                      (throw "Kero release has no Linux amd64 server archive")
                      (throw "Kero release has multiple Linux amd64 server archives")
                      release.assets;
                in
                prev.stdenvNoCC.mkDerivation {
                  pname = "kero";
                  inherit version;
                  src = prev.fetchurl {
                    url = asset.browser_download_url;
                    sha256 = prev.lib.removePrefix "sha256:" asset.digest;
                  };
                  nativeBuildInputs = [ prev.autoPatchelfHook ];
                  sourceRoot = ".";
                  dontConfigure = true;
                  dontBuild = true;
                  installPhase = ''
                    runHook preInstall
                    install -Dm755 kero $out/lib/kero/kero
                    install -Dm755 libghostty-vt.so $out/lib/kero/libghostty-vt.so
                    mkdir -p $out/bin
                    ln -s $out/lib/kero/kero $out/bin/kero
                    runHook postInstall
                  '';
                  # Ghostty is loaded at runtime rather than linked into kero.
                  postFixup = ''
                    patchelf --add-rpath $out/lib/kero $out/lib/kero/kero
                  '';
                  meta = {
                    description = "Kero terminal sessions server";
                    homepage = "https://github.com/egoist/kero";
                    license = prev.lib.licenses.mit;
                    platforms = [ "x86_64-linux" ];
                    mainProgram = "kero";
                  };
                };
              hunk = getPkg inputs.hunk "default";
              wakatime-ls = getPkg inputs.wakatime-ls "default";
              # tombi = getPkg inputs.tombi "default";
              tsutsumi = getPkgs inputs.tsutsumi;
              helix =
                (inputs.helix-flake.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
                  grammarOverlays = [
                    (_: prev: {
                      perl = prev.perl.overrideAttrs (oldAttrs: {
                        postPatch = (oldAttrs.postPatch or "") + ''
                          substituteInPlace src/bsearch.c \
                            --replace-fail 'void *bsearch(' 'static void *tsp_bsearch('
                          substituteInPlace src/tsp_unicode.h \
                            --replace-fail 'bsearch(' 'tsp_bsearch('
                        '';
                      });
                    })
                  ];
                }).overrideAttrs
                  (oldAttrs: {
                    cargoBuildFlags = (oldAttrs.cargoBuildFlags or [ ]) ++ [
                      "--features"
                      "steel"
                    ];
                  });
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
        # cargo-semver-checks
      ];
      llmTools = with pkgs; [
        claude-code
        codex
        opencode
        codex-acp
        github-copilot-cli
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
        oxfmt
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
          inputs.skills-catalog.homeManagerModules.default
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
          inputs.skills-catalog.homeManagerModules.default
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
          inputs.skills-catalog.homeManagerModules.default
          ./home.nix
          inputs.zed-extensions.homeManagerModules.default
          (
            { pkgs, ... }:
            let
              zedExtensions =
                inputs.zed-extensions.legacyPackages.${pkgs.stdenv.hostPlatform.system}.zed-extensions;
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
                  pkg-config
                  rust-analyzer-nightly
                  llm-agents.agent-browser
                  nethogs
                  yarn-berry_4
                  sing-box
                ])
                ++ [
                  pkgs.hunk
                ];
              programs.zed-editor-extensions = {
                enable = true;
                packages = with zedExtensions; [
                  # dockerfile
                  emmet
                  html
                  just
                  lua
                  nix
                  oxc
                  tsgo
                ];
              };
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
