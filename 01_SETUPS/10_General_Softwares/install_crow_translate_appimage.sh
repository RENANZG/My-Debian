#!/usr/bin/env bash

# BWRAP Rule not passed correctly, to do: best editing of the desktop entry

#######################################################################
# File Name    : install_crow_translate_appimage.sh
# Description  : This script automates the installation and setup of
#                Crow Translate AppImage. It downloads the latest
#                version from the KDE download site, installs it to the
#                user's home directory, creates necessary directories
#                and symbolic links, provides updater and remover
#                scripts, and runs the application inside a bubblewrap
#                (bwrap) sandbox for added security.
# Dependencies : curl, bubblewrap, rsvg-convert (optional)
# Usage        : • Make the script executable with
#                  chmod +x install_crow_translate_appimage.sh
#                • Run the script with:
#                  bash install_crow_translate_appimage.sh
#                • To update, run:
#                  bash $HOME/.local/share/crow-translate/update.sh
#                • To remove, run:
#                  bash $HOME/.local/share/crow-translate/remove.sh
# Author       : Me and the bois
# License      : Free of charge, no warranty
# Inspired by  : https://portable-linux-apps.github.io
#######################################################################

# Safety check
set -eu

APP_NAME="crow-translate"
BASE_URL="https://ftp.gwdg.de/pub/linux/kde/stable/crow-translate"
HOME_DIR="$HOME/.local/share/$APP_NAME"

# Bubblewrap options (change as needed)
get_bwrap_cmd() {
  local DISPLAY_VALUE="${DISPLAY:-:0}"
  local USER_ID=$(id -u)
  echo "bwrap \
--cap-add CAP_SYS_ADMIN \
--dev-bind /dev /dev \
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
--dev-bind /dev/dri /dev/dri \
--setenv DISPLAY $DISPLAY_VALUE \
--tmpfs /run \
--tmpfs /tmp \
--bind \"$HOME\" \"$HOME\" \
--bind \"$APPIMAGE_FILE\" \"$APPIMAGE_FILE\" \
--bind \"$HOME/.config/$APP_NAME\" \"$HOME/.config/$APP_NAME\" \
--bind \"$HOME/.cache/$APP_NAME\" \"$HOME/.cache/$APP_NAME\" \
--bind /run/user/$USER_ID/dconf /run/user/$USER_ID/dconf \
--bind /run/user/$USER_ID/bus /run/user/$USER_ID/bus \
--bind /run/user/$USER_ID/pulse /run/user/$USER_ID/pulse \
--bind /run/user/$USER_ID/at-spi /run/user/$USER_ID/at-spi \
--bind /run/dbus/system_bus_socket /run/dbus/system_bus_socket \
--bind /etc/mtab /etc/mtab \
/bin/sh -c \"$APPIMAGE_FILE\""
}

# Variables based on FreeDesktop.org defaults
APPIMAGE_FILE="$HOME_DIR/$APP_NAME.AppImage"
DESKTOP_ENTRY="$HOME/.local/share/applications/$APP_NAME.desktop"

# Function to check if required dependencies are installed
check_dependencies() {
  local dependencies=("bwrap" "curl")
  for cmd in "${dependencies[@]}"; do
    if ! command -v "$cmd" > /dev/null 2>&1; then
      echo "Error: $cmd is not installed. Please install it first."
      exit 1
    fi
  done
  echo "All dependencies are installed."
}

# Function to create necessary directories
create_directories() {
  mkdir -p "$HOME_DIR" \
  "$HOME_DIR/icon" \
  "$HOME/.local/share/applications" \
  "$HOME/.cache/$APP_NAME" \
  "$HOME/.config/$APP_NAME"
}

# Function to fetch the latest version dynamically
fetch_latest_version() {
  echo "Fetching the latest version..."

  # Get the directory list from the base URL and extract the latest version using regex
  LATEST_VERSION=$(curl -s "$BASE_URL/" | grep -oP '(?<=href=")[0-9]+\.[0-9]+\.[0-9]+(?=/)' | sort -V | tail -n 1)

  # Check if we found a version
  if [ -z "$LATEST_VERSION" ]; then
    echo "Error: Could not fetch the latest version."
    exit 1
  fi

  echo "Latest version found: $LATEST_VERSION"
}

# Function to download the latest AppImage
download_appimage() {
  echo "Fetching the latest AppImage..."

  # Fetch the latest version
  fetch_latest_version

  # Fetch the HTML directory listing for the latest version and find the AppImage file
  APP_DOWNLOAD_URL=$(curl -s "$BASE_URL/$LATEST_VERSION/" | grep -oP 'href="\K([^"]*crow-translate-release_[^"]*\.AppImage)' | head -n 1)

  # Check if we found an AppImage file
  if [ -z "$APP_DOWNLOAD_URL" ]; then
    echo "Error: No AppImage found at $BASE_URL/$LATEST_VERSION/"
    exit 1
  fi

  # Construct the full URL for downloading
  APP_DOWNLOAD_URL="$BASE_URL/$LATEST_VERSION/$APP_DOWNLOAD_URL"

  # Print the constructed URL before the download
  echo "DEBUG: Full URL constructed: $APP_DOWNLOAD_URL"  # Debug output

  # Check if the URL is valid by attempting to fetch it
  if curl --output /dev/null --silent --head --fail "$APP_DOWNLOAD_URL"; then
    echo "Downloading AppImage from $APP_DOWNLOAD_URL..."
    curl -L -o "$APPIMAGE_FILE" "$APP_DOWNLOAD_URL" || { echo "Error: Download failed."; exit 1; }
    chmod +x "$APPIMAGE_FILE"
  else
    echo "Error: The URL is unreachable or incorrect."
    exit 1
  fi
}

