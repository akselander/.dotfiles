{
  pkgs,
  lib,
  config,
  ...
}: let
  swaylock = "${config.programs.swaylock.package}/bin/swaylock -i ${config.wallpaper}";
  pgrep = "${pkgs.procps}/bin/pgrep";
  pactl = "${pkgs.pulseaudio}/bin/pactl";
  hyprctl = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl";
  swaymsg = "${config.wayland.windowManager.sway.package}/bin/swaymsg";

  isLocked = "${pgrep} -x ${swaylock}";
  lockTime = 4 * 60; # TODO: configurable desktop (10 min)/laptop (4 min)

  # Makes two timeouts: one for when the screen is not locked (lockTime+timeout) and one for when it is.
  afterLockTimeout = {
    timeout,
    command,
    resumeCommand ? null,
  }: [
    {
      timeout = lockTime + timeout;
      inherit command resumeCommand;
    }
    {
      command = "${isLocked} && ${command}";
      inherit resumeCommand timeout;
    }
  ];
in {
  services.swayidle = {
    enable = true;
    systemdTarget = "graphical-session.target";
    events =
      [
        {
          event = "lock";
          command = swaylock;
        }
      ]
      ++ (lib.optionals config.wayland.windowManager.hyprland.enable [
        {
          event = "before-sleep";
          command = "${swaylock} && ${hyprctl} dispatch dpms off";
        }
        {
          event = "after-resume";
          command = "${hyprctl} dispatch dpms on";
        }
      ])
      ++ (lib.optionals config.wayland.windowManager.sway.enable [
        {
          event = "before-sleep";
          command = "${swaylock} && ${swaymsg} 'output * dpms off'";
        }
        {
          event = "after-resume";
          command = "${swaymsg} 'output * dpms on'";
        }
      ]);
    timeouts =
      # Lock screen
      [
        {
          timeout = lockTime;
          command = "${swaylock} --daemonize --grace 15";
        }
      ]
      ++
      # Mute mic
      (afterLockTimeout {
        timeout = 10;
        command = "${pactl} set-source-mute @DEFAULT_SOURCE@ yes";
        resumeCommand = "${pactl} set-source-mute @DEFAULT_SOURCE@ no";
      })
      ++
      # Turn off displays (hyprland)
      (lib.optionals config.wayland.windowManager.hyprland.enable (afterLockTimeout {
        timeout = 40;
        command = "${hyprctl} dispatch dpms off";
        resumeCommand = "${hyprctl} dispatch dpms on";
      }))
      ++
      # Turn off displays (sway)
      (lib.optionals config.wayland.windowManager.sway.enable (afterLockTimeout {
        timeout = 40;
        command = "${swaymsg} 'output * dpms off'";
        resumeCommand = "${swaymsg} 'output * dpms on'";
      }));
  };
}
