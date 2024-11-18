#!/bin/bash

########################################################################
# File Name    : gnome_terminal_customize.sh
# Description  : Script to customize GNOME Terminal settings including 
#                font size, colors and other preferences using 
#                gsettings.
# Dependencies : Requires gsettings command.
# Usage        : • Make the script executable with:
#                chmod +x gnome_terminal_customize.sh
#                • Run the script with:
#                bash gnome_terminal_customize.sh
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

# Customization Variables
PROFILE_ID=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'")
FONT_SIZE=12
USE_THEME_COLORS=false     # true to use theme colors,
                           # false to use custom colors
BACKGROUND_COLOR="#1E1E1E" # very dark shade of gray
FOREGROUND_COLOR="#D4D4D4" # light gray
CURSOR_COLOR="#FFB86C"     # soft orange
USE_BOLD=1                 # 1 to enable, 0 to disable
USE_VI_MODE=0              # 1 to enable, 0 to disable
TEXT_ANTIALIASING=true     # true to enable, false to disable

# Function to set the terminal font size
set_font_size() {
    local font_size=$1
    echo "Setting font size to $font_size..."
    gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/" font "Monospace $font_size"
}

# Function to set the background color
set_background_color() {
    local color=$1
    echo "Setting background color to $color..."
    gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/" background-color "$color"
}

# Function to set the foreground color
set_foreground_color() {
    local color=$1
    echo "Setting foreground color to $color..."
    gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/" foreground-color "$color"
}

# Function to set the cursor color
set_cursor_color() {
    local color=$1
    echo "Setting cursor color to $color..."
    gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/" cursor-color "$color"
}

# Function to enable or disable bold text
set_use_bold() {
    local use_bold=$1
    echo "Setting use-bold to $use_bold..."
    gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/" use-bold "$use_bold"
}

# Function to enable or disable vi mode
set_use_vi_mode() {
    local use_vi_mode=$1
    echo "Setting use-vi-mode to $use_vi_mode..."
    gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/" use-vi-mode "$use_vi_mode"
}

# Function to enable or disable text antialiasing
set_text_antialiasing() {
    local text_antialiasing=$1
    echo "Setting text-antialiasing to $text_antialiasing..."
    gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/" text-antialiasing "$text_antialiasing"
}

# Function to use theme colors or custom colors
set_use_theme_colors() {
    local use_theme_colors=$1
    echo "Setting use-theme-colors to $use_theme_colors..."
    gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/" use-theme-colors "$use_theme_colors"
}

# Apply customizations
set_font_size "$FONT_SIZE"
set_background_color "$BACKGROUND_COLOR"
set_foreground_color "$FOREGROUND_COLOR"
set_cursor_color "$CURSOR_COLOR"
set_use_bold "$USE_BOLD"
set_use_vi_mode "$USE_VI_MODE"
set_text_antialiasing "$TEXT_ANTIALIASING"
set_use_theme_colors "$USE_THEME_COLORS"

echo "GNOME Terminal customization applied. Please restart GNOME Terminal for changes to take effect."
