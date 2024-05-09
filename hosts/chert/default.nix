{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    ../common/global
    ../common/users/akselander

    ../common/optional/nuke-root.nix
  ];

  services.vrising-server.enable = true;

  networking = {
    hostName = "chert";
    networkmanager.enable = true;
  };

  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIDFHx1R9WUjlBiJ+3n7yyjTpnkIUN/iOn/jL/NCmCzJlAAAAFXNzaDpha3NlbGFuZGVyQGdpdGh1Yg=="
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIMt72Y0nV+sS70WKBfW4pInVR8UKtJL/Xt9MqvVOqJZQAAAAFXNzaDpha3NlbGFuZGVyQGdpdGh1Yg=="
  ];
  users.users.akselander.openssh.authorizedKeys.keys = [
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIDFHx1R9WUjlBiJ+3n7yyjTpnkIUN/iOn/jL/NCmCzJlAAAAFXNzaDpha3NlbGFuZGVyQGdpdGh1Yg=="
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIMt72Y0nV+sS70WKBfW4pInVR8UKtJL/Xt9MqvVOqJZQAAAAFXNzaDpha3NlbGFuZGVyQGdpdGh1Yg=="
  ];
  users.users.root.hashedPasswordFile = "/persist/passwords/root";
  users.users.akselander.hashedPasswordFile = "/persist/passwords/akselander";

  security.sudo.wheelNeedsPassword = false;
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
