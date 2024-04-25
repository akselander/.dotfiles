{
  pkgs,
  config,
  lib,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  programs.zsh.enable = true;

  users.users.akselander = {
    isNormalUser = true;
    initialPassword = "12345";
    description = "akselander";
    shell = pkgs.zsh;
    extraGroups = ["networkmanager" "wheel"];
    packages = [pkgs.home-manager];
  };

  home-manager.users.akselander = import ../../../../home/akselander/${config.networking.hostName}.nix;
}
