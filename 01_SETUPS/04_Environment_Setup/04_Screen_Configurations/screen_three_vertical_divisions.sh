#!/usr/bin/env bash

########################################################################
# File Name    : screen_three_vertical_divisions.sh
# Description  : Positions three windows in vertical divisions on the
#                screen. Edit your shortcut keys settings adding the 
#                command to the path of your script.
# Dependencies : xdotool, wmctrl
# Usage        : • Make the script executable with 
#                sudo chmod +x screen_three_vertical_divisions.sh
#                • Run the script with:   
#                bash screen_three_vertical_divisions.sh
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

# Get the screen dimensions
SCREEN_WIDTH=$(xdotool getdisplaygeometry | awk '{print $1}')
SCREEN_HEIGHT=$(xdotool getdisplaygeometry | awk '{print $2}')

# Calculate the width of each division
DIV_WIDTH=$(($SCREEN_WIDTH / 3))

# Get the list of currently open windows
WINDOW_LIST=($(wmctrl -l | awk '{print $1}'))

# Loop through the first three windows and position them
for i in {0..2}; do
  wmctrl -ir ${WINDOW_LIST[i]} -e 0,$(($i * $DIV_WIDTH)),0,$DIV_WIDTH,$SCREEN_HEIGHT
done
