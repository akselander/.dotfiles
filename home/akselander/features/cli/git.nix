{
  pkgs,
  config,
  ...
}: let
  ssh = "${pkgs.openssh}/bin/ssh";
in {
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = "Aleksander Kuźma";
    userEmail = "aleksander.a.kuzma@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";

      merge.conflictStyle = "zdiff3";
      commit.verbose = true;
      diff.algorithm = "histogram";
      log.date = "iso";
      column.ui = "auto";
      branch.sort = "committerdate";
      # Automatically track remote branch
      push.autoSetupRemote = true;
      # Reuse merge conflict fixes when rebasing
      rerere.enabled = true;
    };
    lfs.enable = true;
  };
}
