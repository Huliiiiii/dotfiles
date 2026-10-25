{
  pkgs,
  lib,
  config,
  ...
}:
{
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  nix.gc.automatic = true;
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
  systemd.user.services.sing-box = {
    Unit = {
      Description = "sing-box proxy";
      After = [ "network.target" ];
    };

    Service = {
      ExecStart = "${pkgs.sing-box}/bin/sing-box run -c %h/.config/sing-box/config.json";
      Restart = "always";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
  home.file.".local/bin/codex" = {
    executable = true;

    text = ''
      #!${pkgs.runtimeShell}

      export HTTP_PROXY="http://127.0.0.1:7891"
      export HTTPS_PROXY="http://127.0.0.1:7891"
      export http_proxy="$HTTP_PROXY"
      export https_proxy="$HTTPS_PROXY"

      export NO_PROXY="127.0.0.1,localhost,::1"
      export no_proxy="$NO_PROXY"

      exec ${config.programs.codex.package}/bin/codex "$@"
    '';
  };
}
