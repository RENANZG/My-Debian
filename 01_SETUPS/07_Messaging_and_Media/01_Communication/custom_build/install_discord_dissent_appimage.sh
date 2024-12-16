#!/usr/bin/env bash

#######################################################################
# File Name    : install_discord_dissent_appimage.sh
# Description  : This script automates the installation and setup of
#                an application. It downloads the latest version from a
#                specified source using curl, installs it to the user's
#                home directory, creates necessary directories and
#                symbolic links, provides an updater script and a
#                remover script, and runs the application inside a
#                bubblewrap (bwrap) sandbox for added security.
#                WARNING: --cap-add CAP_SYS_ADMIN actived.
# Dependencies : curl, bubblewrap, zstd, rsvg-convert (optional)
# Usage        : • Make the script executable with:
#                  chmod +x install_discord_dissent_appimage.sh
#                • Run the script with:
#                  bash install_discord_dissent_appimage.sh
#                • To update the application, run:
#                  bash $HOME/.local/share/discord-dissent/update.sh
#                • To remove the application, run:
#                  bash $HOME/.local/share/discord-dissent/remove.sh
# Author       : Me and the bois
# License      : Free of charge, no warranty
# Inspired by  : https://portable-linux-apps.github.io
#######################################################################
# Safety check
set -u

# Define variables
APP_NAME="discord-dissent"
APP_DOWNLOAD_URL="https://api.github.com/repos/diamondburned/dissent/releases"
HOME_DIR="$HOME/.local/share/AppImages/$APP_NAME"
DESKTOP_ENTRY="$HOME/.local/share/applications/so.libdb.dissent.desktop"
SHARE_DIR="$HOME_DIR/share"
BIN_DIR="$HOME_DIR/bin"
BINARY="$BIN_DIR/dissent"

# Bubblewrap command options (adjust as necessary)
BWRAP_CMD="bwrap"
BWRAP_OPTS="
--unshare-all \
--new-session \
--cap-add CAP_SYS_ADMIN \
--dev-bind /dev /dev \
--proc /proc \
--ro-bind /usr /usr \
--ro-bind /bin /bin \
--ro-bind /lib /lib \
--ro-bind /lib64 /lib64 \
--bind /tmp /tmp \
--bind $HOME_DIR $HOME_DIR \
--bind $HOME/.config $HOME/.config \
--bind $HOME/.cache $HOME/.cache \
--setenv DISPLAY :99 \
--setenv XDG_RUNTIME_DIR /run/user/$(id -u) \
$BINARY
"

# Define and create necessary directories
mkdir -p "$HOME_DIR" "$ICON_DIR" "$HOME/.local/share/applications"
mkdir -p "$HOME/Downloads"
mkdir -p "$HOME/.config/$APP_NAME"
mkdir -p "$HOME/.local/share/$APP_NAME"

# Function to download AppImage
download_appimage() {
    VERSION_URL=$(curl -sL "$APP_DOWNLOAD_URL" | grep -o '"browser_download_url": *"[^"]*"' | grep -o 'https://[^"]*' | grep -i 'amd64.*\.AppImage\|x86_64.*\.AppImage' | head -n 1)
    if [ -z "$VERSION_URL" ]; then
        echo "Error: Unable to find AppImage URL."
        exit 1
    fi

    echo "Downloading AppImage from $VERSION_URL..."
    if ! curl -L -o "$APPIMAGE_FILE" "$VERSION_URL"; then
        echo "Error: Failed to download AppImage."
        exit 1
    fi
    chmod a+x "$APPIMAGE_FILE"
}

# Function to extract AppImage
extract_appimage() {
    echo "Extracting AppImage from $APPIMAGE_FILE..."

    # Ensure the AppImage file exists
    if [ ! -f "$APPIMAGE_FILE" ]; then
        echo "Error: AppImage file not found at $APPIMAGE_FILE."
        exit 1
    fi

    # Perform extraction
    echo "Running AppImage extraction command..."
    if ! "$APPIMAGE_FILE" --appimage-extract > /dev/null 2>&1; then
        echo "Error: Failed to extract AppImage using --appimage-extract."
        exit 1
    fi

    echo "Extraction completed. Moving extracted files to $EXTRACTED_DIR..."

    # Move extracted files to the correct directory
    if [ -d "$HOME/squashfs-root" ]; then
        mv "$HOME/squashfs-root" "$EXTRACTED_DIR"
    fi

    # Verify extraction directory exists
    if [ ! -d "$EXTRACTED_DIR" ]; then
        echo "Error: Extraction directory not found at $EXTRACTED_DIR."
        exit 1
    fi
}

