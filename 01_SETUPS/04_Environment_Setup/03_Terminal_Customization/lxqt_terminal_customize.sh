#!/bin/bash

########################################################################
# File Name    : lxqt_terminal_customize.sh
# Description  : Script to customize LXQt Terminal settings including 
#                font size, colors and other preferences.
# Dependencies : Requires gsettings command.
# Usage        : • Make the script executable with:
#                chmod +x lxqt_terminal_customize.sh
#                • Run the script with:
#                bash lxqt_terminal_customize.sh
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
SCROLLBAR="TRUE" # Xfce Terminal uses TRUE/FALSE for enabling/disabling
USE_TRANSPARENCY="TRUE"
TRANSPARENCY_LEVEL=80
CURSOR_BLINK="TRUE"
USE_CUSTOM_CURSOR="TRUE"
CUSTOM_CURSOR_PATH="$HOME/.local/share/icons/custom-cursor.png"

# Keyboard Shortcuts Variables
QUIT_SHORTCUT="Ctrl+Q"
CLOSE_TAB_SHORTCUT="Ctrl+W"
ADD_TAB_SHORTCUT="Ctrl+T"
SHOW_TAB_BAR_SHORTCUT="F12"
HIDE_WINDOW_BORDERS_SHORTCUT="Ctrl+Alt+Shift+B"
SPLIT_TERMINAL_HORIZONTALLY_SHORTCUT="Ctrl+Shift+Alt+H"
SPLIT_TERMINAL_VERTICALLY_SHORTCUT="Ctrl+Shift+Alt+V"

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

# Function to set transparency
set_transparency() {
    local use_transparency=$1
    local transparency_level=$2
    echo "Setting transparency to $use_transparency with level $transparency_level..."
    sed -i "s/^UseTransparency=.*/UseTransparency=$use_transparency/" "$CONFIG_FILE"
    sed -i "s/^TransparencyLevel=.*/TransparencyLevel=$transparency_level/" "$CONFIG_FILE"
}

# Function to set cursor blink
set_cursor_blink() {
    local cursor_blink=$1
    echo "Setting cursor blink to $cursor_blink..."
    sed -i "s/^CursorBlink=.*/CursorBlink=$cursor_blink/" "$CONFIG_FILE"
}

# Function to set custom cursor
set_custom_cursor() {
    local use_custom_cursor=$1
    local custom_cursor_path=$2
    echo "Setting custom cursor to $use_custom_cursor with path $custom_cursor_path..."
    sed -i "s/^UseCustomCursor=.*/UseCustomCursor=$use_custom_cursor/" "$CONFIG_FILE"
    sed -i "s/^CustomCursorPath=.*/CustomCursorPath=$custom_cursor_path/" "$CONFIG_FILE"
}

# Function to apply keyboard shortcuts
apply_keyboard_shortcuts() {
    echo "Applying keyboard shortcuts..."

    xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/<Super>q -s "$QUIT_SHORTCUT"
    xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/<Super>w -s "$CLOSE_TAB_SHORTCUT"
    xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/<Super>t -s "$ADD_TAB_SHORTCUT"
    xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/<Super>F12 -s "$SHOW_TAB_BAR_SHORTCUT"
    xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/<Super>Ctrl+Shift+Alt+H -s "$SPLIT_TERMINAL_HORIZONTALLY_SHORTCUT"
    xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/<Super>Ctrl+Shift+Alt+V -s "$SPLIT_TERMINAL_VERTICALLY_SHORTCUT"
    xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/<Super>Ctrl+Alt+Shift+B -s "$HIDE_WINDOW_BORDERS_SHORTCUT"
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

# Apply customizations
set_font_size "$FONT_SIZE"
set_background_color "$BACKGROUND_COLOR"
set_foreground_color "$FOREGROUND_COLOR"
set_cursor_color "$CURSOR_COLOR"
set_scrollbar "$SCROLLBAR"
set_transparency "$USE_TRANSPARENCY" "$TRANSPARENCY_LEVEL"
set_cursor_blink "$CURSOR_BLINK"
set_custom_cursor "$USE_CUSTOM_CURSOR" "$CUSTOM_CURSOR_PATH"

# Apply keyboard shortcuts
apply_keyboard_shortcuts

echo "Xfce Terminal customization applied. Please restart Xfce Terminal for changes to take effect."
