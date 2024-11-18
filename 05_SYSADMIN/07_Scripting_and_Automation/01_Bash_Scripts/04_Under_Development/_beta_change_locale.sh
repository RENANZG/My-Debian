#!/usr/bin/env bash

########################################################################
# File Name  : change_locale.sh
# Description: Script to change the locale in Debian with GNOME, XFCE,
#              or LXQt interfaces, ask for logoff, and verify the input
#              method framework.
# Languages  : en (English), es (Spanish) and de (German)
# Interfaces : GNOME, XFCE, LXQt
# Frameworks : IBus, UIM, Fcitx, Gcin
# Usage      : • Make the script executable with:
#              sudo chmod +x change_locale.sh
#              • Run the script with no arguments:
#              sudo bash change_locale.sh
# Author     : Me and the bois
# License    : Free of charge, no warranty
########################################################################

# Function to switch locale
function switch_locale() {
    local lang="$1"
    case "$lang" in
        en)
            sudo update-locale LANG=en_US.UTF-8
            ;;
        es)
            sudo update-locale LANG=es_ES.UTF-8
            ;;
        de)
            sudo update-locale LANG=de_DE.UTF-8
            ;;
        *)
            echo "Unsupported language: $lang"
            return 1
            ;;
    esac
    sudo dpkg-reconfigure --frontend=noninteractive locales
    echo "Language switched to $lang"
}

# Function to print input framework
function print_input_framework() {
    echo "Input framework:"
    if command -v ibus >/dev/null; then
        echo "IBus is installed."
    fi
    if command -v uim >/dev/null; then
        echo "UIM is installed."
    fi
    if command -v fcitx >/dev/null; then
        echo "Fcitx is installed."
    fi
    if command -v gcin >/dev/null; then
        echo "Gcin is installed."
    fi
}

# Output uncommented locales from /etc/locale.gen
echo "Uncommented locales in /etc/locale.gen:"
grep -vE '^\s*#' /etc/locale.gen

# Print input framework
print_input_framework

# Output /etc/environment
echo "Contents of /etc/environment:"
cat /etc/environment

# Output /etc/default/locale
echo "Contents of /etc/default/locale:"
cat /etc/default/locale

# Output /etc/default/keyboard
echo "Contents of /etc/default/keyboard:"
cat /etc/default/keyboard

# Mention keyboard configuration and console setup
echo "Keyboard Configuration and Console Setup:"
echo "Debian systems can be configured to work with many international keyboard arrangements using the keyboard-configuration and console-setup packages."
echo "These packages allow setting keyboard layouts, console fonts, and other console-related configurations."

