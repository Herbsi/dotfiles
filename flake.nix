{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    agenix.url = "github:ryantm/agenix";
    # Bare repo on midori, pushed from kuro: exists just there,
    # so evaluating nixosConfigurations.midori on other machines fails
    bean-dashboard.url = "git+file:///srv/bean-dashboard?ref=master";
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
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./hosts/midori/configuration.nix
          agenix.nixosModules.default
        ];
      };
    };
}
