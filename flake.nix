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
          ./hardware-configuration.nix
          ./configuration.nix
          agenix.nixosModules.default
        ];
      };
    };
}
