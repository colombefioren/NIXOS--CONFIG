{ config, lib, pkgs, ... }:

{
  home.username = "cocofioren";
  home.homeDirectory = "/home/cocofioren";
  home.stateVersion = "26.05";

  home.activation.writeMyHyprKeybinds = lib.hm.dag.entryAfter [ "copyIllogicalImpulseConfigs" ] ''
    mkdir -p "$HOME/.config/hypr/custom"
    cat > "$HOME/.config/hypr/custom/keybinds.lua" << 'LUAEOF'
local mainMod = "SUPER"

hl.config({
  input = {
    kb_layout = "fr",
    touchpad = {
      clickfinger_behavior = true,
      natural_scroll = true,
    },
  },
})

hl.unbind(mainMod .. "+RETURN")
hl.unbind(mainMod .. "+Return")

hl.bind(mainMod .. "+RETURN", hl.dsp.exec_cmd("kitty"))

hl.bind(mainMod .. "+A", hl.dsp.exec_cmd("qs -c end4-pC ipc call sidebarLeft toggle"), { description = "Left sidebar" })
hl.bind(mainMod .. "+N", hl.dsp.exec_cmd("qs -c end4-pC ipc call sidebarRight toggle"), { description = "Right sidebar" })
hl.bind(mainMod .. "+L", hl.dsp.exec_cmd("qs -c end4-pC ipc call lock activate"), { description = "Lock screen" })
hl.bind(mainMod .. "+Escape", hl.dsp.exec_cmd("qs -c end4-pC ipc call settingsToggle"), { description = "Settings" })
hl.bind(mainMod .. "+comma", hl.dsp.exec_cmd("qs -c end4-pC ipc call bar toggle"), { description = "Toggle bar" })
hl.bind(mainMod .. "+SHIFT+R", hl.dsp.exec_cmd("killall qs; ~/run-qs.sh -c end4-pC &"), { description = "Reload shell" })

hl.bind(mainMod .. "+S",
  hl.dsp.exec_cmd([[grim -g "$(slurp)" ~/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png && wl-copy < ~/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png]]),
  { description = "Screenshot region" })

hl.bind(mainMod .. "+V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. "+F", hl.dsp.window.fullscreen({ action = "toggle" }))

hl.bind(mainMod .. "+U", hl.dsp.window.resize({ x = -50, y = 0 }))
hl.bind(mainMod .. "+I", hl.dsp.window.resize({ x = 50, y = 0 }))
hl.bind(mainMod .. "+O", hl.dsp.window.resize({ x = 0, y = -50 }))
hl.bind(mainMod .. "+P", hl.dsp.window.resize({ x = 0, y = 50 }))

hl.bind(mainMod .. "+ALT+left",  hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. "+ALT+right", hl.dsp.window.swap({ direction = "right" }))
hl.bind(mainMod .. "+ALT+up",    hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. "+ALT+down",  hl.dsp.window.swap({ direction = "down" }))

hl.bind(mainMod .. "+SHIFT+left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. "+SHIFT+right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. "+SHIFT+up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. "+SHIFT+down",  hl.dsp.window.move({ direction = "down" }))

hl.bind(mainMod .. "+Q", hl.dsp.window.close())
hl.bind(mainMod .. "+SPACE", hl.dsp.exec_cmd("rofi -show drun"))
hl.bind(mainMod .. "+B", hl.dsp.exec_cmd("brave"))

hl.bind(mainMod .. "+SHIFT+1", hl.dsp.window.move({ workspace = "1", follow = true }))
hl.bind(mainMod .. "+SHIFT+2", hl.dsp.window.move({ workspace = "2", follow = true }))

hl.bind(mainMod .. "+right", hl.dsp.window.cycle_next({ next = true }))
hl.bind(mainMod .. "+left",  hl.dsp.window.cycle_next({ false }))
hl.bind(mainMod .. "+down",  hl.dsp.window.cycle_next({ next = true }))
hl.bind(mainMod .. "+up",    hl.dsp.window.cycle_next({ false }))

for i = 1, 10 do
  hl.bind(mainMod .. "+F" .. i, hl.dsp.window.move({ workspace = tostring(i), follow = true }))
end
LUAEOF
    chmod u+w "$HOME/.config/hypr/custom/keybinds.lua"
  '';

  programs.illogical-impulse.enable = true;

  programs.kitty = {
    enable = true;
    settings = {
      shell = "${pkgs.zsh}/bin/zsh";
      allow_remote_control = "yes";
      confirm_os_window_close = 0;
      cursor_shape = "beam";
      cursor_blink_interval = "0.5";
      cursor_trail = 3;
      cursor_trail_decay = "0.1 0.45";
      cursor_trail_start_threshold = 2;
    };
  };

  xdg.configFile."kitty/kitty.conf".force = true;

  programs.git = {
    enable = true;

    userName = "colombefioren";
    userEmail = "colomberakotonjanahary@gmail.com";

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      fetch.prune = true;
      rerere.enabled = true;
    };
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initContent = ''
      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
      [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

      for seq_file in ~/.cache/matugen/sequences ~/.cache/wal/sequences ~/.cache/wallust/sequences; do
        if [[ -f "$seq_file" ]]; then
          cat "$seq_file"
        fi
      done

      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8,bold"
    '';

    shellAliases = {
      btw = "echo i use hyprland btw";
      ls = "eza --icons";
      cat = "bat";
      nclean = "sudo nix-env -p /nix/var/nix/profiles/system --delete-generations old && sudo nix-collect-garbage -d && sudo nixos-rebuild switch --flake /etc/nixos#dellillah";
      nrs = "sudo nixos-rebuild switch --flake /etc/nixos#dellillah";
      wvid = "$HOME/.config/quickshell/ii/scripts/colors/switchwall.sh $HOME/Downloads/wallpaper.mp4 >/dev/null 2>&1";
      wpic = "$HOME/.config/quickshell/ii/scripts/colors/switchwall.sh $HOME/Downloads/wallpaper.png >/dev/null 2>&1";
    };

    profileExtra = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec start-hyprland
      fi
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  home.packages = with pkgs; [
    ripgrep
    fd
    bat
    eza
    btop
    yazi
    lazygit
    fastfetch
    fzf
    zoxide

    git
    gh
    git-lfs

    neovim
    tree-sitter
    gnumake
    cmake
    pkg-config
    unzip
    zip
    wget
    curl

    clang
    clang-tools
    lldb
    gdb
    ninja

    uv

    jdk17
    maven
    gradle

    nodejs
    typescript
    typescript-language-server

    alejandra
    nixfmt-rfc-style
    stylua
    shfmt
    shellcheck

    jq
    yq
    just
    direnv
    nix-direnv

    wl-clipboard
    cliphist

    brave
    vscode
    mpvpaper
    mpv

    pavucontrol
    playerctl
    brightnessctl
    blueman

    adwaita-icon-theme
    hicolor-icon-theme
    papirus-icon-theme
  ];
}
