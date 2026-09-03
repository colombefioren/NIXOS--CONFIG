{
  description = "dellillah - NixOS + Hyprland + illogical-impulse";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    illogical-flake = {
      url = "github:shuntia/illogical-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, illogical-flake, ... }: {
    nixosConfigurations.dellillah = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.cocofioren = {
            imports = [
              illogical-flake.homeManagerModules.default
              ./home.nix
            ];
          };
        }
      ];
    };
  };
}
