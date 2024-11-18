#!/bin/bash

########################################################################
# File Name    : xfce_terminal_customize.sh
# Description  : Script to customize Xfce Terminal settings including 
#                font size, colors and other preferences.
# Dependencies : Requires gsettings command.
# Usage        : • Make the script executable with:
#                chmod +x xfce_terminal_customize.sh
#                • Run the script with:
#                bash xfce_terminal_customize.sh
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

# Define Xfce Terminal configuration file path
CONFIG_FILE="$HOME/.config/xfce4/terminal/terminalrc"

# Customization Variables
FONT_SIZE=12
BACKGROUND_COLOR="#1E1E1E"
FOREGROUND_COLOR="#D4D4D4"
CURSOR_COLOR="#FFB86C"
SCROLLBAR="TRUE"  # Xfce Terminal uses TRUE/FALSE for enabling/disabling

# Function to set the terminal font size
set_font_size() {
    local font_size=$1
    echo "Setting font size to $font_size..."
    sed -i "s/^FontSize=.*/FontSize=$font_size/" "$CONFIG_FILE"
}

# Function to set the background color
set_background_color() {
    local color=$1
    echo "Setting background color to $color..."
    sed -i "s/^BackgroundColor=.*/BackgroundColor=$color/" "$CONFIG_FILE"
}

# Function to set the foreground color
set_foreground_color() {
    local color=$1
    echo "Setting foreground color to $color..."
    sed -i "s/^ForegroundColor=.*/ForegroundColor=$color/" "$CONFIG_FILE"
}

# Function to set the cursor color
set_cursor_color() {
    local color=$1
    echo "Setting cursor color to $color..."
    sed -i "s/^CursorColor=.*/CursorColor=$color/" "$CONFIG_FILE"
}

# Function to enable or disable the scrollbar
set_scrollbar() {
    local enable=$1
    echo "Setting scrollbar to $enable..."
    sed -i "s/^ScrollBar=.*/ScrollBar=$enable/" "$CONFIG_FILE"
}

# Function to backup the current configuration with timestamp
backup_config() {
    local timestamp=$(date +"%Y%m%d_%H%M%S")
    local backup_file="$CONFIG_FILE.$timestamp.bak"
    echo "Backing up current configuration to $backup_file..."
    cp "$CONFIG_FILE" "$backup_file"
}

# Backup the configuration before making changes
backup_config

# Example customizations
set_font_size "$FONT_SIZE"
set_background_color "$BACKGROUND_COLOR"
set_foreground_color "$FOREGROUND_COLOR"
set_cursor_color "$CURSOR_COLOR"
set_scrollbar "$SCROLLBAR"

echo "Xfce Terminal customization applied. Please restart Xfce Terminal for changes to take effect."
