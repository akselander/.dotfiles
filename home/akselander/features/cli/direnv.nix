{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  impermanence.cache.directories = [".local/share/direnv/allow"];
}
