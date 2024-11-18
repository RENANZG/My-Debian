#!/usr/bin/env bash

########################################################################
# File Name    : screen_four_divisions.sh
# Description  : Interactively positions four selected windows in a 2x2 
#                grid on the screen. Lists available windows for 
#                selection and brings each selected window to the 
#                foreground before positioning. Add the script to a 
#                shortcut bind or include it in `.bashrc`.
# Dependencies : xdotool, wmctrl
# Usage        : • Make the script executable with 
#                sudo chmod +x screen_four_divisions.sh
#                • Run the script with:   
#                bash screen_four_divisions.sh
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

# User-defined settings
TASKBAR_HEIGHT_BOTTOM=45  # Height of the taskbar at the bottom (in pixels)
TASKBAR_HEIGHT_TOP=0      # Height of the taskbar at the top (in pixels)
TASKBAR_WIDTH_LEFT=0      # Width of the taskbar on the left (in pixels)
TASKBAR_WIDTH_RIGHT=0     # Width of the taskbar on the right (in pixels)

# Get the screen dimensions
SCREEN_GEOMETRY=$(xdotool getdisplaygeometry)
SCREEN_WIDTH=$(echo $SCREEN_GEOMETRY | awk '{print $1}')
SCREEN_HEIGHT=$(echo $SCREEN_GEOMETRY | awk '{print $2}')

# Adjust screen dimensions for taskbars
ADJUSTED_SCREEN_HEIGHT=$(($SCREEN_HEIGHT - $TASKBAR_HEIGHT_BOTTOM - $TASKBAR_HEIGHT_TOP))
ADJUSTED_SCREEN_WIDTH=$(($SCREEN_WIDTH - $TASKBAR_WIDTH_LEFT - $TASKBAR_WIDTH_RIGHT))

# Calculate the width and height of each division
DIV_WIDTH=$(($ADJUSTED_SCREEN_WIDTH / 2))
DIV_HEIGHT=$(($ADJUSTED_SCREEN_HEIGHT / 2))

# Get the list of currently open windows and their titles
WINDOW_LIST=$(wmctrl -l)

echo "Available windows:"
declare -A WIN_IDS_TITLES
i=0
while IFS= read -r line; do
    WIN_ID=$(echo "$line" | awk '{print $1}')
    WIN_TITLE=$(echo "$line" | cut -d ' ' -f 5-)
    WIN_IDS_TITLES[$i]=$WIN_ID
    echo "$i: $WIN_TITLE"
    i=$((i + 1))
done <<< "$WINDOW_LIST"

# Check if we have at least four windows
if [ ${#WIN_IDS_TITLES[@]} -lt 4 ]; then
    echo "You need at least four windows open."
    exit 1
fi

# Prompt user to select four windows
echo "Enter the numbers of the four windows you want to arrange (separated by spaces):"
read -a SELECTED_IDS

# Check if we have exactly four windows selected
if [ ${#SELECTED_IDS[@]} -ne 4 ]; then
    echo "You need to select exactly four windows."
    exit 1
fi

# Function to bring a window to the foreground
bring_to_foreground() {
    local WIN_ID=$1
    xdotool windowactivate $WIN_ID
    xdotool windowraise $WIN_ID
}

# Bring the selected windows to the foreground
for i in "${SELECTED_IDS[@]}"; do
    WIN_ID=${WIN_IDS_TITLES[$i]}
    bring_to_foreground $WIN_ID
done

# Wait a short moment to ensure the windows are brought to the foreground
sleep 0.5

# Position the windows in a 2x2 grid
for i in {0..3}; do
    WIN_ID=${WIN_IDS_TITLES[${SELECTED_IDS[$i]}]}
    COL=$(($i % 2))
    ROW=$(($i / 2))
    
    # Calculate the new position and size for each window
    X_POS=$(($COL * $DIV_WIDTH + $TASKBAR_WIDTH_LEFT))
    Y_POS=$(($ROW * $DIV_HEIGHT + $TASKBAR_HEIGHT_TOP))
    
    # Adjust the height for windows in the bottom row
    wmctrl -ir $WIN_ID -e 0,$X_POS,$Y_POS,$DIV_WIDTH,$DIV_HEIGHT
done
