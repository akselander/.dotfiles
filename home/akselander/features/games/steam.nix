{
  pkgs,
  lib,
  config,
  ...
}: let
  steam-with-pkgs = pkgs.steam.override {
    extraPkgs = pkgs:
      with pkgs; [
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
        gamescope
        mangohud
      ];
  };

  monitor = lib.head (lib.filter (m: m.primary) config.monitors);
  steam-session = let
    gamescope = lib.concatStringsSep " " [
      (lib.getExe pkgs.gamescope)
      "--output-width ${toString monitor.width}"
      "--output-height ${toString monitor.height}"
      "--framerate-limit ${toString monitor.refreshRate}"
      "--prefer-output ${monitor.name}"
      "--adaptive-sync"
      "--expose-wayland"
      "--hdr-enabled"
      "--steam"
    ];
    steam = lib.concatStringsSep " " [
      "steam"
      "steam://open/bigpicture"
    ];
  in
    pkgs.writeTextDir "share/wayland-sessions/steam-session.desktop" # ini

    ''
      [Desktop Entry]
      Name=Steam Session
      Exec=${gamescope} -- ${steam}
      Type=Application
    '';
  tv = lib.head (lib.filter (m: m.tv) config.monitors);
  steam-tv-session = let
    gamescope = lib.concatStringsSep " " [
      (lib.getExe pkgs.gamescope)
      "--output-width ${toString tv.width}"
      "--output-height ${toString tv.height}"
      "--framerate-limit ${toString tv.refreshRate}"
      "--prefer-output ${tv.name}"
      "--steam"
    ];
    steam = lib.concatStringsSep " " [
      "steam"
      "steam://open/bigpicture"
    ];
  in
    pkgs.writeTextDir "share/wayland-sessions/steam-tv-session.desktop" # ini

    ''
      [Desktop Entry]
      Name=Steam TV Session
      Exec=${gamescope} -- ${steam}
      Type=Application
    '';
in {
  home.packages = with pkgs; [
    steam-with-pkgs
    steam-session
    steam-tv-session
    gamescope
    mangohud
    protontricks
  ];
  home.persistence = {
    "/persist/home/akselander" = {
      allowOther = true;
      directories = [
        {
          # A couple of games don't play well with bindfs
          directory = ".local/share/Steam";
          method = "symlink";
        }
      ];
    };
  };
}
