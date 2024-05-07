{
  config,
  lib,
  ...
}: let
  palette = config.colorScheme.palette;
in {
  programs.shellcolor = {
    enable = true;
    settings = {
      base00 = palette.base00;
      base05 = palette.base05;

      base03 = palette.base03;
      base07 = palette.base07;

      base08 = palette.base08;
      base0B = palette.base0B;
      base0A = palette.base0A;
      base0D = palette.base0D;
      base0E = palette.base0E;
      base0C = palette.base0C;

      base09 = palette.base09;
      base0F = palette.base0F;
      base01 = palette.base01;
      base04 = palette.base04;
      base02 = palette.base02;
      base06 = palette.base06;
    };
  };
}
