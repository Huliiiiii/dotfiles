{
  pkgs,
  lib,
  ...
}:
{
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
  systemd.user.services."cachix-watch-store-huliiiiii" = {
    Unit = {
      Description = "Cachix watch-store (huliiiiii)";
      Wants = [ "network-online.target" ];
      After = [ "network-online.target" ];
    };

    Service = {
      ExecStart = "${pkgs.cachix}/bin/cachix watch-store huliiiiii";
      Restart = "always";
      RestartSec = 2;
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
