#!/usr/bin/env bash

#######################################################################
# File Name    : install_chatgpt_appimage.sh
# Description  : This script automates the installation and setup of
#                an application. It downloads the latest version from a
#                specified source using curl, installs it to the user's
#                home directory, creates necessary directories and
#                symbolic links, provides an updater script and a
#                remover script, and runs the application inside a
#                bubblewrap (bwrap) sandbox for added security.
#                WARNING: --cap-add CAP_SYS_ADMIN activated.
# Dependencies : curl, bubblewrap, rsvg-convert (optional)
# Usage        : • Make the script executable with
#                  chmod +x install_chatgpt_appimage.sh
#                • Run the script with:
#                  bash install_chatgpt_appimage.sh
#                • To update the AppImage, run:
#                  bash $HOME/.local/share/chatgpt/update.sh
#                • To remove the AppImage, run:
#                  bash $HOME/.local/share/chatgpt/remove.sh
# Author       : Me and the bois
# License      : Free of charge, no warranty
# Inspired by  : https://portable-linux-apps.github.io
#######################################################################

# Safety check
set -eu

# Define variables
APP_NAME="chatgpt"
APP_DOWNLOAD_URL="https://api.github.com/repos/lencx/ChatGPT/releases"
HOME_DIR="$HOME/.local/share/AppImages/$APP_NAME"
APP_TAR_GZ_FILE="$HOME_DIR/$APP_NAME.tar.gz"
RENAMED_FILE="$HOME_DIR/$APP_NAME.AppImage"
DESKTOP_ENTRY="$HOME/.local/share/applications/$APP_NAME.desktop"
ICON_DIR="$HOME_DIR/icon"
EXTRACTED_DIR="$HOME_DIR/extracted"

# Function to check if required dependencies are installed
check_dependencies() {
  local dependencies=("bwrap" "curl" "tar")
  for cmd in "${dependencies[@]}"; do
    if ! command -v "$cmd" > /dev/null; then
      echo "Error: $cmd is not installed. Please install it first."
      exit 1
    fi
  done
  echo "All dependencies are installed."
}

# Function to create necessary directories
create_directories() {
  mkdir -p "$HOME_DIR" "$ICON_DIR" "$EXTRACTED_DIR" \
           "$HOME/.local/share/applications" \
           "$HOME/.cache/$APP_NAME" \
           "$HOME/.config/$APP_NAME"
}

# Function to download the latest .tar.gz
download_tar_gz() {
  RESPONSE=$(curl -sL "$APP_DOWNLOAD_URL")
  VERSION_URL=$(echo "$RESPONSE" | grep -oP 'https://.*?\.tar\.gz' | head -n 1)

  if [[ -z "$VERSION_URL" ]]; then
    echo "Error: No valid tar.gz URL found."
    exit 1
  fi

  echo "Downloading .tar.gz from $VERSION_URL..."
  curl -L -o "$APP_TAR_GZ_FILE" "$VERSION_URL" || { echo "Error: Download failed."; exit 1; }
}

# Function to extract .tar.gz
extract_tar_gz() {
  echo "Extracting .tar.gz from $APP_TAR_GZ_FILE..."

  if [ ! -f "$APP_TAR_GZ_FILE" ]; then
    echo "Error: tar.gz not found."
    exit 1
  fi

  tar -xzf "$APP_TAR_GZ_FILE" -C "$EXTRACTED_DIR" || { echo "Error: Extraction failed."; exit 1; }
  mv "$EXTRACTED_DIR/"* "$RENAMED_FILE" || { echo "Error: Renaming extracted file failed."; exit 1; }

  if [ ! -f "$RENAMED_FILE" ]; then
    echo "Error: Renamed file not found."
    exit 1
  fi
}

