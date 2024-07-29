{
  pkgs,
  config,
  lib,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users.users.akselander = {
    isNormalUser = true;
    initialPassword = "12345";
    description = "akselander";
    shell = pkgs.fish;
    extraGroups =
      ["networkmanager" "wheel"]
      ++ ifTheyExist ["vrising"];
    openssh.authorizedKeys.keys = lib.splitString "\n" (builtins.readFile ./ssh.pub);
    packages = [pkgs.home-manager];
    hashedPasswordFile = "/persist/passwords/akselander";
  };

  home-manager.users.akselander = import ../../../../home/akselander/${config.networking.hostName}.nix;
  services.getty.autologinUser = "akselander";
  security.pam.services = {
    hyprlock = {};
  };
}
