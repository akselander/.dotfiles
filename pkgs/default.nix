{pkgs ? import <nixpkgs> {}}: let
  inherit (pkgs) lib;
in rec {
  shellcolord = pkgs.callPackage ./shellcolord {};
  wallpapers = import ./wallpapers {inherit pkgs;};
  allWallpapers = pkgs.linkFarmFromDrvs "wallpapers" (lib.attrValues wallpapers);
}
