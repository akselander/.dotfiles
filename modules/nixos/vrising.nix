{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.vrising-server;
  wine = pkgs.wine.override { wineBuild = "wine64"; };
  shutdownScript =
    pkgs.writeShellScript "shutdown"
    ''
      PID=$(pgrep -f '^Z:\\var\\lib\\vrising\\server\\VRisingServer.exe')
      echo "Stopping PID: $PID"
      kill -SIGINT $PID

      # systemd will eventually kill this if it doesnt work after 90s
      while true; do
          sleep 1
          echo "Looking for VRising PID"
          PID=$(pgrep -f '^Z:\\var\\lib\\vrising\\server\\VRisingServer.exe')
          if [ -z "$PID" ]; then
              echo "Process successfully stopped gracefully"
              echo "Killing any leftover wine processes"
              wineserver -k
              sleep 1
              exit
          fi
          sleep 1
      done
    '';
in {
  options.services.vrising-server = {
    enable = mkEnableOption "V Rising Dedicated Server";

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to open ports in the firewall for the server
      '';
    };

    serverName = mkOption {
      type = types.str;
      default = "V Rising Game Server";
      description = ''
        Name of the server. The name that shows up in server list.
      '';
    };
    serverPort = mkOption {
      type = types.int;
      default = 21370;
      description = ''
        UDP port for game traffic.
      '';
    };
    queryPort = mkOption {
      type = types.int;
      default = 21371;
      description = ''
        UDP port for game traffic.
      '';
    };
    saveName = mkOption {
      type = types.str;
      default = "world1";
      description = ''
        Name of save file/directory. Must be a valid directory name.
      '';
    };
  };

  config = mkIf cfg.enable {

    systemd.services.vrising-server = let
      steamcmd = "${pkgs.steamcmd}/bin/steamcmd";
    in {
      description = "V Rising Dedicated Server";
      wantedBy = ["multi-user.target"];
      after = ["network.target"];

      serviceConfig = {
        ExecStart = ''
          ${pkgs.xvfb-run}/bin/xvfb-run --server-args="-screen 0 1024x768x16" \
          ${wine}/bin/wine64 /var/lib/vrising/server/VRisingServer.exe \
            -persistentDataPath Z:/var/lib/vrising/data \
            -serverName ${cfg.serverName} \
            -gamePort ${toString cfg.serverPort} \
            -queryPort ${toString cfg.queryPort} \
            -lowerFPSWhenEmpty true \
            -password kremowka \
            -saveName ${cfg.saveName} \
            -preset StandardPvP_NoSiege \
            -difficultyPreset Difficulty_Brutal
        '';
        ExecStop = "${pkgs.bash}/bin/bash ${shutdownScript}";
        Restart = "on-failure";
        RestartSec = "5";
        User = "vrising";
        WorkingDirectory = "/var/lib/vrising";
      };

      preStart = ''
        ${steamcmd} +@sSteamCmdForcePlatformType windows +force_install_dir "/var/lib/vrising/server" +login anonymous +app_update 1829350 validate +quit
      '';
    };

    users.users.vrising = {
      description = "V Rising server service user";
      home = "/var/lib/vrising";
      createHome = true;
      isSystemUser = true;
      group = "vrising";
    };
    users.groups.vrising = {};

    networking.firewall = mkIf cfg.openFirewall {
      allowedUDPPorts = [
        cfg.serverPort
        cfg.queryPort
      ];
    };
  };
}
