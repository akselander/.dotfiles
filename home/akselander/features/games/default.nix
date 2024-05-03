{pkgs, ...}: {
  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };

  home.packages = with pkgs; [
    lutris
    steam
    steam-run
    protonup-ng
    gamemode
    dxvk

    gamescope


    steamPackages.steam-runtime
  ];
  home = {
    persistence = {
      "/persist/home/akselander" = {
        allowOther = true;
        directories = [
          {
            # Use symlink, as games may be IO-heavy
            directory = ".local/share/Steam";
            method = "symlink";
          }
        ];
      };
    };
  };
}
