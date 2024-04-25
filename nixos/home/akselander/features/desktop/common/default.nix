{ lib, pkgs, config, ... }:
{
  imports = [
    ./discord.nix
    ./firefox.nix
  ];
}
