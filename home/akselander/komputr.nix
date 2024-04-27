{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./global
    ./features/desktop/hyprland
  ];

  wallpaper = lib.mkDefault pkgs.wallpapers.outer-wilds;
  colorscheme.source = config.wallpaper;
  #  ------   -----   ------
  # | DP-2 | | DP-1| | DP-3 |
  #  ------   -----   ------
  monitors = [
    {
      name = "DP-2";
      width = 2560;
      height = 1440;
      x = 0;
      workspace = "2";
    }
    {
      name = "DP-1";
      width = 1920;
      height = 1080;
      x = 1920;
      workspace = "1";
      primary = true;
      refreshRate = "239,76";
    }
    {
      name = "DP-3";
      width = 3840;
      height = 2160;
      x = 4480;
      workspace = "3";
      enabled = false;
    }
  ];
}
