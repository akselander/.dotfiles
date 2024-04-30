{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  startScript = pkgs.writeShellScriptBin "start" ''
     ${pkgs.swww}/bin/swww init &

     ${pkgs.networkmanagerapplet}/bin/nm-applet --indicator &

     hyprctl setcursor Bibata-Modern-Ice 16 &

     systemctl --user import-environment PATH &
     systemctl --user restart xdg-desktop-portal.service &

     # wait a tiny bit for wallpaper
     sleep 2

    ${pkgs.swww}/bin/swww img ${./../prism/wallpapers/gruvbox-mountain-village.png} &

    ${config.myHomeManager.startupScript}
  '';

  hyprland = pkgs.inputs.hyprland.hyprland.override {wrapRuntimeDeps = false;};
  xdph = pkgs.inputs.hyprland.xdg-desktop-portal-hyprland.override {inherit hyprland;};
in {
  imports = [
    ../common
    ../common/wayland
    ./binds.nix
    ./hyprbars.nix
  ];

  xdg.portal = {
    extraPortals = [xdph];
    configPackages = [hyprland];
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland;
    plugins = [];
    systemd = {
      enable = true;
      # Same as default, but stop graphical-session too
      extraCommands = lib.mkBefore [
        "systemctl --user stop graphical-session.target"
        "systemctl --user start hyprland-session.target"
      ];
    };
    settings = {
      general = {
        cursor_inactive_timeout = 4;
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(${config.colorScheme.colors.base0A}ff) rgba(${config.colorScheme.colors.base0B}ff) 60deg";
        "col.inactive_border" = "rgba(${config.colorScheme.colors.base03}ff)";
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
        # "WLR_NO_HARDWARE_CURSORS,1"
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

      decoration = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

        rounding = 5;

        drop_shadow = true;
        shadow_range = 30;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
      };

      animations = {
        enabled = true;

        # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

        bezier = "myBezier, 0.25, 0.9, 0.1, 1.02";

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          # "workspaces, 1, 3, default, slidevert"
          # "workspaces, 1, 3, myBezier, slidefadevert"
          "workspaces, 1, 3, myBezier, fade"
        ];
      };

      dwindle = {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true; # you probably want this
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
          "$mainMod,S,exec,${grimblast} --freeze save area - | ${tesseract} - - | wl-copy && ${notify-send} -t 3000 'OCR result copied to buffer'"
        ]
        ++
        # Screen lock
        (
          let
            swaylock = lib.getExe config.programs.swaylock.package;
          in
            lib.optionals config.programs.swaylock.enable [
              ",XF86Launch5,exec,${swaylock} -S --grace 2"
              ",XF86Launch4,exec,${swaylock} -S --grace 2"
              "SUPER,backspace,exec,${swaylock} -S --grace 2"
            ]
        );
    };
  };
}
