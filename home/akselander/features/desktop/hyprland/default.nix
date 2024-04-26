{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  hyprland = pkgs.inputs.hyprland.hyprland.override {wrapRuntimeDeps = false;};
  xdph = pkgs.inputs.hyprland.xdg-desktop-portal-hyprland.override {inherit hyprland;};
in {
  imports = [
    ../common
    ../common/wayland
    ./binds.nix

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
      variables = ["--all"];
    };
    settings = {
      input = {
        kb_layout = "pl";
      };
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
        ];
      };

      bind = let
        defaultApp = type: "${lib.getExe pkgs.handlr-regex} launch ${type}";
      in
        [
          "SUPER,Return,exec,${defaultApp "x-scheme-handler/terminal"}"
          "SUPER,F,exec,firefox"
	];
    };
  };
}