# Function to handle extracted files
handle_extracted_files() {
    echo "Handling extracted files..."

    # Find the desktop entry and icon file
    DESKTOP_ENTRY_SRC=$(find "$EXTRACTED_DIR" -name "$APP_NAME.desktop" | head -n 1)
    ICON_FILE=$(find "$EXTRACTED_DIR" -name "$APP_NAME.svg" | head -n 1)

    # Debugging information
    echo "Desktop entry source: $DESKTOP_ENTRY_SRC"
    echo "Icon file: $ICON_FILE"

    # Check if the desktop entry file is found
    if [ -z "$DESKTOP_ENTRY_SRC" ]; then
        echo "Error: Desktop entry file not found in the AppImage."
        exit 1
    fi

    # Check if the icon file is found
    if [ -z "$ICON_FILE" ]; then
        echo "Error: Icon file not found in the AppImage."
        exit 1
    fi

    # Convert the SVG icon to PNG format if rsvg-convert is available
    ICON_PATH="$ICON_DIR/$APP_NAME.png"
    if command -v rsvg-convert &> /dev/null; then
        echo "Converting SVG to PNG..."
        if ! rsvg-convert -o "$ICON_PATH" "$ICON_FILE"; then
            echo "Error: Failed to convert SVG to PNG."
            exit 1
        fi
    else
        echo "Warning: rsvg-convert is not installed. Using SVG icon instead."
        ICON_PATH="$ICON_DIR/$APP_NAME.svg"
        cp "$ICON_FILE" "$ICON_PATH"
    fi

    # Copy the desktop entry to the appropriate location
    cp "$DESKTOP_ENTRY_SRC" "$DESKTOP_ENTRY"
    if [ ! -f "$DESKTOP_ENTRY" ]; then
        echo "Error: Failed to copy desktop entry."
        exit 1
    fi

    # Convert multi-line BWRAP_OPTS to a single line
    BWRAP_OPTS_SINGLE_LINE=$(echo "$BWRAP_OPTS" | tr -d '\n' | sed 's/ *\\ / /g')

    # Modify the desktop entry to use bubblewrap
    sed -i "s|^Exec=.*|Exec=$BWRAP_CMD $BWRAP_OPTS_SINGLE_LINE|g" "$DESKTOP_ENTRY"
    sed -i "s|^Icon=.*|Icon=$ICON_PATH|g" "$DESKTOP_ENTRY"

    echo "Desktop entry and icon have been set up successfully."

    # Remove the extracted directory
    echo "Cleaning up extracted files..."
    rm -rf "$EXTRACTED_DIR"
}

# Download, extract, and handle files
download_appimage
extract_appimage
handle_extracted_files

# Add remover script
cat > "$HOME_DIR/remove.sh" <<EOF
#!/bin/sh
set -e
rm -f \$HOME/Desktop/$APP_NAME.desktop
rm -f \$HOME/.local/share/applications/$APP_NAME.desktop
rm -rf $HOME_DIR
rm -rf \$HOME/.config/$APP_NAME
rm -rf \$HOME/.local/share/$APP_NAME
gtk-update-icon-cache \$HOME_DIR/icon > /dev/null 2>&1
echo "Application removed."
EOF
chmod a+x "$HOME_DIR/remove.sh"

# Script to update the program
cat > "$HOME_DIR/update.sh" <<EOF
#!/bin/sh
set -u
APP_NAME="$APP_NAME"
APP_DOWNLOAD_URL="$APP_DOWNLOAD_URL"
HOME_DIR="$HOME_DIR"
version=\$(curl -sL "\$APP_DOWNLOAD_URL" | grep -o '"browser_download_url": *"[^"]*"' | grep -o 'https://[^"]*' | grep -i 'amd64.*\.AppImage\|x86_64.*\.AppImage' | head -n 1)
if [ -n "\$version" ]; then
    mkdir -p "\$HOME_DIR/tmp" && cd "\$HOME_DIR/tmp" || exit 1
    curl -L -o "\$APP_NAME.AppImage" "\$version" || exit 1
    mv "\$APP_NAME.AppImage" "\$HOME_DIR/\$APP_NAME.AppImage"
    chmod a+x "\$HOME_DIR/\$APP_NAME.AppImage" || exit 1
    echo "\$version" > "\$HOME_DIR/version
    rm -rf "\$HOME_DIR/tmp"
    notify-send "\$APP_NAME is updated!"
    gtk-update-icon-cache "$HOME_DIR/icon" > /dev/null 2>&1
else
    echo "Update not needed!"
fi
EOF
chmod a+x "$HOME_DIR/update.sh"

# Update desktop database and icon cache silently
update-desktop-database "$HOME/.local/share/applications" > /dev/null 2>&1
gtk-update-icon-cache "$HOME_DIR/icon" > /dev/null 2>&1

# Copy .desktop file to the Desktop
cp "$DESKTOP_ENTRY" "$HOME/Desktop"

# GNOME-specific steps
if command -v gnome-shell &> /dev/null; then
    # Trigger a GNOME Shell refresh
    gnome-shell-extension-tool -r || killall -3 gnome-shell
fi

echo "Installation completed successfully."
