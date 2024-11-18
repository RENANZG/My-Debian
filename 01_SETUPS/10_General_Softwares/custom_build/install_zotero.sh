#!/usr/bin/env bash

########################################################################
# File Name    : install_zotero.sh
# Description  : This script automates the installation and setup of
#                Zotero on a Linux system. It downloads the latest
#                version from the specified source using curl, extracts
#                it, creates necessary directories and symbolic links,
#                provides an updater script, and a remover script.
# Dependencies : curl, bubblewrap
# Usage        : • Make the script executable with
#                  chmod +x install_zotero.sh
#                • Run the script with:
#                  bash install_zotero.sh
#                • To update the application, run:
#                  bash $HOME/.local/share/zotero/update.sh
#                • To remove the application, run:
#                  bash $HOME/.local/share/zotero/remove.sh
# Author       : Me and the bois
# License      : Free of charge, no warranty
# Inspired by  : https://portable-linux-apps.github.io
########################################################################

# Ensure shell script safety checks
set -u

# Define variables
APP_NAME="zotero"
APP_DOWNLOAD_URL="https://www.zotero.org/download/client/dl?channel=release&platform=linux-x86_64"
HOME_DIR="$HOME/.local/share/$APP_NAME"
APP_DIR="$HOME_DIR/Zotero"
APP_TAR_FILE="$HOME_DIR/Zotero.tar.bz2"
DESKTOP_ENTRY="$HOME/.local/share/applications/$APP_NAME.desktop"

# Define and create necessary directories
mkdir -p "$HOME_DIR"
mkdir -p "$HOME/Downloads"

# Function to download Zotero
download_zotero() {
    echo "Downloading Zotero..."
    if ! curl -L -o "$APP_TAR_FILE" "$APP_DOWNLOAD_URL"; then
        echo "Error: Failed to download Zotero."
        exit 1
    fi
}

# Function to extract Zotero
extract_zotero() {
    echo "Extracting Zotero from $APP_TAR_FILE..."

    # Ensure the tarball file exists
    if [ ! -f "$APP_TAR_FILE" ]; then
        echo "Error: Downloaded file not found at $APP_TAR_FILE."
        exit 1
    fi

    tar -xjf "$APP_TAR_FILE" -C "$HOME_DIR"
    if [ ! -d "$APP_DIR" ]; then
        echo "Error: Extraction failed, Zotero directory not found."
        exit 1
    fi
}

# Function to create a desktop entry
create_desktop_entry() {
    echo "Creating desktop entry..."
    cat > "$DESKTOP_ENTRY" <<EOF
[Desktop Entry]
Name=Zotero
Comment=Zotero Reference Manager
Exec=bwrap --bind $APP_DIR $APP_DIR --bind $HOME/.local/share/fonts /usr/share/fonts --bind $HOME/.config /home/user/.config --bind /tmp /tmp --dev-bind /dev /dev --proc /proc --ro-bind /usr /usr --ro-bind /bin /bin --ro-bind /sbin /sbin --ro-bind /lib /lib --ro-bind /lib64 /lib64 --setenv DISPLAY :0 --setenv XDG_DATA_HOME $HOME/.local/share/$APP_NAME --setenv XDG_CONFIG_HOME $HOME/.config/$APP_NAME $APP_DIR/zotero
Icon=$APP_DIR/chrome/icons/default/default128.png
Terminal=false
Type=Application
Categories=Office;Productivity;
EOF

    if [ ! -f "$DESKTOP_ENTRY" ]; then
        echo "Error: Failed to create desktop entry."
        exit 1
    fi
}

# Function to add remove script
create_remove_script() {
    cat > "$HOME_DIR/remove.sh" <<EOF
#!/bin/bash
set -e
rm -f \$HOME/Desktop/$APP_NAME.desktop
rm -f \$HOME/.local/share/applications/$APP_NAME.desktop
rm -rf $HOME_DIR
echo "$APP_NAME has been removed."
EOF
    chmod +x "$HOME_DIR/remove.sh"
}

# Function to add update script
create_update_script() {
    cat > "$HOME_DIR/update.sh" <<EOF
#!/bin/bash
set -u
APP_NAME="$APP_NAME"
APP_DOWNLOAD_URL="$APP_DOWNLOAD_URL"
APP_TAR_FILE="$APP_TAR_FILE"
HOME_DIR="$HOME_DIR"

echo "Updating Zotero..."
if curl -L -o "\$APP_TAR_FILE" "\$APP_DOWNLOAD_URL"; then
    echo "Downloaded new version."
    rm -rf "\$HOME_DIR/Zotero"  # Remove old version
    tar -xjf "\$APP_TAR_FILE" -C "\$HOME_DIR"
    echo "Zotero updated."
else
    echo "Error: Failed to download the updated Zotero."
    exit 1
fi
EOF
    chmod +x "$HOME_DIR/update.sh"
}

# Download, extract, and setup files
download_zotero
extract_zotero
create_desktop_entry
create_remove_script
create_update_script

# Update desktop database silently
update-desktop-database "$HOME/.local/share/applications" > /dev/null 2>&1

# Copy .desktop file to the Desktop
cp "$DESKTOP_ENTRY" "$HOME/Desktop"

echo "Installation completed successfully. You can run Zotero from your application menu."
