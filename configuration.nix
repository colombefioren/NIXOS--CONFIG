{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.systemPackages = with pkgs; [
    git wget vim curl foot hyprpaper kitty waybar neovim nodejs python3
    lua5_1 luarocks gcc gnumake unzip rofi hyprlock hypridle grim slurp
    wl-clipboard cliphist tree-sitter ripgrep lazygit gh opencode

    awww

    adwaita-icon-theme
    hicolor-icon-theme
    papirus-icon-theme

    pavucontrol
    playerctl
    brightnessctl
    blueman
    polkit_gnome

    file findutils fd tree jq yq less bat zip p7zip xz gzip bzip2 zstd gnutar
    gnugrep gawk gnused coreutils binutils

    nmap socat tcpdump traceroute iproute2 dnsutils whois openssl inetutils
    gobuster ffuf nikto sqlmap httpie

    john hashcat gnupg age

    binwalk exiftool foremost sleuthkit testdisk libewf

    wireshark

    ghidra radare2 cutter

    gdb lldb cmake pkg-config patchelf checksec elfutils strace ltrace valgrind rr

    python3Packages.pip python3Packages.virtualenv

    openssh sshpass git-lfs zip jq yq fd bat

    imagemagick pngcheck optipng

    ffmpeg mediainfo

    util-linux parted gptfdisk

    man man-pages
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

  networking.networkmanager.enable = true;
  networking.hostName = "dellillah";

  time.timeZone = "Indian/Antananarivo";

  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "fr";

  users.users.cocofioren = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  };

  nixpkgs.config.allowUnfree = true;

  services.upower.enable = true;

  fonts.packages = with pkgs; [
    rubik
    nerd-fonts.ubuntu
    nerd-fonts.jetbrains-mono
  ];

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman.enable = true;

  security.polkit.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland xdg-desktop-portal-gtk ];
  };  programs.dconf.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Phone / MTP access (Android) + iPhone (usbmuxd)
  services.udev.packages = [ pkgs.libmtp ];
  services.usbmuxd.enable = true;

  hardware.graphics.enable = true;

  services.geoclue2.enable = true;

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

  system.stateVersion = "26.05";
}
