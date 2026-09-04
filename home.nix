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
      /* ════════════════════════════════════════════════════════════
         Monochrome libadwaita palette (Nautilus + all GTK4 apps)
         Neutral grays — no accent color, pure tonal design.
      ════════════════════════════════════════════════════════════ */

      /* ── Core palette (monochrome, warm-neutral tint) ───────────
         Backgrounds use ALPHA so Hyprland's glassmorphism blur
         (blur + translucent window) shows through everywhere —
         including popovers, dialogs and the headerbar. */
      @define-color accent_color #e8e8e8;
      @define-color accent_bg_color #6b6b6b;
      @define-color accent_fg_color #ffffff;

      @define-color window_bg_color rgba(17,17,19,0.86);
      @define-color window_fg_color #dcdcdc;

      @define-color view_bg_color rgba(21,21,23,0.82);
      @define-color view_fg_color #dcdcdc;

      @define-color headerbar_bg_color rgba(24,24,27,0.75);
      @define-color headerbar_fg_color #e2e2e2;
      @define-color headerbar_backdrop_color rgba(17,17,19,0.72);
      @define-color headerbar_shade_color rgba(0,0,0,0.35);

      @define-color sidebar_bg_color rgba(13,13,15,0.82);
      @define-color sidebar_fg_color #bfc0c2;
      @define-color sidebar_backdrop_color rgba(13,13,15,0.8);

      @define-color popover_bg_color rgba(28,28,31,0.72);
      @define-color popover_fg_color #dcdcdc;
      @define-color popover_shade_color rgba(0,0,0,0.3);

      @define-color card_bg_color rgba(24,24,27,0.72);
      @define-color card_fg_color #dcdcdc;

      @define-color dialog_bg_color rgba(24,24,27,0.72);
      @define-color dialog_fg_color #dcdcdc;

      @define-color border_color rgba(255,255,255,0.09);
      @define-color shade_color rgba(0,0,0,0.3);

      /* Uniform surface — every section (Home, Starred, Network…)
         renders on the same view tone so nothing looks flat/dull. */
      .view,
      list,
      listview,
      treeview.view,
      .content-view,
      window.background,
      window > .background,
      .background {
        background-color: @window_bg_color;
        color: @window_fg_color;
      }
      .view.background,
      .treeview.view,
      .content-view.view {
        background-color: @view_bg_color;
        color: @view_fg_color;
      }

      /* ════════════════════════════════════════════════════════════
         HEADERBAR — slimmest, blurred, buttons centered with title
      ════════════════════════════════════════════════════════════ */
      headerbar,
      .nautilus-window headerbar,
      .nautilus-window headerbar.background,
      window > headerbar.background {
        background-color: @headerbar_bg_color;
        color: @headerbar_fg_color;
        border: none;
        border-bottom: 1px solid @border_color;
        box-shadow: none;
        padding: 0 8px;
        min-height: 40px;
        max-height: 40px;
      }
      headerbar .title,
      .titlebar .title {
        font-weight: 650;
        font-size: 13px;
        letter-spacing: 0.2px;
        color: @headerbar_fg_color;
      }
      headerbar image,
      headerbar button {
        -gtk-icon-style: regular;
      }
      headerbar > box > button,
      headerbar button {
        min-height: 0;
        min-width: 0;
        padding: 6px 10px;
        margin: 0 1px;
        border-radius: 8px;
      }
      headerbar > box > button.image-button,
      headerbar button.image-button {
        min-height: 28px;
        min-width: 28px;
        padding: 4px;
      }
      .nautilus-path-bar {
        margin: 0 4px;
        padding: 0;
      }
      .nautilus-path-bar button {
        border-radius: 8px;
        padding: 3px 12px;
        margin: 0 1px;
        min-height: 28px;
        font-weight: 500;
        border: 1px solid transparent;
      }
      .nautilus-path-bar button:hover {
        background-color: rgba(255,255,255,0.06);
        border-color: @border_color;
      }
      .nautilus-path-bar button:checked,
      .nautilus-path-bar button.active {
        background-color: rgba(255,255,255,0.1);
        color: #ffffff;
        border-color: @border_color;
        font-weight: 600;
      }

      /* ════════════════════════════════════════════════════════════
         SIDEBAR — subtle, seamless across all bookmarks
      ════════════════════════════════════════════════════════════ */
      .sidebar,
      navigation.sidebar,
      .navigation-sidebar,
      .nautilus-window .sidebar,
      .nautilus-window navigation.sidebar {
        background-color: @sidebar_bg_color;
        color: @sidebar_fg_color;
        border: none;
        border-right: 1px solid @border_color;
      }
      .sidebar row,
      navigation.sidebar row {
        border-radius: 8px;
        margin: 1px 6px;
        padding: 7px 10px;
        min-height: 30px;
        color: @sidebar_fg_color;
      }
      .sidebar row:hover,
      navigation.sidebar row:hover {
        background-color: rgba(255,255,255,0.05);
      }
      .sidebar row:selected,
      navigation.sidebar row:selected,
      .sidebar row:active {
        background-color: rgba(255,255,255,0.12);
        color: #ffffff;
        font-weight: 600;
      }
      .sidebar row image {
        color: #9a9b9e;
      }
      .sidebar row:selected image {
        color: #ffffff;
      }

      /* ════════════════════════════════════════════════════════════
         POPOVERS & MENUS — truly rounded, spaced, padded
      ════════════════════════════════════════════════════════════ */
      popover,
      popover.background {
        border-radius: 14px;
        margin: 10px;
        padding: 0;
        background-color: transparent;
        box-shadow: none;
      }
      popover > contents,
      popover.background > contents {
        border-radius: 14px;
        background-color: rgba(28,28,31,0.55);
        color: @popover_fg_color;
        padding: 6px;
        box-shadow: 0 12px 34px rgba(0,0,0,0.45);
      }
      popover.menu > contents,
      popover.menu.background > contents {
        border-radius: 14px;
        background-color: rgba(28,28,31,0.55);
        padding: 6px;
        box-shadow: 0 12px 34px rgba(0,0,0,0.45);
      }
      popover > contents > box,
      popover.background > contents > box {
        padding: 4px;
      }
      popover.background menuitem,
      popover.background button.model,
      popover.background popover menu menuitem {
        border-radius: 9px;
        padding: 7px 12px;
        margin: 1px 2px;
        min-height: 30px;
        color: @popover_fg_color;
        font-size: 13.5px;
        background-color: transparent;
      }
      popover.background menuitem:hover,
      popover.background button.model:hover {
        background-color: rgba(255,255,255,0.08);
      }
      popover.background menuitem:disabled {
        color: rgba(220,220,220,0.4);
      }
      popover.background separator,
      popover.background > contents separator {
        min-height: 1px;
        margin: 5px 10px;
        background-color: @border_color;
      }

      /* ════════════════════════════════════════════════════════════
         DIALOGS — the pinnacle: rounded, spacious, padded
         (delete confirmation, prompts, etc.)
      ════════════════════════════════════════════════════════════ */
      dialog,
      dialog.background,
      message-dialog.background,
      window.dialog,
      window.dialog > .background,
      .dialog.background {
        border-radius: 18px;
        background-color: rgba(24,24,27,0.6);
        border: none;
        box-shadow: 0 18px 55px rgba(0,0,0,0.55);
      }
      dialog > .dialog-vbox,
      dialog .dialog-vbox {
        padding: 24px 24px 8px 24px;
      }
      dialog .dialog-vbox image {
        margin-bottom: 12px;
        opacity: 0.9;
      }
      dialog .dialog-vbox label.title,
      message-dialog .dialog-vbox label.title {
        font-size: 16px;
        font-weight: 700;
        margin-bottom: 8px;
      }
      dialog .dialog-vbox label,
      message-dialog .dialog-vbox label {
        font-size: 13.5px;
        color: rgba(220,220,220,0.9);
        line-height: 1.5;
      }
      dialog .dialog-action-area,
      message-dialog .dialog-action-area {
        padding: 10px 24px 20px 24px;
        border-top: 1px solid @border_color;
        background-clip: padding-box;
      }
      dialog .dialog-action-area button,
      message-dialog .dialog-action-area button {
        border-radius: 10px;
        margin: 4px;
        padding: 8px 20px;
        min-height: 36px;
        min-width: 100px;
        font-weight: 600;
      }
      dialog .dialog-action-area button:not(:last-child),
      message-dialog .dialog-action-area button:not(:last-child) {
        margin-right: 2px;
      }

      /* ════════════════════════════════════════════════════════════
         BUTTONS — consistent, tactile
      ════════════════════════════════════════════════════════════ */
      button {
        border-radius: 9px;
        padding: 6px 14px;
        min-height: 30px;
        border: 1px solid @border_color;
        color: @window_fg_color;
        background-color: rgba(255,255,255,0.03);
        transition: background 150ms ease, border-color 150ms ease;
      }
      button:hover {
        background-color: rgba(255,255,255,0.08);
        border-color: rgba(255,255,255,0.14);
      }
      button:active {
        background-color: rgba(255,255,255,0.12);
      }
      button:checked,
      button:checked:hover {
        background-color: rgba(255,255,255,0.16);
        color: #ffffff;
      }
      button.suggested-action,
      button.suggested-action.background {
        background-color: @accent_bg_color;
        color: @accent_fg_color;
        border: none;
      }
      button.suggested-action:hover {
        background-color: #7d7d7d;
      }
      button.destructive-action,
      button.destructive-action.background {
        background-color: #b0413e;
        color: #ffffff;
        border: none;
      }
      button.destructive-action:hover {
        background-color: #c0504c;
      }
      button.flat {
        background-color: transparent;
        border-color: transparent;
      }
      button.flat:hover {
        background-color: rgba(255,255,255,0.07);
      }
      button:focus-visible {
        outline: 2px solid rgba(255,255,255,0.4);
        outline-offset: 2px;
      }

      /* ════════════════════════════════════════════════════════════
         FILE GRID & LIST — airy, rounded, uniform background
      ════════════════════════════════════════════════════════════ */
      .nautilus-grid-view,
      .nautilus-list-view {
        background-color: @window_bg_color;
        padding: 12px;
      }
      .nautilus-grid-view > child {
        border-radius: 12px;
        padding: 12px;
        transition: background 150ms ease;
      }
      .nautilus-grid-view > child:hover {
        background-color: rgba(255,255,255,0.05);
      }
      .nautilus-grid-view > child:selected {
        background-color: rgba(255,255,255,0.12);
      }
      .nautilus-grid-view > child label {
        font-size: 13px;
        color: rgba(220,220,220,0.85);
      }
      .nautilus-grid-view > child:selected label {
        color: #ffffff;
        font-weight: 600;
      }
      .nautilus-list-view list row {
        border-radius: 9px;
        padding: 5px 12px;
        margin: 1px 4px;
        min-height: 38px;
        background-color: transparent;
      }
      .nautilus-list-view list row:hover {
        background-color: rgba(255,255,255,0.05);
      }
      .nautilus-list-view list row:selected {
        background-color: rgba(255,255,255,0.12);
      }

      /* Placeholder / empty-state (Starred, Network empty sections) */
      .nautilus-window .empty-state,
      .empty-state,
      .content-view .view + .empty-state {
        background-color: @window_bg_color;
        color: rgba(220,220,220,0.6);
      }

      /* ════════════════════════════════════════════════════════════
         SEARCH BAR
      ════════════════════════════════════════════════════════════ */
      .nautilus-window searchbar,
      .nautilus-window .searchbar {
        background-color: @window_bg_color;
        border-bottom: 1px solid @border_color;
        padding: 10px 14px;
      }
      .nautilus-window searchbar > box,
      .nautilus-window .searchbar > box {
        border-radius: 11px;
        background-color: @view_bg_color;
        border: 1px solid @border_color;
        padding: 3px 10px;
      }

      /* ════════════════════════════════════════════════════════════
         TOOLTIPS, SCROLLBARS, SWITCHES, SLIDERS
      ════════════════════════════════════════════════════════════ */
      tooltip,
      tooltip.background,
      tooltip.background > contents {
        border-radius: 9px;
        padding: 6px 10px;
        background-color: @popover_bg_color;
        border: 1px solid @border_color;
        box-shadow: 0 4px 14px rgba(0,0,0,0.45);
      }
      scrollbar {
        background-color: transparent;
      }
      scrollbar slider {
        border-radius: 999px;
        min-width: 6px;
        min-height: 6px;
        margin: 3px;
        background-color: rgba(255,255,255,0.2);
        transition: background 200ms ease;
      }
      scrollbar slider:hover {
        background-color: rgba(255,255,255,0.35);
      }
      switch {
        border-radius: 999px;
        min-width: 46px;
        min-height: 24px;
        background-color: rgba(255,255,255,0.18);
        border: none;
      }
      switch:checked {
        background-color: @accent_bg_color;
      }
      switch slider {
        border-radius: 999px;
        min-width: 20px;
        min-height: 20px;
        background-color: #ffffff;
        margin: 2px;
      }
      scale slider {
        border-radius: 999px;
        min-width: 18px;
        min-height: 18px;
        background-color: #ffffff;
        border: none;
      }
      scale trough {
        border-radius: 999px;
        min-height: 6px;
        background-color: rgba(255,255,255,0.15);
      }
      scale highlight,
      scale trough highlight {
        border-radius: 999px;
        background-color: @accent_bg_color;
      }

      /* ════════════════════════════════════════════════════════════
         TABS & CARDS
      ════════════════════════════════════════════════════════════ */
      tab {
        border-radius: 10px 10px 0 0;
        padding: 7px 18px;
      }
      tab:checked {
        background-color: @window_bg_color;
        border-bottom: 2px solid rgba(255,255,255,0.7);
        color: #ffffff;
      }
      .card,
      .card.background,
      box.card {
        border-radius: 14px;
        border: 1px solid @border_color;
        background-color: @card_bg_color;
        box-shadow: 0 2px 12px rgba(0,0,0,0.2);
      }
      list > row {
        border-radius: 9px;
        border: 1px solid transparent;
      }
      list > row:selected {
        background-color: rgba(255,255,255,0.12);
        border-color: @border_color;
      }
      list > row:hover {
        background-color: rgba(255,255,255,0.05);
      }

      /* ════════════════════════════════════════════════════════════
         SELECTION & CARET
      ════════════════════════════════════════════════════════════ */
      selection,
      selection:focus {
        background-color: #555555;
        color: #ffffff;
      }
      textview text {
        caret-color: #ffffff;
      }

      /* ════════════════════════════════════════════════════════════
         STATUS / INFO BARS
      ════════════════════════════════════════════════════════════ */
      .nautilus-window .statusbar,
      .nautilus-window toolbarbar.bottom-bar {
        border-top: 1px solid @border_color;
        padding: 5px 14px;
        color: rgba(220,220,220,0.7);
      }
      .nautilus-window .floating-bar,
      .nautilus-window .info-bar {
        border-radius: 12px;
        margin: 8px 12px;
        padding: 10px 16px;
        background-color: @popover_bg_color;
        border: 1px solid @border_color;
        box-shadow: 0 6px 24px rgba(0,0,0,0.4);
      }

      /* ── Focus / outline polish ───────────────────────────────── */
      .titlebar:not(headerbar) {
        border-radius: 0;
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

    loupe
    evince
    celluloid

    pavucontrol
    playerctl
    brightnessctl
    blueman

    adwaita-icon-theme
    hicolor-icon-theme
    papirus-icon-theme
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "image/jpeg" = [ "org.gnome.Loupe.desktop" ];
      "image/png" = [ "org.gnome.Loupe.desktop" ];
      "image/gif" = [ "org.gnome.Loupe.desktop" ];
      "image/webp" = [ "org.gnome.Loupe.desktop" ];
      "image/svg+xml" = [ "org.gnome.Loupe.desktop" ];

      "video/mp4" = [ "mpv.desktop" ];
      "video/x-matroska" = [ "mpv.desktop" ];
      "video/webm" = [ "mpv.desktop" ];
      "video/quicktime" = [ "mpv.desktop" ];

      "application/pdf" = [ "org.gnome.Evince.desktop" ];
    };
  };
  xdg.configFile."mimeapps.list".force = true;
  xdg.dataFile."applications/mimeapps.list".force = true;
}
