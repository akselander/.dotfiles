{
  config,
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    bind = let
      hyprlock = lib.getExe config.programs.hyprlock.package;
    in
      lib.optionals config.programs.hyprlock.enable [
        ",XF86PowerOff,exec,${hyprlock}"
        "$mainMod,backspace,exec,${hyprlock}"
      ];
  };
  programs.hyprlock = let
    transparent = "0x00000000";
    opacity = "0x85";
  in {
    enable = true;

    settings = {
      general = {
        grace = 2;
        disable_loading_bar = false;
      };
      background = [
        {
          blur_passes = 2;
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
        }
      ];

      input-field = [
        {
          size = "250, 60";
          outline_thickness = 2;
          dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = true;
          outer_color = "rgba(0, 0, 0, 0)";
          inner_color = "rgba(100, 114, 125, 0.5)";
          font_color = "rgb(200, 200, 200)";
          fade_on_empty = false;
          # font_family = SF Pro Display Bold
          placeholder_text = "<i><span foreground=\"##ffffff99\">Hi, $USER</span></i>";
          hide_input = false;
          position = "0, -290";
          halign = "center";
          valign = "center";
        }
      ];

      label = [
        # Hour-Time
        {
          monitor = "";
          text = "cmd[update:1000] date +'%H'";
          color = "rgba(255, 185, 0, .6)";
          font_size = 180;
          # font_family = AlfaSlabOne
          position = "0, 160";
          halign = "center";
          valign = "center";
        }

        # Minute-Tine
        {
          monitor = "";
          text = "cmd[update:1000] date +'%M'";
          color = "rgba(255, 255, 255, .6)";
          font_size = 180;
          # font_family = AlfaSlabOne
          position = "0, -70";
          halign = "center";
          valign = "center";
        }

        # Day-Date-Month
        {
          monitor = "";
          text = "cmd[update:1000] echo \"<span color='##ffffff99'>$(date '+%A, ')</span><span color='##ffb90099'>$(date '+%d %B')</span>\"";
          font_size = 30;
          #font_family = SF Pro Display Bold
          position = "0, -80";
          halign = "center";
          valign = "center";
        }

        # USER
        {
          monitor = "";
          text = "  ";
          color = "rgba(255, 255, 255, .65)";
          font_size = 100;
          position = "0, -180";
          halign = "center";
          valign = "center";
        }

      ];
    };
  };
}
