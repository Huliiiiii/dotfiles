{
  description = "Home Manager configuration of Huliiiiii";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenix = {
      url = "github:nix-community/fenix/monthly";
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
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      fenix,
      ...
    }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [
          inputs.yazi.overlays.default
          fenix.overlays.default
          (
            _: prev:
            let
              getPkg = src: name: src.packages.${prev.system}.${name};
              getPkgs = src: src.packages.${prev.system};
            in
            {
              codex = getPkg inputs.codex "default";
              droid = getPkg inputs.llm-agents "droid";
              opencode = getPkg inputs.llm-agents "opencode";
              # tombi = getPkg inputs.tombi "default";
              tsutsumi = getPkgs inputs.tsutsumi;
            }
          )
        ];
        config.allowUnfree = true;
      };

    in
    {
      homeConfigurations."Huliiiiii" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
      };
    };
}
