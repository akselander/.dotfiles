{config, ...}: let
  inherit (config.colorScheme) colors;
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
    backgroundColor = "#${colors.base00}";
    borderColor = "#${colors.base0B}";
    textColor = "#${colors.base05}";
    layer = "overlay";
  };
}
