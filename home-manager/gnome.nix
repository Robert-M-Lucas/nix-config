{
  pkgs,
  pkgs-unstable,
  is-pc,
  ...
}
: {
  dconf = {
    enable = true;
    settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false; # enables user extensions
        disable-extension-version-validation = true;
        enabled-extensions = [
          pkgs.gnomeExtensions.light-style.extensionUuid

          pkgs.gnomeExtensions.hide-top-bar.extensionUuid
          pkgs.gnomeExtensions.ddterm.extensionUuid
          pkgs.gnomeExtensions.caffeine.extensionUuid
          pkgs.gnomeExtensions.vitals.extensionUuid
          pkgs.gnomeExtensions.blur-my-shell.extensionUuid
          pkgs.gnomeExtensions.appindicator.extensionUuid
          pkgs.gnomeExtensions.color-picker.extensionUuid
          pkgs.gnomeExtensions.brightness-control-using-ddcutil.extensionUuid
          pkgs.gnomeExtensions.gsconnect.extensionUuid
          pkgs.gnomeExtensions.custom-command-toggle.extensionUuid
        ] ++ (if is-pc then [ ] else [  ]);
      };
      "org/gnome/shell/extensions/custom-command-toggle" = {
        checkexitcode1-setting=true;
        entryrow1-setting="nohup systemd-inhibit --what=handle-lid-switch --why=\"TEMP_LID_DISABLE\" sleep infinity & disown";
        entryrow2-setting="pkill -f \"TEMP_LID_DISABLE\"";
        entryrow3-setting="No Lid Sleep";
        entryrow4-setting="view-reveal-symbolic";
        initialtogglestate1-setting=1;
        togglestate1-setting=false;
      };
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = ["/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Super>period";
        command = "smile";
        name = "Emoji Picker";
      };
      "org/gnome/desktop/interface" = {
        show-battery-percentage = true;
        color-scheme = "";
      };
      "org/gnome/desktop/wm/preferences" = {
        button-layout = ":minimize,maximize,close";
      };

      "org/gnome/desktop/background" = {
        color-shading-type = "solid";
        picture-options = "zoom";
        picture-uri = "file:///home/robert/.background-image";
        picture-uri-dark = "file:///home/robert/.background-image";
      };
      "org/gnome/desktop/screensaver" = {
        color-shading-type = "solid";
        picture-options = "zoom";
        picture-uri = "file:///home/robert/.background-image";
        picture-uri-dark = "file:///home/robert/.background-image";
      };
      "org/gnome/shell/extensions/vitals" = {
        hot-sensors =
          if is-pc
          then [
            "_network_public_ip_"
            "_processor_usage_"
            "__temperature_max__"
            "_memory_available_"
            "_memory_swap_free_"
            "_storage_free_"
          ]
          else [
            "_network_public_ip_"
            "_processor_usage_"
            "__temperature_max__"
            "_memory_available_"
            "_memory_swap_free_"
            "_storage_free_"
            "_battery_time_left_"
          ];
        hide-icons = false;
        icon-style = 0;
        menu-centered = false;
        position-in-panel = 0;
        use-higher-precision = true;
        fixed-widths = false;
      };
      "org/gnome/desktop/input-sources" = {
        xkb-options = ["terminate:ctrl_alt_bksp" "caps:escape_shifted_capslock"];
      };
      "org/gnome/shell/extensions/display-brightness-ddcutil" = {
        allow-zero-brightness = true;
        button-location = 1;
        ddcutil-binary-path = "/run/current-system/sw/bin/ddcutil";
        ddcutil-queue-ms = 130.0;
        ddcutil-sleep-multiplier = 40.0;
        decrease-brightness-shortcut = ["<Control>XF86MonBrightnessDown"];
        disable-display-state-check = true;
        hide-system-indicator = true;
        increase-brightness-shortcut = ["<Control>XF86MonBrightnessUp"];
        position-system-menu = 3.0;
        show-all-slider = false;
        show-display-name = false;
        show-osd = true;
        show-value-label = true;
        step-change-keyboard = 2.0;
        verbose-debugging = false;
      };
      # Configure individual extensions
      # dconf dump /
      "com/github/amezin/ddterm" = {
        background-color = "rgb(31,31,31)";
        background-opacity = 1.0;
        bold-color-same-as-fg = true;
        cursor-colors-set = false;
        custom-font = "FiraCode Nerd Font Propo Medium 10";
        ddterm-toggle-hotkey = ["<Primary>grave"];
        foreground-color = "rgb(255,255,255)";
        hide-animation = "disable";
        notebook-border = false;
        palette = [
          "rgb(23,20,33)"
          "rgb(192,28,40)"
          "rgb(38,162,105)"
          "rgb(162,115,76)"
          "rgb(51,112,188)"
          "rgb(163,71,186)"
          "rgb(42,161,179)"
          "rgb(208,207,204)"
          "rgb(94,92,100)"
          "rgb(246,97,81)"
          "rgb(51,209,122)"
          "rgb(233,173,12)"
          "rgb(42,123,222)"
          "rgb(192,97,203)"
          "rgb(51,199,222)"
          "rgb(255,255,255)"
        ];
        shortcut-win-new-tab = ["<Primary>t"];
        show-animation = "disable";
        show-scrollbar = false;
        tab-policy = "automatic";
        theme-variant = "dark";
        transparent-background = false;
        use-system-font = false;
        use-theme-colors = false;
        window-maximize = false;
        window-size = 0.35553400000000002;
      };
      "org/gnome/shell/extensions/hidetopbar" = {
        enable-active-window = false;
        enable-intellihide = false;
      };
    };
  };
}
