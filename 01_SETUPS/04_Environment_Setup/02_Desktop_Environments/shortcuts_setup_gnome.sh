#!/usr/bin/env bash

########################################################################
# File Name    : shortcuts_setup_gnome.sh
# Description  : Script to add custom keyboard shortcuts in GNOME.
#                Modify the script to include specific shortcut
#                configurations as needed.
# Dependencies : GNOME (based on Debian system)
# Usage        : • Make the script executable with
#                chmod +x shortcuts_setup_gnome.sh
#                • Run the script with:
#                bash shortcuts_setup_gnome.sh
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

# This script sets up custom keyboard shortcuts in GNOME by using
# gsettings to modify the org.gnome.desktop.wm.keybindings schema.

# Example shortcuts to add
SHORTCUTS="
['<Super>1', '/path/to/screen_golden_ratio_division.sh'],
['<Super>2', '/path/to/screen_three_vertical_divisions.sh'],
['<Super>3', '/path/to/screen_three_horizontal_divisions.sh'],
['<Super>4', '/path/to/screen_four_divisions.sh'],
['<Super>6', '/path/to/screen_six_divisions.sh']
"

# Loop through each shortcut and add it
for shortcut in "${SHORTCUTS[@]}"; do
    key=$(echo "$shortcut" | cut -d, -f1 | sed "s/'//g")
    script=$(echo "$shortcut" | cut -d, -f2 | sed "s/',//g")
    gsettings set org.gnome.desktop.wm.keybindings "$key" "$script"
done

# Notify user of completion
echo "Keyboard shortcuts configured for GNOME."
echo "Restart your session to apply the changes."
