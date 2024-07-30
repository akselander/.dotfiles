{
  config,
  pkgs,
  ...
}: let
  inherit (config.colorScheme) palette;
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

      ring-color = "${palette.base0B}";
      inside-wrong-color = "${palette.base01}";
      ring-wrong-color = "${palette.base08}";
      key-hl-color = "${palette.base0A}";
      bs-hl-color = "${palette.base08}";
      ring-ver-color = "${palette.base0A}";
      inside-ver-color = "${palette.base01}";
      inside-color = "${palette.base01}";
      text-color = "${palette.base05}";
      text-clear-color = "${palette.base05}";
      text-ver-color = "${palette.base05}";
      text-wrong-color = "${palette.base08}";
      text-caps-lock-color = "${palette.base05}";
      inside-clear-color = "${palette.base01}";
      ring-clear-color = "${palette.base0D}";
      inside-caps-lock-color = "${palette.base01}";
      ring-caps-lock-color = "${palette.base09}";
      caps-lock-key-hl-color = "${palette.base0A}";
      caps-lock-bs-hl-color = "${palette.base08}";
      separator-color = "${palette.base01}";
    };
  };
}
