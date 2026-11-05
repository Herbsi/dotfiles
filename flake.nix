{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    agenix.url = "github:ryantm/agenix";
    # Bare repo at the same path on both hosts: midori deploys from
    # its copy, kuro's mirror lets flake updates fetch it locally.
    # Push to both bares before bumping the bean-dashboard pin.
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
