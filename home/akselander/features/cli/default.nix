{pkgs, ...}: {
  imports = [
    ./bash.nix
    ./fish.nix
    ./fzf.nix
    ./git.nix
    ./shellcolor.nix
    ./ssh.nix
    ./starship.nix
  ];
  home.packages = with pkgs; [
    ripgrep # Better grep
    jq # JSON pretty printer and manipulator

    nil # Nix LSP
    alejandra # Nix formatter
    nvd
    nix-output-monitor
    fastfetch
    nh # Nice wrapper for NixOS and HM
    awscli2
    inputs.awscli-console.default
  ];
}
