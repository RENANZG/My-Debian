#!/usr/bin/env bash

########################################################################
# File Name    : screen_golden_ratio_division.sh
# Description  : Positions windows interactively selecting windows and 
#                positioning them according to your preferences using
#                the golden ratio division. Add the script to a shortcut
#                bind or include it in `.bashrc`.
# Dependencies : xdotool, wmctrl
# Usage        : • Make the script executable with 
#                chmod +x screen_golden_ratio_division.sh
#                • Run the script with:
#                bash screen_golden_ratio_division.sh
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
ADJUSTED_SCREEN_WIDTH=$(($SCREEN_WIDTH - $TASKBAR_WIDTH_LEFT - $TASKBAR_WIDTH_RIGHT))
ADJUSTED_SCREEN_HEIGHT=$(($SCREEN_HEIGHT - $TASKBAR_HEIGHT_TOP - $TASKBAR_HEIGHT_BOTTOM))

# Calculate the golden ratio dimensions
GOLDEN_RATIO=0.618
LARGE_WIDTH=$(echo "$ADJUSTED_SCREEN_WIDTH * $GOLDEN_RATIO" | bc)
SMALL_WIDTH=$(echo "$ADJUSTED_SCREEN_WIDTH - $LARGE_WIDTH" | bc)

# Convert to integers
LARGE_WIDTH=$(printf "%.0f" $LARGE_WIDTH)
SMALL_WIDTH=$(printf "%.0f" $SMALL_WIDTH)

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

echo "Enter the number (or numbers) of the windows you want to arrange (separated by space):"
read -a SELECTED_IDS

# Check if we have at least two windows selected
if [ ${#SELECTED_IDS[@]} -lt 2 ]; then
    echo "You need to select at least two windows."
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

# Apply the new positions with adjusted height
ADJUSTED_LARGE_HEIGHT=$ADJUSTED_SCREEN_HEIGHT
ADJUSTED_SMALL_HEIGHT=$ADJUSTED_SCREEN_HEIGHT

wmctrl -ir ${WIN_IDS_TITLES[${SELECTED_IDS[0]}]} -e 0,$TASKBAR_WIDTH_LEFT,$TASKBAR_HEIGHT_TOP,$LARGE_WIDTH,$ADJUSTED_LARGE_HEIGHT
wmctrl -ir ${WIN_IDS_TITLES[${SELECTED_IDS[1]}]} -e 0,$(($TASKBAR_WIDTH_LEFT + $LARGE_WIDTH)),$TASKBAR_HEIGHT_TOP,$SMALL_WIDTH,$ADJUSTED_SMALL_HEIGHT
