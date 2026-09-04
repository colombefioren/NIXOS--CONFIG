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
hl.bind(mainMod .. "+SHIFT+R", hl.dsp.exec_cmd("killall qs quickshell; qs -c end4-pC &"), { description = "Reload shell" })
hl.unbind(mainMod .. "+S")
hl.bind(mainMod .. "+S",
  hl.dsp.exec_cmd([[mkdir -p ~/Pictures/Screenshots; f=~/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png; grim -g "$(slurp)" "$f" && wl-copy < "$f"]]),
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
hl.unbind(mainMod .. "+E")
hl.bind(mainMod .. "+E", hl.dsp.exec_cmd("nautilus"), { description = "Files: Nautilus" })
hl.bind(mainMod .. "+Y", hl.dsp.exec_cmd("kitty -1 fish -c yazi"), { description = "Files: Yazi" })
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

    cat > "$HOME/.config/hypr/custom/variables.lua" << 'LUAEOF'
hl.env("qsConfig", "end4-pC")
LUAEOF
    chmod u+w "$HOME/.config/hypr/custom/variables.lua"

    cat > "$HOME/.config/hypr/custom/late.lua" << 'LUAEOF'
hl.config({
  input = {
    kb_layout = "fr",
    touchpad = {
      natural_scroll = true,
    },
    sensitivity = 0.5,
    accel_profile = "flat",
  },
})

-- Glassmorphism: translucent windows with strong blur (loaded last, wins over shell defaults)
hl.config({
  decoration = {
    active_opacity = 0.92,
    inactive_opacity = 0.8,
    blur = {
      size = 10,
      ignore_opacity = true,
    },
  },
})

-- Brave: full opacity when active, like every other window when inactive
hl.window_rule({ match = { class = "^(brave-browser)$" }, opacity = "1 0.8" })
hl.window_rule({ match = { class = "^(brave)$" }, opacity = "1 0.8" })

-- btop: much more transparent so the blur shows through its very dark UI
hl.window_rule({ match = { title = "^btop$" }, opacity = "0.55 0.45" })

-- Nautilus: gnome-style floating centered window, big but not fullscreen
hl.window_rule({ match = { class = "^org.gnome.Nautilus$" }, float = true, center = true, size = { "(monitor_w*0.7)", "(monitor_h*0.75)" } })

-- Rofi launcher: blur behind it like the shell layers, clipped to its rounded shape
hl.layer_rule({ match = { namespace = "rofi" }, blur = true, ignore_alpha = 0.1 })

hl.gesture({
    fingers = 3,
    direction = "left",
    action = function()
        hl.dispatch(hl.dsp.focus({ workspace = "+1" }))
    end
})
hl.gesture({
    fingers = 3,
    direction = "right",
    action = function()
        hl.dispatch(hl.dsp.focus({ workspace = "-1" }))
    end
})
LUAEOF
    chmod u+w "$HOME/.config/hypr/custom/late.lua"
    if ! grep -q 'require("custom.late")' "$HOME/.config/hypr/hyprland.lua" 2>/dev/null; then
      echo 'require("custom.late")' >> "$HOME/.config/hypr/hyprland.lua"
    fi
    sed -i 's/action = "move"/action = "workspace"/' "$HOME/.config/hypr/hyprland/general.lua"
    sed -i 's/direction = "swipe"/direction = "vertical"/' "$HOME/.config/hypr/hyprland/general.lua"
    sed -i '/-- Disable blur for every window/,+1d' "$HOME/.config/hypr/hyprland/rules.lua"
  '';

  home.activation.installEnd4pC = lib.hm.dag.entryAfter [ "copyIllogicalImpulseConfigs" ] ''
    if [ ! -d "$HOME/.config/quickshell/end4-pC/.git" ]; then
      $DRY_RUN_CMD ${pkgs.git}/bin/git clone --depth 1 https://github.com/pctrade/end4-pC.git "$HOME/.config/quickshell/end4-pC" || true
    fi
    sed -i "s/primary_paletteKeyColor/primaryPaletteKeyColor/" "$HOME/.config/quickshell/end4-pC/scripts/colors/generate_colors_material.py"
    if ! grep -q 'magick png:' "$HOME/.config/quickshell/end4-pC/modules/common/utils/ScreenshotAction.qml" 2>/dev/null; then
      sed -i 's|const cropBase = `magick |const cropBase = `magick png:|' "$HOME/.config/quickshell/end4-pC/modules/common/utils/ScreenshotAction.qml"
    fi
    sed -i '/function screenshot() {/,/^    }/ s/if (Persistent.states.record.enable) {/{/' "$HOME/.config/quickshell/end4-pC/modules/ii/regionSelector/RegionSelector.qml"
  '';
  systemd.user.services.audio-volume-boost = {
    Unit = {
      Description = "Boost built-in audio volume to 150%";
      After = [ "wireplumber.service" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'export PATH=/run/current-system/sw/bin:$PATH; for i in $(seq 1 30); do id=$(wpctl status | sed -n \"/Sinks:/,/Sources:/p\" | grep \"Built-in Audio Analog Stereo\" | grep -oE \"[0-9]+\" | head -1); if [ -n \"$id\" ]; then sleep 2; wpctl set-volume \"$id\" 1.5; exit 0; fi; sleep 1; done; exit 1'";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

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
      background_opacity = "0.75";   # lower = more transparent
      dynamic_background_opacity = "yes";
    };
    extraConfig = ''
      include ~/.local/state/quickshell/user/generated/terminal/kitty-theme.conf
    '';
  };

  xdg.configFile."kitty/kitty.conf".force = true;

  xdg.configFile."rofi/config.rasi" = {
    force = true;
    text = ''
    @theme "/home/cocofioren/.local/share/rofi/themes/rounded-green-dark.rasi"

    configuration {
      show-icons: true;
      icon-theme: "Papirus-Dark";
      drun-display-format: "{icon} {name}";
      display-drun: "Apps";
    }
  '';
  };

  home.file.".local/share/rofi/themes/rounded-green-dark.rasi" = {
    force = true;
    text = ''
    /* ROUNDED THEME FOR ROFI */
    /* Author: Newman Sanchez (https://github.com/newmanls) */

    * {
        bg0:    #212121A0;
        bg1:    #2A2A2A;
        bg2:    #3D3D3D80;
        bg3:    #4CAF50F2;
        fg0:    #E6E6E6;
        fg1:    #FFFFFF;
        fg2:    #969696;
        fg3:    #3D3D3D;
    }

    @import "template/rounded-template.rasi"
  '';
  };

  xdg.configFile."gtk-3.0/settings.ini".force = true;
  xdg.configFile."gtk-4.0/settings.ini".force = true;

  xdg.configFile."gtk-4.0/gtk.css" = {
    force = true;
    text = ''
      /* ── Accent + palette ─────────────────────────────────────── */
      @define-color accent_color #4caf7d;
      @define-color accent_bg_color #2f6b47;
      @define-color accent_fg_color #ffffff;
      @define-color window_bg_color #10160f;
      @define-color window_fg_color #d9e6dc;
      @define-color view_bg_color #141d16;
      @define-color view_fg_color #d9e6dc;
      @define-color headerbar_bg_color #141d16;
      @define-color headerbar_fg_color #d9e6dc;
      @define-color headerbar_backdrop_color #10160f;
      @define-color headerbar_shade_color rgba(0,0,0,0.36);
      @define-color sidebar_bg_color #0c1210;
      @define-color sidebar_fg_color #cfe0d3;
      @define-color sidebar_backdrop_color #0c1210;
      @define-color popover_bg_color #182119;
      @define-color popover_fg_color #d9e6dc;
      @define-color popover_shade_color rgba(0,0,0,0.28);
      @define-color card_bg_color #172018;
      @define-color card_fg_color #d9e6dc;
      @define-color dialog_bg_color #141d16;
      @define-color dialog_fg_color #d9e6dc;
      @define-color border_color rgba(255,255,255,0.09);
      @define-color shade_color rgba(0,0,0,0.28);

      /* ── Popovers: round + shadow + padding ───────────────────── */
      popover,
      popover.background,
      popover.background:not(.menu) {
        border-radius: 14px;
        margin: 8px;
        padding: 0;
      }
      popover > contents,
      popover.background > contents {
        border-radius: 14px;
        box-shadow: 0 12px 40px rgba(0,0,0,0.55),
                    0 2px 8px rgba(0,0,0,0.3),
                    0 0 0 1px rgba(255,255,255,0.06);
        background-color: @popover_bg_color;
        padding: 6px;
      }
      popover > contents > box,
      popover.background > contents > box {
        padding: 4px;
      }

      /* Right-click context menus */
      popover.menu,
      popover.menu.background {
        border-radius: 14px;
        padding: 0;
      }
      popover.menu > contents,
      popover.menu.background > contents {
        border-radius: 14px;
        box-shadow: 0 12px 40px rgba(0,0,0,0.55),
                    0 2px 8px rgba(0,0,0,0.3),
                    0 0 0 1px rgba(255,255,255,0.06);
        background-color: @popover_bg_color;
        padding: 6px;
      }
      popover.menu > contents > box,
      popover.menu.background > contents > box {
        padding: 4px;
      }

      /* ── Menu items: spacing + hover ──────────────────────────── */
      popover.background menuitem,
      popover.background button.model {
        border-radius: 10px;
        padding: 6px 12px;
        margin: 1px 2px;
        min-height: 32px;
      }
      popover.background menuitem:hover,
      popover.background button.model:hover {
        background-color: @accent_bg_color;
      }
      popover.background separator {
        margin: 4px 8px;
        background-color: @border_color;
      }

      /* ── Cards ────────────────────────────────────────────────── */
      .card,
      .card.background,
      list > row,
      box.card {
        border-radius: 14px;
        border: 1px solid @border_color;
        background-color: @card_bg_color;
      }
      list > row:selected {
        background-color: alpha(@accent_color, 0.15);
      }
      list > row:hover {
        background-color: alpha(@accent_color, 0.06);
      }

      /* ── Dialogs ──────────────────────────────────────────────── */
      dialog,
      dialog.background,
      window.dialog,
      window.dialog > .background {
        border-radius: 16px;
        border: 1px solid @border_color;
      }
      dialog .dialog-action-area button {
        border-radius: 10px;
        margin: 4px;
        padding: 6px 16px;
        min-height: 34px;
      }
      dialog .dialog-action-area button:not(:last-child) {
        margin-right: 2px;
      }

      /* ── Buttons ──────────────────────────────────────────────── */
      button {
        border-radius: 10px;
        padding: 5px 14px;
        min-height: 30px;
        transition: background 150ms ease, box-shadow 150ms ease;
      }
      button.suggested-action,
      button.suggested-action.background {
        background-color: @accent_bg_color;
        color: @accent_fg_color;
      }
      button.suggested-action:hover {
        background-color: shade(@accent_bg_color, 1.15);
      }
      button.destructive-action,
      button.destructive-action.background {
        background-color: #a83242;
        color: #ffffff;
      }

      /* ── Nautilus headerbar ───────────────────────────────────── */
      .nautilus-window headerbar,
      .nautilus-window headerbar.background {
        border-radius: 0;
        border-bottom: 1px solid @border_color;
        padding: 4px 8px;
        min-height: 46px;
      }

      /* ── Nautilus path bar pills ──────────────────────────────── */
      .nautilus-path-bar button {
        border-radius: 8px;
        padding: 4px 12px;
        margin: 2px;
      }
      .nautilus-path-bar button:checked {
        background-color: alpha(@accent_color, 0.18);
        color: @accent_color;
      }
      .nautilus-path-bar button label {
        font-weight: 600;
      }

      /* ── Nautilus file grid ───────────────────────────────────── */
      .nautilus-grid-view,
      .nautilus-list-view {
        background-color: @view_bg_color;
      }
      .nautilus-grid-view .view,
      .nautilus-grid-view {
        padding: 8px;
      }
      .nautilus-grid-view > child {
        border-radius: 12px;
        padding: 12px;
        transition: background 150ms ease;
      }
      .nautilus-grid-view > child:hover {
        background-color: alpha(@accent_color, 0.06);
      }
      .nautilus-grid-view > child:selected {
        background-color: alpha(@accent_color, 0.15);
      }
      .nautilus-grid-view > child label {
        font-size: 13px;
      }

      /* ── Nautilus list rows ───────────────────────────────────── */
      .nautilus-list-view list row {
        border-radius: 8px;
        padding: 4px 12px;
        margin: 1px 4px;
        min-height: 36px;
      }
      .nautilus-list-view list row:hover {
        background-color: alpha(@accent_color, 0.06);
      }
      .nautilus-list-view list row:selected {
        background-color: alpha(@accent_color, 0.15);
      }

      /* ── Nautilus sidebar ─────────────────────────────────────── */
      .nautilus-window .sidebar,
      .nautilus-window navigation.sidebar,
      .nautilus-window .navigation-sidebar {
        background-color: @sidebar_bg_color;
        border-right: 1px solid @border_color;
      }
      .nautilus-window .sidebar row,
      .nautilus-window navigation.sidebar row {
        border-radius: 8px;
        margin: 1px 6px;
        padding: 6px 10px;
        min-height: 32px;
      }
      .nautilus-window .sidebar row:hover,
      .nautilus-window navigation.sidebar row:hover {
        background-color: alpha(@accent_color, 0.08);
      }
      .nautilus-window .sidebar row:selected,
      .nautilus-window navigation.sidebar row:selected {
        background-color: alpha(@accent_color, 0.16);
        color: @accent_color;
      }

      /* ── Nautilus search bar ──────────────────────────────────── */
      .nautilus-window searchbar,
      .nautilus-window .searchbar {
        background-color: @window_bg_color;
        border-bottom: 1px solid @border_color;
        padding: 8px 12px;
        border-radius: 0;
      }
      .nautilus-window searchbar > box,
      .nautilus-window .searchbar > box {
        border-radius: 10px;
        background-color: @view_bg_color;
        border: 1px solid @border_color;
        padding: 2px 8px;
      }

      /* ── Nautilus statusbar ───────────────────────────────────── */
      .nautilus-window .statusbar,
      .nautilus-window toolbarbar.bottom-bar {
        border-top: 1px solid @border_color;
        padding: 4px 12px;
      }

      /* ── Nautilus info pane ───────────────────────────────────── */
      .nautilus-window .floating-bar,
      .nautilus-window .info-bar {
        border-radius: 8px;
        margin: 4px 8px;
      }

      /* ── Tooltip ──────────────────────────────────────────────── */
      tooltip,
      tooltip.background,
      tooltip.background > contents {
        border-radius: 10px;
        padding: 6px 10px;
        background-color: @popover_bg_color;
        border: 1px solid @border_color;
        box-shadow: 0 4px 12px rgba(0,0,0,0.4);
      }

      /* ── Scrollbar ────────────────────────────────────────────── */
      scrollbar {
        background-color: transparent;
      }
      scrollbar slider {
        border-radius: 999px;
        min-width: 6px;
        min-height: 6px;
        margin: 2px;
        transition: background 200ms ease;
      }
      scrollbar slider:hover {
        background-color: alpha(@accent_color, 0.4);
      }
      scrollbar slider:active {
        background-color: alpha(@accent_color, 0.6);
      }

      /* ── Selection / highlight ────────────────────────────────── */
      selection,
      selection:focus {
        background-color: alpha(@accent_color, 0.3);
        color: @accent_fg_color;
      }
      textview text {
        caret-color: @accent_color;
      }

      /* ── Switch / toggle ──────────────────────────────────────── */
      switch {
        border-radius: 999px;
        min-width: 46px;
        min-height: 24px;
      }
      switch:checked {
        background-color: @accent_bg_color;
      }

      /* ── Scale (sliders) ──────────────────────────────────────── */
      scale slider {
        border-radius: 999px;
        min-width: 18px;
        min-height: 18px;
      }
      scale trough {
        border-radius: 999px;
        min-height: 6px;
      }

      /* ── Tab bar ──────────────────────────────────────────────── */
      tab {
        border-radius: 10px 10px 0 0;
        padding: 6px 16px;
      }
      tab:checked {
        background-color: @window_bg_color;
        border-bottom: 2px solid @accent_color;
      }

      /* ── Misc polish ──────────────────────────────────────────── */
      .titlebar:not(headerbar) {
        border-radius: 0;
      }
      .text-button:focus-visible,
      .text-button:hover,
      button:focus-visible {
        outline: 2px solid alpha(@accent_color, 0.5);
        outline-offset: 2px;
      }
    '';
  };

  gtk = {
    enable = true;
    gtk3 = {
      theme = {
        name = "Adwaita-dark";
      };
      iconTheme = {
        name = "Papirus-Dark";
      };
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
    gtk4 = {
      iconTheme = {
        name = "Papirus-Dark";
      };
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
  };

  home.file."qt6ct/qt6ct.conf" = {
    force = true;
    text = ''
      [Appearance]
      icon_theme=Papirus-Dark
    '';
  };

  home.sessionVariables = {
    GTK_THEME = "Adwaita:dark";
    ADW_DEBUG_COLOR_SCHEME = "prefer-dark";
  };

  programs.git = {
    enable = true;

    settings = {
      user.name = "colombefioren";
      user.email = "colomberakotonjanahary@gmail.com";

      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      fetch.prune = true;
      rerere.enabled = true;
    };
  };

  programs.fetch = {
    enable = true;
    labelColor = "cyan";
    speed = 1.0;
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "Adwaita-dark";
        accent-color = "green";
      };
      "org/gnome/nautilus/preferences" = {
        click-policy = "single";
      };
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

      if command -v fetch >/dev/null 2>&1 && [ -t 1 ] && [ -n "$WAYLAND_DISPLAY" ]; then
        fetch
      fi
    '';

    shellAliases = {
      btw = "echo i use hyprland btw";
      ls = "eza --icons";
      cat = "bat";
      nclean = "sudo nix-env -p /nix/var/nix/profiles/system --delete-generations old && sudo nix-collect-garbage -d && sudo nixos-rebuild switch --flake /etc/nixos#dellillah";
      nrs = "sudo nixos-rebuild switch --flake /etc/nixos#dellillah";
      end4pull = "cd ~/.config/quickshell/end4-pC && git pull";
      wvid = "$HOME/.config/quickshell/end4-pC/scripts/colors/switchwall.sh --mode dark $HOME/Downloads/wallpaper.mp4 >/dev/null 2>&1";
      wpic = "$HOME/.config/quickshell/end4-pC/scripts/colors/switchwall.sh --mode dark $HOME/Downloads/pokemon.png >/dev/null 2>&1";
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
    nautilus
    cmatrix

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

    go
    rustc
    cargo
    ruby
    perl

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
