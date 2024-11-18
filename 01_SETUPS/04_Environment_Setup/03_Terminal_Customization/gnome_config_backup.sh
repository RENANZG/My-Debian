#!/bin/bash

########################################################################
# File Name    : gnome_config_backup.sh
# Description  : Script to backup and restore GNOME panel configuration,
#                keyboard shortcuts, and desktop icons.
# Dependencies : Requires dconf and cp commands.
# Usage        : • Make the script executable with:
#                 chmod +x gnome_config_backup.sh
#                • Run the script with arguments:
#                 bash gnome_config_backup.sh {backup|restore}
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

# Define backup directory with timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="$HOME/gnome_backup_$TIMESTAMP"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Backup GNOME Terminal profiles
backup_terminal_profiles() {
    echo "Backing up GNOME Terminal profiles..."
    dconf dump /org/gnome/terminal/legacy/profiles:/ > "$BACKUP_DIR/gnome-terminal-profiles.dconf"
    echo "Backup completed: $BACKUP_DIR/gnome-terminal-profiles.dconf"
}

# Restore GNOME Terminal profiles
restore_terminal_profiles() {
    echo "Restoring GNOME Terminal profiles..."
    dconf load /org/gnome/terminal/legacy/profiles:/ < "$BACKUP_DIR/gnome-terminal-profiles.dconf"
    echo "Restoration completed."
}

# Backup GNOME Keyboard Shortcuts
backup_keyboard_shortcuts() {
    echo "Backing up GNOME keyboard shortcuts..."
    dconf dump /org/gnome/settings-daemon/plugins/media-keys/ > "$BACKUP_DIR/gnome-keyboard-shortcuts.dconf"
    echo "Backup completed: $BACKUP_DIR/gnome-keyboard-shortcuts.dconf"
}

# Restore GNOME Keyboard Shortcuts
restore_keyboard_shortcuts() {
    echo "Restoring GNOME keyboard shortcuts..."
    dconf load /org/gnome/settings-daemon/plugins/media-keys/ < "$BACKUP_DIR/gnome-keyboard-shortcuts.dconf"
    echo "Restoration completed."
}

# Backup GNOME Taskbar
backup_taskbar() {
    echo "Backing up GNOME taskbar..."
    dconf dump /org/gnome/shell/extensions/dash-to-dock/ > "$BACKUP_DIR/gnome-dash-to-dock.dconf"
    echo "Backup completed: $BACKUP_DIR/gnome-dash-to-dock.dconf"
}

# Restore GNOME Taskbar
restore_taskbar() {
    echo "Restoring GNOME taskbar..."
    dconf load /org/gnome/shell/extensions/dash-to-dock/ < "$BACKUP_DIR/gnome-dash-to-dock.dconf"
    echo "Restoration completed."
}

# Backup GNOME Desktop Icons
backup_desktop_icons() {
    echo "Backing up GNOME desktop icons..."
    dconf dump /org/gnome/desktop/background/ > "$BACKUP_DIR/gnome-desktop-background.dconf"
    dconf dump /org/gnome/desktop/icons/ > "$BACKUP_DIR/gnome-desktop-icons.dconf"
    echo "Backup completed: $BACKUP_DIR/gnome-desktop-background.dconf"
    echo "Backup completed: $BACKUP_DIR/gnome-desktop-icons.dconf"
}

# Restore GNOME Desktop Icons
restore_desktop_icons() {
    echo "Restoring GNOME desktop icons..."
    dconf load /org/gnome/desktop/background/ < "$BACKUP_DIR/gnome-desktop-background.dconf"
    dconf load /org/gnome/desktop/icons/ < "$BACKUP_DIR/gnome-desktop-icons.dconf"
    echo "Restoration completed."
}

# Select action
case $1 in
    backup)
        backup_terminal_profiles
        backup_keyboard_shortcuts
        backup_taskbar
        backup_desktop_icons
        ;;
    restore)
        restore_terminal_profiles
        restore_keyboard_shortcuts
        restore_taskbar
        restore_desktop_icons
        ;;
    *)
        echo "Usage: $0 {backup|restore}"
        exit 1
        ;;
esac
