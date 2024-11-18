#!/bin/bash

########################################################################
# File Name    : xfce_config_backup.sh
# Description  : Script to backup and restore Xfce panel configuration,
#                keyboard shortcuts, and desktop icons.
# Dependencies : Requires dconf and cp commands.
# Usage        : • Make the script executable with:
#                 chmod +x xfce_config_backup.sh
#                • Run the script with arguments:
#                 bash xfce_config_backup.sh {backup|restore}
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

# Define backup directory with timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="$HOME/xfce_backup_$TIMESTAMP"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Backup Xfce Panel
backup_panel() {
    echo "Backing up Xfce panel configuration..."
    xfconf-query -c xfce4-panel -lv > "$BACKUP_DIR/xfce4-panel.conf"
    echo "Backup completed: $BACKUP_DIR/xfce4-panel.conf"
}

# Restore Xfce Panel
restore_panel() {
    echo "Restoring Xfce panel configuration..."
    while read -r line; do
        xfconf-query -c xfce4-panel -p "$(echo $line | cut -d ' ' -f1)" -s "$(echo $line | cut -d ' ' -f2-)"
    done < "$BACKUP_DIR/xfce4-panel.conf"
    echo "Restoration completed."
}

# Backup Xfce Keyboard Shortcuts
backup_keyboard_shortcuts() {
    echo "Backing up Xfce keyboard shortcuts..."
    xfconf-query -c xfce4-keyboard-shortcuts -lv > "$BACKUP_DIR/xfce4-keyboard-shortcuts.conf"
    echo "Backup completed: $BACKUP_DIR/xfce4-keyboard-shortcuts.conf"
}

# Restore Xfce Keyboard Shortcuts
restore_keyboard_shortcuts() {
    echo "Restoring Xfce keyboard shortcuts..."
    while read -r line; do
        xfconf-query -c xfce4-keyboard-shortcuts -p "$(echo $line | cut -d ' ' -f1)" -s "$(echo $line | cut -d ' ' -f2-)"
    done < "$BACKUP_DIR/xfce4-keyboard-shortcuts.conf"
    echo "Restoration completed."
}

# Backup Xfce Desktop Icons
backup_desktop_icons() {
    echo "Backing up Xfce desktop icons..."
    cp -r ~/.config/xfce4/desktop/* "$BACKUP_DIR/xfce4-desktop-icons/"
    echo "Backup completed: $BACKUP_DIR/xfce4-desktop-icons/"
}

# Restore Xfce Desktop Icons
restore_desktop_icons() {
    echo "Restoring Xfce desktop icons..."
    cp -r "$BACKUP_DIR/xfce4-desktop-icons/"* ~/.config/xfce4/desktop/
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
