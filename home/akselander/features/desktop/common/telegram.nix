{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [telegram-desktop];
  home.persistence = {
    "/persist/home/akselander".directories = [".local/share/TelegramDesktop"];
  };
}
