{
  description = "dellillah - NixOS + Hyprland + illogical-impulse";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # illogical-flake: home-manager module that pulls in end-4's
    # "illogical impulse" Hyprland+QuickShell rice.
    #
    # NOTE: using shuntia's fork (main branch) instead of soymou's, because
    # it contains the fix for issue #21 ("nixos removed gtk-2" - the
    # upstream flake still references the now-removed gnome-icon-theme
    # package). shuntia's PR (soymou/illogical-flake#22) fixes this but is
    # still unmerged as of this writing. Once it's merged, you can switch
    # this back to "github:soymou/illogical-flake" and run
    # `nix flake update illogical-flake`.
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
          # Share the same (overlaid) pkgs between system and home-manager
          # so the python-magic overlay in configuration.nix also applies
          # inside your user's home-manager environment.
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          # This is the fix for illogical-flake issue #19 ("The option
          # `dconf' does not exist"): the illogical-impulse module is a
          # HOME-MANAGER module, not a NixOS module. It must be imported
          # here, inside home-manager.users.<name>, not dropped straight
          # into the top-level `modules` list of nixosSystem. Doing the
          # latter is exactly what triggers that error, because `dconf`
          # is only a valid option inside a home-manager context.
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

