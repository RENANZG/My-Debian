#!/usr/bin/env bash

#######################################################################
# File Name    : install_ventoy.sh
# Description  : This script automates the installation and setup of
#                an application. It downloads the latest version from a
#                specified source using curl, installs it to the user's
#                home directory, creates necessary directories and
#                symbolic links
# Dependencies : curl, bubblewrap, tar, rsvg-convert (optional)
# Usage        : • Make the script executable with
#                  chmod +x install_ventoy.sh
#                • Run the script with:
#                  bash install_ventoy.sh
#                • To update, run:
#                  bash $HOME/.local/share/ventoy/update.sh
#                • To remove, run:
#                  bash $HOME/.local/share/ventoy/remove.sh
# Author       : Me and the bois
# License      : Free of charge, no warranty
# Inspired by  : https://portable-linux-apps.github.io
#######################################################################

# Safety check
set -eu

# Define variables
APP_NAME="ventoy"
APP_DOWNLOAD_URL="https://api.github.com/repos/ventoy/Ventoy/releases/latest"
HOME_DIR="$HOME/.local/share/$APP_NAME"
INSTALL_DIR="$HOME_DIR/ventoy"
TAR_FILE="$HOME_DIR/$APP_NAME-linux.tar.gz"
VENTOY_EXEC="$INSTALL_DIR/VentoyGUI.x86_64"
DESKTOP_ENTRY="$HOME/.local/share/applications/$APP_NAME.desktop"

# Function to check if required dependencies are installed
check_dependencies() {
  local dependencies=("curl" "tar" "grep" "chmod")
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
  mkdir -p "$HOME_DIR" "$INSTALL_DIR"
}

# Function to download the latest Ventoy release
download_ventoy() {
  # Fetch the latest release data from GitHub API
  RESPONSE=$(curl -sL "$APP_DOWNLOAD_URL")

  # Extract the download URL for the Linux tar.gz file
  VERSION_URL=$(echo "$RESPONSE" | grep -oP '"browser_download_url": *"\K[^"]*' | grep 'ventoy-.*-linux.tar.gz' | head -n 1)

  # If no URL was found, exit with an error
  if [[ -z "$VERSION_URL" ]]; then
    echo "Error: No valid Ventoy download URL found."
    exit 1
  fi

  echo "Downloading Ventoy from $VERSION_URL..."
  curl -L -o "$TAR_FILE" "$VERSION_URL" || { echo "Error: Download failed."; exit 1; }
}

# Function to extract Ventoy
extract_ventoy() {
  echo "Extracting Ventoy from $TAR_FILE..."

  if [ ! -f "$TAR_FILE" ]; then
    echo "Error: Tar file not found."
    exit 1
  fi

  # Extract the tar.gz file
  tar -xzf "$TAR_FILE" -C "$HOME_DIR" || { echo "Error: Extraction failed."; exit 1; }

  # Cleanup tar file after extraction
  rm "$TAR_FILE"
}

# Function to configure the desktop entry for Ventoy
create_desktop_entry() {
  cat > "$DESKTOP_ENTRY" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=$APP_NAME
Exec=$VENTOY_EXEC
Icon=$HOME_DIR/icon.png
Terminal=false
Categories=Utility;
EOF
  chmod +x "$DESKTOP_ENTRY"
}

# Function to create a cleanup/removal script
create_remover_script() {
  cat > "$HOME_DIR/remove.sh" <<EOF
#!/bin/sh
set -e
rm -f "$DESKTOP_ENTRY"
rm -rf "$HOME_DIR"
echo "$APP_NAME removed."
EOF
  chmod +x "$HOME_DIR/remove.sh"
}

# Main script execution
check_dependencies
create_directories
download_ventoy
extract_ventoy
create_desktop_entry
create_remover_script

echo "Installation of $APP_NAME completed successfully."
