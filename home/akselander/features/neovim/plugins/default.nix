{pkgs, ...}: {
  imports = [
    ./cloak.nix
    ./colors.nix
    ./fugitive.nix
    ./harpoon.nix
    ./lsp.nix
    ./neogen.nix
    ./neotest.nix
    ./refactoring.nix
    ./snippets.nix
    ./telescope.nix
    ./treesitter.nix
    ./trouble.nix
    ./undotree.nix
  ];

  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      plenary-nvim
    ];
  };
}
