{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [obsidian];
  impermanence.cache.directories = [
    ".config/obsidian"
  ];
}
