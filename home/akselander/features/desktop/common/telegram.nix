{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [telegram-desktop];
  impermanence.cache.directories = [
    ".local/share/TelegramDesktop"
  ];
}
