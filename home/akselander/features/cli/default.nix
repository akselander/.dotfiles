{pkgs, ...}: {
  imports = [
    ./git.nix
    ./ssh.nix
  ];
  home.packages = with pkgs; [
    ripgrep # Better grep
    jq # JSON pretty printer and manipulator

    nil # Nix LSP
    alejandra # Nix formatter
    nix-output-monitor
    nh # Nice wrapper for NixOS and HM
  ];
}
