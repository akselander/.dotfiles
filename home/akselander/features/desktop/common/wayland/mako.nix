{config, ...}: let
  inherit (config.colorScheme) palette;
in {
  services.mako = {
    enable = true;
    iconPath = "${config.gtk.iconTheme.package}/share/icons/${config.gtk.iconTheme.name}";
    font = "${config.fontProfiles.regular.family} 12";
    padding = "10,20";
    anchor = "top-center";
    width = 400;
    height = 150;
    borderSize = 2;
    defaultTimeout = 12000;
    backgroundColor = "#${palette.base00}";
    borderColor = "#${palette.base0B}";
    textColor = "#${palette.base05}";
    layer = "overlay";
  };
}
