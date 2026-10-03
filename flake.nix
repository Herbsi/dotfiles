{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    agenix.url = "github:ryantm/agenix";
    # Bare repo on midori, pushed from kuro: exists only there.
    # Inputs fetch lazily, so kuro evaluates fine, but the midori
    # configuration only builds on midori
    bean-dashboard.url = "git+file:///srv/bean-dashboard.git?ref=master";
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
          bean-dashboard = inputs.bean-dashboard;
        };
        modules = [
          ./hosts/midori/configuration.nix
          agenix.nixosModules.default
        ];
      };
    };
}
