{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [vesktop];
}
