#!/usr/bin/env bash

GTK_DIRS=("$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0")

for dir in "${GTK_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        for file in "gtk.css" "colors.css"; do
            if [ -f "$dir/$file" ]; then
                rm "$dir/$file"
                echo "Removed: $dir/$file"
            fi
        done
    fi
done

XSETTINGS_CONF="$HOME/.config/xsettingsd/xsettingsd.conf"
if [ -f "$XSETTINGS_CONF" ]; then
    rm "$XSETTINGS_CONF"
    echo "Removed: $XSETTINGS_CONF"
fi

echo "Resetting GNOME interface gsettings..."
gsettings reset org.gnome.desktop.interface cursor-theme
gsettings reset org.gnome.desktop.interface font-name
gsettings reset org.gnome.desktop.interface document-font-name
gsettings reset org.gnome.desktop.interface monospace-font-name

echo "gtk-icon-theme-name = \"Neuwaita\"" > "$HOME/.gtkrc-2.0"
echo "Updated: ~/.gtkrc-2.0"