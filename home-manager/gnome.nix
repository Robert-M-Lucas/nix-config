{
  pkgs,
  pkgs-unstable,
  ...
}
:
{
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
          pkgs.gnomeExtensions.osk-toggle.extensionUuid
          pkgs.gnomeExtensions.blur-my-shell.extensionUuid
          pkgs.gnomeExtensions.appindicator.extensionUuid
          pkgs.gnomeExtensions.shutdowntimer.extensionUuid

          # pkgs.gnomeExtensions.improved-osk.extensionUuid
          # pkgs.gnomeExtensions.custom-accent-colors.extensionUuid
          # Alternatively, you can manually pass UUID as a string.  
          # "blur-my-shell@aunetx"
          # ...
        ];
      };

      "org/gnome/desktop/wm/preferences" = {
        button-layout=":minimize,maximize,close";
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
        hot-sensors=["__network-rx_max__" "__temperature_avg__" "_processor_usage_" "_storage_free_" "_memory_available_"];
        hide-icons = false;
        icon-style = 0;
        menu-centered = false;
        position-in-panel = 0;
        use-higher-precision = true;
      };
      "org/gnome/desktop/input-sources" = { 
        xkb-options=["terminate:ctrl_alt_bksp" "caps:escape_shifted_capslock"];
      };

      # Configure individual extensions
      # dconf dump /
      "com/github/amezin/ddterm" = {
        ddterm-toggle-hotkey= ["<Primary>grave"];
        hide-animation="disable";
        shortcut-win-new-tab=["<Primary>t"];
        show-animation="disable";
        tab-policy="automatic";
        window-maximize=false;
        show-scrollbar=false;
        window-size=0.40553435114503816;
      };
      "org/gnome/shell/extensions/hidetopbar" = {
        enable-active-window=false;
        enable-intellihide=false;
      };
    };
  };
}