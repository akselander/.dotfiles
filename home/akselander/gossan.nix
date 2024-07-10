{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./global
    ./features/desktop/hyprland
    ./features/desktop/wireless
    ./features/desktop/slack
  ];

  impermanence.data.directories = [
    {
      directory = "work";
      method = "symlink";
    }
  ];

  wallpaper = lib.mkDefault pkgs.wallpapers.outer-wilds;
  colorScheme = inputs.nix-colors.colorSchemes.rose-pine;

  #  ------   -----
  # | DP-2 | | DP-1|
  #  ------   -----
  #  ------
  # | eDP-1 |
  #  ------
  monitors = [
    {
      name = "eDP-1";
      width = 1920;
      height = 1200;
      refreshRate = 60.00;
      y = -1440;
      workspace = "8";
    }
    {
      name = "DP-2";
      width = 2560;
      height = 1440;
      refreshRate = 59.95;
      workspace = "1";
      primary = true;
    }
  ];
}
