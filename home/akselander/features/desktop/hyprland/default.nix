{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../common
    ../common/wayland
    ./binds.nix
    # ./hyprbars.nix
  ];

  xdg.portal = let
    hyprland = config.wayland.windowManager.hyprland.package;
    xdph = pkgs.xdg-desktop-portal-hyprland.override {inherit hyprland;};
  in {
    extraPortals = [xdph];
    configPackages = [hyprland];
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland.override {wrapRuntimeDeps = false;};
    systemd = {
      enable = true;
      # Same as default, but stop graphical-session too
      extraCommands = lib.mkBefore [
        "systemctl --user stop graphical-session.target"
        "systemctl --user start hyprland-session.target"
      ];
    };

    settings = let
      active = "rgba(${config.colorScheme.palette.base0A}ff) rgba(${config.colorScheme.palette.base0B}ff) 60deg";
      inactive = "rgba(${config.colorScheme.palette.base03}ff)";
    in {
      general = {
        cursor_inactive_timeout = 4;
        gaps_in = 15;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = active;
        "col.inactive_border" = inactive;
      };
      group = {
        "col.border_active" = active;
        "col.border_inactive" = inactive;
        groupbar.font_size = 11;
      };

      monitor = let
        inherit (config.wayland.windowManager.hyprland.settings.general) gaps_in gaps_out;
        gap = gaps_out - gaps_in;
        inherit (config.programs.waybar.settings.primary) position height width;
        waybarSpace = {
          top =
            if (position == "top")
            then height + gap
            else 0;
          bottom =
            if (position == "bottom")
            then height + gap
            else 0;
          left =
            if (position == "left")
            then width + gap
            else 0;
          right =
            if (position == "right")
            then width + gap
            else 0;
        };
      in
        [
          ",addreserved,${toString waybarSpace.top},${toString waybarSpace.bottom},${toString waybarSpace.left},${toString waybarSpace.right}"
        ]
        ++ (map (
          m: "${m.name},${
            if m.enabled
            then "${toString m.width}x${toString m.height}@${toString m.refreshRate},${toString m.x}x${toString m.y},1"
            else "disable"
          }"
        ) (config.monitors));

      workspace =
        map
        (
          m: "${m.name},${m.workspace}"
        )
        (lib.filter (m: m.enabled && m.workspace != null) config.monitors);

      env = [
        "XCURSOR_SIZE,24"
        # "GDK_BACKEND,wayland,x11"
        # "SDL_VIDEODRIVER,wayland"
        # "CLUTTER_BACKEND,wayland"
        # "MOZ_ENABLE_WAYLAND,1"
        # "MOZ_DISABLE_RDD_SANDBOX,1"
        # "_JAVA_AWT_WM_NONREPARENTING=1"
        # "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        # "QT_QPA_PLATFORM,wayland"
        # "LIBVA_DRIVER_NAME,nvidia"
        # "GBM_BACKEND,nvidia-drm"
        # "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "WLR_NO_HARDWARE_CURSORS,1"
        # "__NV_PRIME_RENDER_OFFLOAD,1"
        # "__VK_LAYER_NV_optimus,NVIDIA_only"
        # "PROTON_ENABLE_NGX_UPDATER,1"
        # "NVD_BACKEND,direct"
        # "__GL_GSYNC_ALLOWED,1"
        # "__GL_VRR_ALLOWED,1"
        # "WLR_DRM_NO_ATOMIC,1"
        # "WLR_USE_LIBINPUT,1"
        # "XWAYLAND_NO_GLAMOR,1"
        # "__GL_MaxFramesAllowed,1"
        # "WLR_RENDERER_ALLOW_SOFTWARE,1"
      ];

      input = {
        kb_layout = "pl";
        kb_variant = "";
        kb_model = "";
        follow_mouse = 1;
        force_no_accel = 1;
        sensitivity = 0.000000;
      };

      dwindle = {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        split_width_multiplier = 1.35;
        pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true; # you probably want this
      };
      windowrulev2 = let
        steam = "title:^()$,class:^(steam)$";
      in [
        "stayfocused, ${steam}"
        "minsize 1 1, ${steam}"
      ];
      layerrule = [
        "animation fade,waybar"
        "blur,waybar"
        "ignorezero,waybar"
        "blur,notifications"
        "ignorezero,notifications"
        "blur,rofi"
        "ignorezero,rofi"
        "noanim,wallpaper"
      ];

      decoration = {
        active_opacity = 0.97;
        inactive_opacity = 0.77;
        fullscreen_opacity = 1.0;
        rounding = 7;
        blur = {
          enabled = true;
          size = 5;
          passes = 3;
          new_optimizations = true;
          ignore_opacity = true;
          popups = true;
        };
        drop_shadow = true;
        shadow_range = 12;
        shadow_offset = "3 3";
        "col.shadow" = "0x44000000";
        "col.shadow_inactive" = "0x66000000";
      };
      animations = {
        enabled = true;
        bezier = [
          "easein,0.11, 0, 0.5, 0"
          "easeout,0.5, 1, 0.89, 1"
          "easeinout,0.45, 0, 0.55, 1"
          "easeinback,0.36, 0, 0.66, -0.56"
          "easeoutback,0.34, 1.56, 0.64, 1"
          "easeinoutback,0.68, -0.6, 0.32, 1.6"
        ];

        animation = [
          "border,1,3,easeout"
          "workspaces,1,2,easeoutback,slide"
          "windowsIn,1,3,easeoutback,slide"
          "windowsOut,1,3,easeinback,slide"
          "windowsMove,1,3,easeoutback"
          "fadeIn,1,3,easeout"
          "fadeOut,1,3,easein"
          "fadeSwitch,1,3,easeinout"
          "fadeShadow,1,3,easeinout"
          "fadeDim,1,3,easeinout"
          "fadeLayersIn,1,3,easeoutback"
          "fadeLayersOut,1,3,easeinback"
          "layersIn,1,3,easeoutback,slide"
          "layersOut,1,3,easeinback,slide"
        ];
      };

      exec = ["${pkgs.swaybg}/bin/swaybg -i ${config.wallpaper} --mode fill"];
      "$mainMod" = "SUPER";

      bind = let
        grimblast = lib.getExe pkgs.inputs.hyprwm-contrib.grimblast;
        tesseract = lib.getExe pkgs.tesseract;
        notify-send = lib.getExe' pkgs.libnotify "notify-send";
        defaultApp = type: "${lib.getExe pkgs.handlr-regex} launch ${type}";
      in
        [
          "$mainMod,Return,exec,${defaultApp "x-scheme-handler/terminal"}"
          "$mainMod,e,exec,${defaultApp "text/plain"}"
          "$mainMod,b,exec,${defaultApp "x-scheme-handler/https"}"
          "$mainMod, D, exec, rofi -show drun -show-icons"
          # Screenshotting
          "$mainMod_SHIFT,S,exec,${grimblast} --notify --freeze copy area"
          "$mainMod_SHIFT,X,exec,${grimblast} --freeze save area - | ${tesseract} - - | wl-copy && ${notify-send} -t 3000 'OCR result copied to buffer'"
        ]
        ++
        # Notification manager
        (
          let
            makoctl = lib.getExe' config.services.mako.package "makoctl";
          in
            lib.optionals config.services.mako.enable ["$mainMod,w,exec,${makoctl} dismiss"]
        )
        ++
        # Screen lock
        (
          let
            swaylock = lib.getExe config.programs.swaylock.package;
          in
            lib.optionals config.programs.swaylock.enable [
              ",XF86Launch5,exec,${swaylock} -S --grace 2"
              ",XF86Launch4,exec,${swaylock} -S --grace 2"
              "$mainMod,backspace,exec,${swaylock} -S --grace 2"
            ]
        );
    };
  };
}
