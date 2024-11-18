#!/usr/bin/env bash

########################################################################
# File Name    : screen_screen_six_division.sh
# Description  : Positions six windows in a 2x3 grid on the screen. Edit 
#                your shortcut keys settings adding the command to the 
#                path of your script.
# Dependencies : xdotool, wmctrl
# Usage        : • Make the script executable with 
#                sudo chmod +x screen_six_division.sh
#                • Run the script with:
#                bash screen_six_division.sh
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

# Get the screen dimensions
SCREEN_WIDTH=$(xdotool getdisplaygeometry | awk '{print $1}')
SCREEN_HEIGHT=$(xdotool getdisplaygeometry | awk '{print $2}')

# Calculate the width and height of each division
DIV_WIDTH=$(($SCREEN_WIDTH / 3))
DIV_HEIGHT=$(($SCREEN_HEIGHT / 2))

# Get the currently active window
ACTIVE_WINDOW=$(xdotool getactivewindow)

# Move and resize the active window to the first division
wmctrl -ir $ACTIVE_WINDOW -e 0,0,0,$DIV_WIDTH,$DIV_HEIGHT

# Find and position the other windows
for i in {2..6}
do
  WINDOW=$(wmctrl -l | awk -v line=$i 'NR==line{print $1}')
  COL=$((($i - 1) % 3))
  ROW=$((($i - 1) / 3))
  wmctrl -ir $WINDOW -e 0,$(($COL * $DIV_WIDTH)),$(($ROW * $DIV_HEIGHT)),$DIV_WIDTH,$DIV_HEIGHT
done
