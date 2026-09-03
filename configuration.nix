# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.systemPackages = with pkgs; [
    git wget vim curl foot hyprpaper kitty waybar neovim nodejs python3
    lua5_1 luarocks gcc gnumake unzip rofi hyprlock hypridle grim slurp
    wl-clipboard cliphist tree-sitter ripgrep lazygit gh

    # was "awww" in the original file - that package doesn't exist, this is
    # the wallpaper daemon your exec-once lines actually call
    swww
    
    adwaita-icon-theme
    hicolor-icon-theme
    papirus-icon-theme

    # everyday desktop-completeness tools
    pavucontrol      # GUI volume mixer
    playerctl        # media keys (play/pause/next/prev)
    brightnessctl    # brightness keys
    blueman          # bluetooth GUI (services.blueman.enable below starts the applet)
    polkit_gnome     # GUI auth prompts for privileged actions
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  environment.sessionVariables.NIXOS_OZONE_WL = 1;
  services.getty.autologinUser = "cocofioren";
  programs.nix-ld.enable = true;
  programs.zsh.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;
  networking.hostName = "dellillah";

  # Set your time zone.
  time.timeZone = "Indian/Antananarivo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "fr";

  users.users.cocofioren = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  };

  nixpkgs.config.allowUnfree = true;

  services.upower.enable = true;
  
  # Fonts
  fonts.packages = with pkgs; [
    rubik
    nerd-fonts.ubuntu
    nerd-fonts.jetbrains-mono
  ];

 
  # ---------------------------------------------------------------------
  # Audio (PipeWire) - needed for wpctl-based volume/mic keys to work
  # ---------------------------------------------------------------------
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true; # uncomment only if you actually run JACK apps
  };

  # ---------------------------------------------------------------------
  # Bluetooth
  # ---------------------------------------------------------------------
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # ---------------------------------------------------------------------
  # Privilege escalation prompts (GParted, network changes, etc.)
  # Pair this with the `polkit-gnome-authentication-agent-1` exec-once
  # line in hyprland.conf.
  # ---------------------------------------------------------------------
  security.polkit.enable = true;

  # ---------------------------------------------------------------------
  # Portals: screen sharing, GTK file pickers from non-GTK apps, etc.
  # ---------------------------------------------------------------------
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland xdg-desktop-portal-gtk ];
  };

  # dconf: lets GTK apps persist their settings (also required by several
  # GNOME-ish utilities the ii shell pulls in)
  programs.dconf.enable = true;

  # ---------------------------------------------------------------------
  # Removable media, trash, thumbnails - "everything a PC should have"
  # ---------------------------------------------------------------------
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # GPU acceleration (mesa is picked automatically for Intel/AMD; if you
  # have an NVIDIA card you'll want hardware.nvidia.* too - say the word
  # and I'll add it once I know the GPU)
  hardware.graphics.enable = true;

  # ---------------------------------------------------------------------
  # illogical-impulse prerequisites, per the soymou/illogical-flake README
  # ---------------------------------------------------------------------
  services.geoclue2.enable = true; # QtPositioning (weather widget etc.)

  # Printing - optional, uncomment if you ever need it
  # services.printing.enable = true;

  # ---------------------------------------------------------------------
  # Overlay: fixes illogical-flake issue #17 - kde-material-you-colors
  # (used by ii's dynamic wallpaper theming) fails to build because its
  # nixpkgs derivation is missing python-magic as a runtime dependency.
  # This adds it back via packageOverrides so every consumer of
  # python3Packages.kde-material-you-colors picks it up.
  # (home-manager.useGlobalPkgs = true in flake.nix makes sure your user's
  # home-manager pkgs sees this same overlay.)
  # ---------------------------------------------------------------------
  nixpkgs.overlays = [
    (final: prev: {
      python3 = prev.python3.override {
        packageOverrides = pyFinal: pyPrev: {
          kde-material-you-colors = pyPrev.kde-material-you-colors.overridePythonAttrs (old: {
            propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ pyFinal.python-magic ];
          });
        };
      };
      python3Packages = final.python3.pkgs;
    })
  ];

  # This option defines the first version of NixOS you have installed on
  # this particular machine - do NOT change this after the initial
  # install. See `man configuration.nix` for details.
  system.stateVersion = "26.05";
}

