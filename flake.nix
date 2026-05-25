{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.kuro = nixpkgs.lib.nixosSystem {
      modules = [ 
        ./hardware-configuration.nix
        ./configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            nixpkgs.config.allowUnfree = true;
          };
          home-manager.users.herwig = import ./home.nix;
        } 
      ];
    };
  };
}

