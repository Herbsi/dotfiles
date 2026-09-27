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
    let
      # bean-dashboard is a local flake that only exists on midori,
      # so it must not be a flake input: Nix fetches every input when
      # evaluating the flake, which would break builds on other hosts.
      # Resolving lazily keeps kuro (and machines without /srv) working.
      bean-dashboard =
        if builtins.pathExists /srv/bean-dashboard
        then builtins.getFlake "git+file:///srv/bean-dashboard?ref=master"
        else null;
    in
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
          inherit bean-dashboard;
        };
        modules = [
          ./hosts/midori/configuration.nix
          agenix.nixosModules.default
        ];
      };
    };
}
