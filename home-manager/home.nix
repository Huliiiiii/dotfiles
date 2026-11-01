{
  pkgs,
  lib,
  config,
  ...
}:
{
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
  home.packages = [ pkgs.kero ];
  home.file.".local/bin/kero" = {
    source = "${pkgs.kero}/bin/kero";
    force = true;
  };
  xdg.configFile."systemd/user/kerod.service".force = true;
  xdg.configFile."systemd/user/default.target.wants/kerod.service".force = true;
  systemd.user.services.kerod = {
    Unit = {
      Description = "Kero sessions (kerod)";
      Documentation = "https://github.com/egoist/kero/blob/main/docs/remote.md";
      X-SwitchMethod = "keep-old";
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.kero}/bin/kero daemon serve";
      Environment = [ "KERO_SERVICE=1" ];
      Restart = "always";
      RestartSec = 2;
      KillMode = "mixed";
      TimeoutStopSec = 15;
    };
    Install.WantedBy = [ "default.target" ];
  };
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
