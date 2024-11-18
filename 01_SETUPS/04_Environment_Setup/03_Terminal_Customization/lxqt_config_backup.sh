#!/bin/bash

########################################################################
# File Name    : lxqt_config_backup.sh
# Description  : Script to backup and restore LXQt panel configuration,
#                keyboard shortcuts, and desktop icons.
# Dependencies : Requires dconf and cp commands.
# Usage        : • Make the script executable with:
#                 chmod +x lxqt_config_backup.sh
#                • Run the script with arguments:
#                 bash lxqt_config_backup.sh {backup|restore}
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

# Define backup directory with timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="$HOME/lxqt_backup_$TIMESTAMP"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Backup LXQt Panel
backup_panel() {
    echo "Backing up LXQt panel configuration..."
    cp -r ~/.config/lxqt/panel.conf "$BACKUP_DIR/lxqt-panel.conf"
    echo "Backup completed: $BACKUP_DIR/lxqt-panel.conf"
}

# Restore LXQt Panel
restore_panel() {
    echo "Restoring LXQt panel configuration..."
    cp "$BACKUP_DIR/lxqt-panel.conf" ~/.config/lxqt/panel.conf
    echo "Restoration completed."
}

# Backup LXQt Keyboard Shortcuts
backup_keyboard_shortcuts() {
    echo "Backing up LXQt keyboard shortcuts..."
    cp -r ~/.config/lxqt/globalkeyshortcuts.conf "$BACKUP_DIR/lxqt-keyboard-shortcuts.conf"
    echo "Backup completed: $BACKUP_DIR/lxqt-keyboard-shortcuts.conf"
}

# Restore LXQt Keyboard Shortcuts
restore_keyboard_shortcuts() {
    echo "Restoring LXQt keyboard shortcuts..."
    cp "$BACKUP_DIR/lxqt-keyboard-shortcuts.conf" ~/.config/lxqt/globalkeyshortcuts.conf
    echo "Restoration completed."
}

# Backup LXQt Desktop Icons
backup_desktop_icons() {
    echo "Backing up LXQt desktop icons..."
    cp -r ~/.config/pcmanfm-qt/lxqt/settings.conf "$BACKUP_DIR/lxqt-desktop-icons.conf"
    echo "Backup completed: $BACKUP_DIR/lxqt-desktop-icons.conf"
}

# Restore LXQt Desktop Icons
restore_desktop_icons() {
    echo "Restoring LXQt desktop icons..."
    cp "$BACKUP_DIR/lxqt-desktop-icons.conf" ~/.config/pcmanfm-qt/lxqt/settings.conf
    echo "Restoration completed."
}

# Select action
case $1 in
    backup)
        backup_panel
        backup_keyboard_shortcuts
        backup_desktop_icons
        ;;
    restore)
        restore_panel
        restore_keyboard_shortcuts
        restore_desktop_icons
        ;;
    *)
        echo "Usage: $0 {backup|restore}"
        exit 1
        ;;
esac
