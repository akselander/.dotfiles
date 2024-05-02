{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./discord.nix
    ./firefox.nix
    ./font.nix
    ./gtk.nix
    ./telegram.nix
  ];

  # Also sets org.freedesktop.appearance color-scheme
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

  xdg.portal.enable = true;
}
