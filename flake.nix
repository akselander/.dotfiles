{
  description = "Your new nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware";
    impermanence.url = "github:nix-community/impermanence";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprwm-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    awscli-console = {
      url = "github:zoocha/awscli-console";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;
    systems = [
      "x86_64-linux"
    ];
    forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
    pkgsFor = lib.genAttrs systems (
      system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
    );
  in {
    inherit lib;
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;

    overlays = import ./overlays {inherit inputs outputs;};

    packages = forEachSystem (pkgs: import ./pkgs {inherit pkgs;});
    devShells = forEachSystem (pkgs: import ./shell.nix {inherit pkgs;});
    formatter = forEachSystem (pkgs: pkgs.alejandra);

    nixosConfigurations = {
      feldspar = lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./hosts/feldspar];
      };
    };

    homeConfigurations = {
      "akselander@feldspar" = lib.homeManagerConfiguration {
        modules = [./home/akselander/feldspar.nix];
        pkgs = pkgsFor.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs outputs;
        };
      };
    };
  };
}
