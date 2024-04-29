# This file (and the global directory) holds config that i use on all hosts
{
  pkgs,
  inputs,
  outputs,
  ...
}: {
  imports =
    [
      inputs.home-manager.nixosModules.home-manager
      ./fish.nix
      ./locale.nix
      ./nix.nix
      ./persistance.nix
      ./steam-hardware.nix
    ]
    ++ (builtins.attrValues outputs.nixosModules);

  home-manager.extraSpecialArgs = {
    inherit inputs outputs;
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  environment.systemPackages = with pkgs; [
    gcc
    gnumake
  ];

  hardware.enableRedistributableFirmware = true;
}
