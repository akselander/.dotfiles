{
  pkgs,
  config,
  ...
}: {
  gtk.enable = true;

  gtk.theme.package = pkgs.rose-pine-gtk-theme;
  gtk.theme.name = "rose-pine";

  gtk.cursorTheme.package = pkgs.bibata-cursors;
  gtk.cursorTheme.name = "Bibata-Modern-Ice";

  gtk.iconTheme.package = pkgs.rose-pine-icon-theme;
  gtk.iconTheme.name = "rose-pine";

  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
}
