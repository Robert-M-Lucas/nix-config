{
  pkgs,
  pkgs-unstable,
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
          # Put UUIDs of extensions that you want to enable here.
          # If the extension you want to enable is packaged in nixpkgs,
          # you can easily get its UUID by accessing its extensionUuid
          # field (look at the following example).

          pkgs.gnomeExtensions.hide-top-bar.extensionUuid
          pkgs.gnomeExtensions.ddterm.extensionUuid
          pkgs.gnomeExtensions.caffeine.extensionUuid
          pkgs.gnomeExtensions.vitals.extensionUuid
          # pkgs.gnomeExtensions.osk-toggle.extensionUuid
          pkgs.gnomeExtensions.blur-my-shell.extensionUuid
          pkgs.gnomeExtensions.appindicator.extensionUuid
          # pkgs.gnomeExtensions.shutdowntimer.extensionUuid
          pkgs.gnomeExtensions.color-picker.extensionUuid
          pkgs.gnomeExtensions.brightness-control-using-ddcutil.extensionUuid
          # pkgs.gnomeExtensions.desktop-clock.extensionUuid
          # pkgs.gnomeExtensions.wintile-beyond.extensionUuid

          # pkgs.gnomeExtensions.improved-osk.extensionUuid
          # pkgs.gnomeExtensions.custom-accent-colors.extensionUuid
          # Alternatively, you can manually pass UUID as a string.
          # "blur-my-shell@aunetx"
          # ...
        ];
      };
      "org/gnome/desktop/interface" = {
        show-battery-percentage = true;
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
        hot-sensors = ["__network-rx_max__" "_processor_usage_" "_storage_free_" "_memory_available_" "__temperature_max__"];
        hide-icons = false;
        icon-style = 0;
        menu-centered = false;
        position-in-panel = 0;
        use-higher-precision = true;
      };
      "org/gnome/desktop/input-sources" = {
        xkb-options = ["terminate:ctrl_alt_bksp" "caps:escape_shifted_capslock"];
      };
      "org/gnome/shell/extensions/display-brightness-ddcutil" = {
        allow-zero-brightness=true;
        button-location=1;
        ddcutil-binary-path="/run/current-system/sw/bin/ddcutil";
        ddcutil-queue-ms=130.0;
        ddcutil-sleep-multiplier=40.0;
        decrease-brightness-shortcut=["<Control>XF86MonBrightnessDown"];
        disable-display-state-check=true;
        hide-system-indicator=true;
        increase-brightness-shortcut=["<Control>XF86MonBrightnessUp"];
        position-system-menu=3.0;
        show-all-slider=false;
        show-display-name=false;
        show-osd=true;
        show-value-label=true;
        step-change-keyboard=2.0;
        verbose-debugging=false;
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
        palette = ["rgb(23,20,33)" "rgb(192,28,40)" "rgb(38,162,105)" "rgb(162,115,76)" "rgb(18,72,139)" "rgb(163,71,186)" "rgb(42,161,179)" "rgb(208,207,204)" "rgb(94,92,100)" "rgb(246,97,81)" "rgb(51,209,122)" "rgb(233,173,12)" "rgb(42,123,222)" "rgb(192,97,203)" "rgb(51,199,222)" "rgb(255,255,255)"];
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
