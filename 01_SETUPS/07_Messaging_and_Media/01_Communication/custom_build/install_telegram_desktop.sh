#!/usr/bin/env bash

#######################################################################
# File Name    : install_telegram_desktop.sh
# Description  : This script automates the installation and setup of
#                an application. It downloads the latest version from a
#                specified source using curl, installs it to the user's
#                home directory, creates necessary directories and
#                symbolic links, provides an updater script and a
#                remover script, and runs the application inside a
#                bubblewrap (bwrap) sandbox for added security.
#                WARNING: --cap-add CAP_SYS_ADMIN actived.
# Dependencies : curl, bubblewrap, rsvg-convert (optional)
# Usage        : • Make the script executable with:
#                  chmod +x install_telegram_desktop.sh
#                • Run the script with:
#                  bash install_telegram_desktop.sh
#                • To update, run:
#                  bash $HOME/.local/share/telegram-desktop/update.sh
#                • To remove, run:
#                  bash $HOME/.local/share/telegram-desktop/remove.sh
# Author       : Me and the bois
# License      : Free of charge, no warranty
# Inspired by  : https://portable-linux-apps.github.io
#######################################################################

# Safety check
set -eu

# Define variables
APP_NAME="telegram-desktop"
APP_DOWNLOAD_URL="https://api.github.com/repos/telegramdesktop/tdesktop/releases"
HOME_DIR="$HOME/.local/share/$APP_NAME"
EXTRACTED_DIR="$HOME_DIR/Telegram"
APP_BINARY="$EXTRACTED_DIR/Telegram/Telegram"
ICON_DIR="$HOME_DIR/icon"
DESKTOP_ENTRY="$HOME/.local/share/applications/$APP_NAME.desktop"

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
$APP_BINARY
"

# Create necessary directories
mkdir -p "$HOME_DIR" "$ICON_DIR" "$HOME/.local/share/applications"
mkdir -p "$HOME/Downloads"

# Function to download the latest Telegram tar.xz file
download_telegram() {
    # Get the latest Telegram download link using GitHub API
    VERSION_URL=$(curl -sL "$APP_DOWNLOAD_URL" | grep -o '"browser_download_url": *"[^"]*"' | grep -o 'https://[^"]*tsetup.*\.tar\.xz' | head -n 1)
    if [ -z "$VERSION_URL" ]; then
        echo "Error: Unable to find Telegram Desktop tar.xz URL."
        exit 1
    fi

    echo "Downloading Telegram Desktop from $VERSION_URL..."
    if ! curl -L -o "$HOME_DIR/tsetup.tar.xz" "$VERSION_URL"; then
        echo "Error: Failed to download Telegram Desktop."
        exit 1
    fi
}

# Function to extract Telegram Desktop
extract_telegram() {
    echo "Extracting Telegram Desktop from $HOME_DIR/tsetup.tar.xz..."

    if [ ! -f "$HOME_DIR/tsetup.tar.xz" ]; then
        echo "Error: Telegram tar.xz file not found."
        exit 1
    fi

    if ! tar -xvJf "$HOME_DIR/tsetup.tar.xz" -C "$HOME_DIR"; then
        echo "Error: Failed to extract Telegram tar.xz."
        exit 1
    fi

    echo "Extraction completed."
}

# Function to create the desktop entry
create_desktop_entry() {
    echo "Creating desktop entry..."

    if [ ! -f "$APP_BINARY" ]; then
        echo "Error: Telegram binary not found."
        exit 1
    fi

    cat > "$DESKTOP_ENTRY" <<EOF
[Desktop Entry]
Name=Telegram Desktop
Comment=Telegram Messaging App
Exec=$BWRAP_CMD
Icon=$ICON_DIR/telegram.png
Terminal=false
Type=Application
Categories=Network;InstantMessaging;
EOF

    echo "Desktop entry created successfully."
}

# Run functions to download, extract, and set up Telegram Desktop
download_telegram
extract_telegram
create_desktop_entry

# Add updater script
cat > "$HOME_DIR/update.sh" <<EOF
#!/bin/sh
set -u
APP_NAME="$APP_NAME"
APP_DOWNLOAD_URL="$APP_DOWNLOAD_URL"
HOME_DIR="$HOME_DIR"
version=\$(curl -sL "\$APP_DOWNLOAD_URL" | grep -o '"browser_download_url": *"[^"]*"' | grep -o 'https://[^"]*tsetup.*\.tar\.xz' | head -n 1)
if [ -n "\$version" ]; then
    mkdir -p "\$HOME_DIR/tmp" && cd "\$HOME_DIR/tmp" || exit 1
    curl -L -o "tsetup.tar.xz" "\$version" || exit 1
    mv "tsetup.tar.xz" "\$HOME_DIR/tsetup.tar.xz"
    rm -rf "\$HOME_DIR/tmp"
    notify-send "\$APP_NAME is updated!"
else
    echo "Update not needed!"
fi
EOF
chmod a+x "$HOME_DIR/update.sh"

# Add remover script
cat > "$HOME_DIR/remove.sh" <<EOF
#!/bin/sh
set -e
rm -f \$HOME/.local/share/applications/$APP_NAME.desktop
rm -rf $HOME_DIR
echo "Application removed."
EOF
chmod a+x "$HOME_DIR/remove.sh"

# Update desktop database
update-desktop-database "$HOME/.local/share/applications" > /dev/null 2>&1

# Notify user of successful installation
echo "Installation completed successfully."