# Function to extract AppImage
extract_appimage() {
  echo "Extracting AppImage from $APPIMAGE_FILE..."

  if [ ! -f "$APPIMAGE_FILE" ]; then
    echo "Error: AppImage not found."
    exit 1
  fi

  # Extract AppImage
  "$APPIMAGE_FILE" --appimage-extract > /dev/null 2>&1 || { echo "Error: Extraction failed."; exit 1; }

  # Ensure squashfs-root was created
  if [ ! -d "$HOME/squashfs-root" ]; then
    echo "Error: squashfs-root directory not found after extraction."
    exit 1
  fi
}

# Function to configure extracted files (desktop entry, icon)
configure_files() {
  local EXTRACTED_DIR="$HOME/squashfs-root"
  DESKTOP_ENTRY_SRC=$(find "$EXTRACTED_DIR" -name "*.desktop" | head -n 1)
  ICON_FILE=$(find "$EXTRACTED_DIR" -name "*.png" -o -name "*.svg" | head -n 1)

  if [ ! -f "$DESKTOP_ENTRY_SRC" ] || [ -z "$ICON_FILE" ]; then
    echo "Error: Required files (desktop entry or icon) not found in the extracted AppImage."
    exit 1
  fi

  # Initialize the icon path variable
  local ICON_PATH=""

  # Check for PNG icon
  if [[ "$ICON_FILE" == *.png ]]; then
    cp "$ICON_FILE" "$HOME_DIR/icon/$APP_NAME.png"
    ICON_PATH="$HOME_DIR/icon/$APP_NAME.png"
  elif [[ "$ICON_FILE" == *.svg ]]; then
    cp "$ICON_FILE" "$HOME_DIR/icon/$APP_NAME.svg"
    ICON_PATH="$HOME_DIR/icon/$APP_NAME.svg"
  fi

  # Escape slashes in icon path
  ICON_PATH_ESCAPED=$(echo "$ICON_PATH" | sed 's/\//\\\//g')

  # Modify the desktop entry
  sed -i "s@^Exec=.*@Exec=$HOME_DIR/$APP_NAME.AppImage@g" "$DESKTOP_ENTRY_SRC"
  sed -i "s@^Icon=.*@Icon=$ICON_PATH_ESCAPED@g" "$DESKTOP_ENTRY_SRC"

  # Copy the desktop entry to the appropriate directories
  cp "$DESKTOP_ENTRY_SRC" "$DESKTOP_ENTRY"
  cp "$DESKTOP_ENTRY" "$HOME/Desktop"

  # Cleanup the temporary extraction directory
  rm -rf "$EXTRACTED_DIR"
}

# Function to create the remover script
create_remover_script() {
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
}

# Function to create the updater script
create_updater_script() {
  cat > "$HOME_DIR/update.sh" <<EOF
#!/bin/sh
set -eu
APP_NAME="$APP_NAME"
BASE_URL="$BASE_URL"

# Function to fetch the latest version dynamically
fetch_latest_version() {
  echo "Fetching the latest version..."

  # Get the directory list from the base URL and extract the latest version using regex
  LATEST_VERSION=\$(curl -s "\$BASE_URL/" | grep -oP '(?<=href=")[0-9]+\.[0-9]+\.[0-9]+(?=/)' | sort -V | tail -n 1)

  # Check if we found a version
  if [ -z "\$LATEST_VERSION" ]; then
    echo "Error: Could not fetch the latest version."
    exit 1
  fi

  echo "Latest version found: \$LATEST_VERSION"
}

# Fetch the latest version
fetch_latest_version

APP_DOWNLOAD_URL=\$(curl -sL "\$BASE_URL/\$LATEST_VERSION/" | grep -oP 'href="\K([^"]*crow-translate-release_[^"]*\.AppImage)' | head -n 1)
VERSION_URL="\$BASE_URL/\$LATEST_VERSION/\$APP_DOWNLOAD_URL"
echo "Downloading AppImage from \$VERSION_URL..."
curl -L -o "\$HOME_DIR/\$APP_NAME.AppImage" "\$VERSION_URL" || exit 1
chmod a+x "\$HOME_DIR/\$APP_NAME.AppImage" || exit 1
notify-send "\$APP_NAME is updated!"
gtk-update-icon-cache "\$HOME_DIR/icon" > /dev/null 2>&1
EOF
  chmod a+x "$HOME_DIR/update.sh"
}

# Main script execution
check_dependencies
create_directories
download_appimage
extract_appimage
configure_files
create_remover_script
create_updater_script

echo "Crow Translate has been successfully installed!"
