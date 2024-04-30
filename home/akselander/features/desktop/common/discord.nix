{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [vesktop];
  home.persistence = {
    "/persist/home/akselander".directories = [".config/vesktop"];
  };
}
