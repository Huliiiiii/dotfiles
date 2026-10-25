{
  description = "Agent skills catalog";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agent-skills-nix = {
      url = "github:Kyure-A/agent-skills-nix";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emilkowalski-skills = {
      url = "github:emilkowalski/skills";
      flake = false;
    };
    interfaces-skills = {
      url = "github:jakubkrehel/skills";
      flake = false;
    };
    modern-web-guidance = {
      url = "github:GoogleChrome/modern-web-guidance";
      flake = false;
    };
    mattpocock-skills = {
      url = "github:mattpocock/skills/cbf6db4233c7e4202abaf79643f7ab395c75a2df";
      flake = false;
    };
    playwright-cli-skills = {
      url = "github:microsoft/playwright-cli/1c9b20e0c6172a04089ead714d0022cc68997913";
      flake = false;
    };
    wshobson-agents = {
      url = "github:wshobson/agents/56848874a27cf0812b20a067ff3cf4eb8e0a7858";
      flake = false;
    };
  };

  outputs =
    {
      agent-skills-nix,
      emilkowalski-skills,
      interfaces-skills,
      modern-web-guidance,
      mattpocock-skills,
      playwright-cli-skills,
      wshobson-agents,
      ...
    }:
    {
      homeManagerModules.default = {
        imports = [
          agent-skills-nix.homeManagerModules.default
          (import ./home-manager.nix {
            inherit
              emilkowalski-skills
              interfaces-skills
              modern-web-guidance
              mattpocock-skills
              playwright-cli-skills
              wshobson-agents
              ;
          })
        ];
      };
    };
}
