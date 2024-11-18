#!/usr/bin/env bash

########################################################################
# File Name    : screen_three_horizontal_divisions.sh
# Description  : Divides the screen into three horizontal sections. Edit 
#                your shortcut keys settings adding the command to the 
#                path of your script.
# Dependencies : xdotool, wmctrl
# Usage        : • Make the script executable with 
#                sudo chmod +x screen_three_horizontal_divisions.sh
#                • Run the script with:
#                bash screen_three_horizontal_divisions.sh
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

# Get the screen dimensions
SCREEN_WIDTH=$(xdotool getdisplaygeometry | awk '{print $1}')
SCREEN_HEIGHT=$(xdotool getdisplaygeometry | awk '{print $2}')

# Calculate the height of each horizontal section
SECTION_HEIGHT=$((SCREEN_HEIGHT / 3))

# Get the active window ID
WINDOW_ID=$(xdotool getactivewindow)

# Move and resize the window to the first section
xdotool windowmove $WINDOW_ID 0 0
xdotool windowsize $WINDOW_ID $SCREEN_WIDTH $SECTION_HEIGHT

# Prompt to move to the next section
read -p "Move to the next section? (Press Enter to continue)"

# Get the active window ID
WINDOW_ID=$(xdotool getactivewindow)

# Move and resize the window to the second section
xdotool windowmove $WINDOW_ID 0 $SECTION_HEIGHT
xdotool windowsize $WINDOW_ID $SCREEN_WIDTH $SECTION_HEIGHT

# Prompt to move to the next section
read -p "Move to the next section? (Press Enter to continue

