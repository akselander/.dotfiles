{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.xremap-flake.homeManagerModules.default
  ];

  services.xremap = {
  };
}
