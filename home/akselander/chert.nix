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
  ];

  colorScheme = inputs.nix-colors.colorSchemes.rose-pine;
}