# Function to get the bubblewrap command
get_bwrap_cmd() {
  local DISPLAY_VALUE="${DISPLAY:-:0}"
  local USER_ID=$(id -u)
  echo "bwrap \
--cap-add CAP_SYS_ADMIN \
--dev-bind /dev /dev \
--dev-bind /dev/dri /dev/dri \
--unshare-all \
--share-net \
--proc /proc \
--ro-bind /usr /usr \
--ro-bind /bin /bin \
--ro-bind /sbin /sbin \
--ro-bind /lib /lib \
--ro-bind /lib64 /lib64 \
--ro-bind /etc/ssl /etc/ssl \
--ro-bind /etc/resolv.conf /etc/resolv.conf \
--ro-bind /etc/fonts /etc/fonts \
--ro-bind /usr/share/fonts /usr/share/fonts \
--ro-bind /usr/lib/x86_64-linux-gnu/dri /usr/lib/x86_64-linux-gnu/dri \
--setenv DISPLAY $DISPLAY_VALUE \
--tmpfs /run \
--tmpfs /tmp \
--bind /etc/mtab /etc/mtab \
--bind /run/dbus/system_bus_socket /run/dbus/system_bus_socket \
--bind /run/user/$USER_ID/at-spi /run/user/$USER_ID/at-spi \
--bind /run/user/$USER_ID/bus /run/user/$USER_ID/bus \
--bind /run/user/$USER_ID/dconf /run/user/$USER_ID/dconf \
--bind /run/user/$USER_ID/pulse /run/user/$USER_ID/pulse \
--bind \"$RENAMED_FILE\" \"$RENAMED_FILE\" \
--bind \"$HOME/.cache/$APP_NAME\" \"$HOME/.cache/$APP_NAME\" \
--bind \"$HOME/.config/$APP_NAME\" \"$HOME/.config/$APP_NAME\" \
--bind \"$HOME\" \"$HOME\" \
/bin/sh -c \"$RENAMED_FILE\""
}

# Function to configure extracted files (desktop entry, icon)
configure_files() {
  local BWRAP_CMD=$(get_bwrap_cmd)

  # Create a basic desktop entry
  echo "Creating desktop entry..."
  cat > "$DESKTOP_ENTRY" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=$APP_NAME
Exec=$BWRAP_CMD
Icon=$APP_NAME
Categories=Utility;
EOF

  # Copy to the desktop as well
  cp "$DESKTOP_ENTRY" "$HOME/Desktop"
}

# Function to create the remover script
create_remover_script() {
  cat > "$HOME_DIR/remove.sh" <<EOF
#!/bin/sh
set -e
rm -f "$HOME/Desktop/$APP_NAME.desktop"
rm -f "$HOME/.local/share/applications/$APP_NAME.desktop"
rm -rf "$HOME_DIR"
rm -rf "$HOME/.config/$APP_NAME"
rm -rf "$HOME/.local/share/$APP_NAME"
echo "Application removed."
EOF
  chmod a+x "$HOME_DIR/remove.sh"
}

# Function to create the updater script
create_updater_script() {
  cat > "$HOME_DIR/update.sh" <<EOF
#!/bin/sh
set -u
APP_NAME="$APP_NAME"
APP_DOWNLOAD_URL="$APP_DOWNLOAD_URL"
HOME_DIR="$HOME_DIR"
version=\$(curl -sL "\$APP_DOWNLOAD_URL" | grep -o '"browser_download_url": *"[^"]*"' | grep -o 'https://[^"]*' | grep -i '.*\.tar\.gz' | head -n 1)
if [ -n "\$version" ]; then
    mkdir -p "\$HOME_DIR/tmp" && cd "\$HOME_DIR/tmp" || exit 1
    curl -L -o "\$APP_NAME.tar.gz" "\$version" || exit 1
    mv "\$APP_NAME.tar.gz" "\$HOME_DIR/\$APP_NAME.tar.gz"
    echo "\$version" > "\$HOME_DIR/version"
    rm -rf "\$HOME_DIR/tmp"
    notify-send "\$APP_NAME is updated!"
else
    echo "Update not needed!"
fi
EOF
  chmod a+x "$HOME_DIR/update.sh"
}

# Main script execution
check_dependencies
create_directories
download_tar_gz
extract_tar_gz
configure_files
create_remover_script
create_updater_script

echo "Installation of $APP_NAME completed successfully."
