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

    areofyl-fetch = {
      url = "github:areofyl/fetch";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };

  outputs = { self, nixpkgs, home-manager, illogical-flake, areofyl-fetch, zen-browser, ... }: {
    nixosConfigurations.dellillah = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.extraSpecialArgs = { inherit zen-browser; };

          home-manager.users.cocofioren = {
            imports = [
              illogical-flake.homeManagerModules.default
              areofyl-fetch.homeManagerModules.default
              ./home.nix
            ];
          };
        }
      ];
    };
  };
}
