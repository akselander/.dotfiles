{
  outputs,
  lib,
  ...
}: let
  hostnames = builtins.attrNames outputs.nixosConfigurations;
in {
  programs.ssh = {
    enable = true;
  };

  home.persistence = {
    "/persist/home/akselander".directories = [".ssh"];
  };
}
