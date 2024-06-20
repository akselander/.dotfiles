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
  ];

  wallpaper = lib.mkDefault pkgs.wallpapers.outer-wilds;
  colorScheme = inputs.nix-colors.colorSchemes.rose-pine;
}