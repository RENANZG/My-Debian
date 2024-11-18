#!/usr/bin/env bash

########################################################################
# File Name    : shortcuts_setup_xfce.sh
# Description  : Script to add custom keyboard shortcuts in Xfce. Modify
#                the script to include specific shortcut configurations
#                as needed.
# Dependencies : Xfce (based on Debian system)
# Usage        : • Make the script executable with
#                chmod +x shortcuts_setup_xfce.sh
#                • Run the script with:
#                bash shortcuts_setup_xfce.sh
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

# This script sets up custom keyboard shortcuts in Xfce by modifying
# the xfce4-keyboard-shortcuts.xml configuration file.
CONFIG_FILE="$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml"

# Example shortcuts to add
SHORTCUTS="
<property name=\"&lt;Super&gt;1\" type=\"string\" value=\"$HOME/.config/xfce4/screen_golden_ratio_division.sh\"/>
<property name=\"&lt;Super&gt;2\" type=\"string\" value=\"$HOME/.config/xfce4/screen_three_vertical_divisions.sh\"/>
<property name=\"&lt;Super&gt;3\" type=\"string\" value=\"$HOME/.config/xfce4/screen_three_horizontal_divisions.sh\"/>
<property name=\"&lt;Super&gt;4\" type=\"string\" value=\"$HOME/.config/xfce4/screen_four_divisions.sh\"/>
<property name=\"&lt;Super&gt;6\" type=\"string\" value=\"$HOME/.config/xfce4/screen_six_divisions.sh\"/>
"

# Use sed to append shortcuts to the configuration file
echo "$SHORTCUTS" | sudo sed -i \
    -e "/<\/channel>$/ i \\
$SHORTCUTS
" \
    "$CONFIG_FILE"

# Notify user of completion
echo "Keyboard shortcuts configured for Xfce."
echo "Restart your session to apply the changes."
