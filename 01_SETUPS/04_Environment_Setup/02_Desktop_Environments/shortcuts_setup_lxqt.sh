#!/usr/bin/env bash

########################################################################
# File Name    : shortcuts_setup_lxqt.sh
# Description  : Script to add custom keyboard shortcuts in LXQt. Modify
#                the script to include specific shortcut configurations
#                as needed.
# Dependencies : LXQt (based on Debian system)
# Usage        : • Make the script executable with
#                chmod +x shortcuts_setup_lxqt.sh
#                • Run the script with:
#                bash shortcuts_setup_lxqt.sh
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

# This script sets up custom keyboard shortcuts in LXQt by modifying
# the globalkeyshortcuts.conf configuration file.
CONFIG_FILE="$HOME/.config/lxqt/globalkeyshortcuts.conf"

# Example shortcuts to add
SHORTCUTS="
[GlobalShortcuts]
Super+1=$HOME/.config/lxqt/screen_golden_ratio_division.sh
Super+2=$HOME/.config/lxqt/screen_three_vertical_divisions.sh
Super+3=$HOME/.config/lxqt//screen_three_horizontal_divisions.sh
Super+4=$HOME/.config/lxqt/screen_four_divisions.sh
Super+6=$HOME/.config/lxqt/screen_six_divisions.sh
"

# Use sed to append shortcuts to the configuration file
echo "$SHORTCUTS" | sudo sed -i \
    -e "/^\[GlobalShortcuts\]$/ r /dev/stdin" \
    "$CONFIG_FILE"

# Notify user of completion
echo "Keyboard shortcuts configured for LXQt."
echo "Restart your session to apply the changes."
