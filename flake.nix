{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    agenix.url = "github:ryantm/agenix";
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      agenix,
      home-manager,
      ...
    }:
    {
      nixosConfigurations.kuro = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/kuro/configuration.nix
          agenix.nixosModules.default
        ];
      };

      nixosConfigurations.midori = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/midori/configuration.nix
          agenix.nixosModules.default
        ];
      };
    };
}
