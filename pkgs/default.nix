{pkgs ? import <nixpkgs> {}}: let
  inherit (pkgs) lib;
in rec {
  shellcolord = pkgs.callPackage ./shellcolord {};

  rose-pine-gtk = pkgs.callPackage ./rose-pine-gtk {
    themeVariant = ["Main-BL"];
  };
}
