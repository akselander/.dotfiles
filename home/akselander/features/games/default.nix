{pkgs, ...}: {
  imports = [./steam-session.nix];
  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };

  home.packages = with pkgs; [
    gamescope
    steam
    protonup-ng
    mangohud
  ];

  impermanence.home.directories = [
    {
      directory = ".local/share/Steam";
      method = "symlink";
    }
  ];
}
