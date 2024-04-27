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
  #  ------   -----   ---------
  # | DP-2 | | DP-1| | HDMI-A-1|
  #  ------   -----   ---------
  monitors = [
    {
      name = "DP-1";
      width = 1920;
      height = 1080;
      refreshRate = "239.76Hz";
      x = 0;
      workspace = "1";
      primary = true;
    }
    {
      name = "DP-2";
      width = 2560;
      height = 1440;
      x = -1920;
      workspace = "2";
    }
    {
      name = "HDMI-A-1";
      width = 3840;
      height = 2160;
      x = 1920;
      workspace = "3";
      enabled = false;
    }
  ];
}
