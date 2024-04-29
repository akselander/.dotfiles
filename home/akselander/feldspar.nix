{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./global
    ./features/desktop/hyprland
    ./features/games
  ];

  wallpaper = lib.mkDefault pkgs.wallpapers.outer-wilds;
  colorscheme.source = config.wallpaper;
  #  ------   -----   ---------
  # | DP-2 | | DP-1| | HDMI-A-1|
  #  ------   -----   ---------
  monitors = [
    {
      name = "DP-1";
      width = 1920;
      height = 1080;
      refreshRate = "239.76";
      x = 0;
      workspace = "1";
      primary = true;
    }
    {
      name = "DP-2";
      width = 2560;
      height = 1440;
      refreshRate = "59.95";
      x = -2560;
      workspace = "2";
    }
    {
      name = "HDMI-A-1";
      width = 3840;
      height = 2160;
      x = 3840;
      workspace = "3";
      enabled = false;
      tv = true;
    }
  ];
}
