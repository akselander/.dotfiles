{
  config,
  pkgs,
  ...
}: let
  inherit (config.colorScheme) colors;
in {
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      effect-blur = "20x3";
      fade-in = 0.1;

      font = config.fontProfiles.regular.family;
      font-size = 15;

      line-uses-inside = true;
      disable-caps-lock-text = true;
      indicator-caps-lock = true;
      indicator-radius = 40;
      indicator-idle-visible = true;
      indicator-y-position = 1000;

      ring-color = "${colors.base0B}";
      inside-wrong-color = "${colors.base01}";
      ring-wrong-color = "${colors.base08}";
      key-hl-color = "${colors.base0A}";
      bs-hl-color = "${colors.base08}";
      ring-ver-color = "${colors.base0A}";
      inside-ver-color = "${colors.base01}";
      inside-color = "${colors.base01}";
      text-color = "${colors.base05}";
      text-clear-color = "${colors.base05}";
      text-ver-color = "${colors.base05}";
      text-wrong-color = "${colors.base08}";
      text-caps-lock-color = "${colors.base05}";
      inside-clear-color = "${colors.base01}";
      ring-clear-color = "${colors.base0D}";
      inside-caps-lock-color = "${colors.base01}";
      ring-caps-lock-color = "${colors.base09}";
      caps-lock-key-hl-color = "${colors.base0A}";
      caps-lock-bs-hl-color = "${colors.base08}";
      separator-color = "${colors.base01}";
    };
  };
}
