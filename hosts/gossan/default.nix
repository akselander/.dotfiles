{
  pkgs,
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.hardware.nixosModules.common-cpu-amd-pstate
    ./hardware-configuration.nix

    ../common/global
    ../common/users/akselander

    ../common/optional/bluetooth.nix
    ../common/optional/greetd.nix
    ../common/optional/pipewire.nix
    ../common/optional/quietboot.nix
    ../common/optional/tlp.nix
  ];

  impermanence.nukeRoot.enable = true;

  networking = {
    hostName = "gossan";
    networkmanager.enable = true;
  };

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  };

  programs = {
    dconf.enable = true;
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit = true;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
