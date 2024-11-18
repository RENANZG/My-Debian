#!/usr/bin/env bash

########################################################################
# File Name    : install_dangerzone.sh
# Description  : This script installs Dangerzone in Podman sandbox on
#                Debian-based systems. It sets up the necessary
#                repository, imports the GPG key, and installs the
#                required packages.
# Dependencies : curl ca-certificates gnupg2
# Usage        : • Make the script executable with:
#                sudo chmod +x install_dangerzone.sh
#                • Run the script with:
#                sudo bash install_dangerzone.sh
# Author       : My and the bois
# License      : Free of charge, no warranty
# References   : https://github.com/freedomofpress/dangerzone
#                https://podman.io
########################################################################

# Define variables
REPO_URL="https://packages.freedom.press/apt-tools-prod"
GPG_KEY_ID="DE28AB241FA48260FAC9B8BAA7C9B38522604281"
GPG_KEYSERVER="hkps://keys.openpgp.org"
KEYRING_PATH="/etc/apt/keyrings/fpf-apt-tools-archive-keyring.gpg"
REPO_LIST_PATH="/etc/apt/sources.list.d/fpf-apt-tools.list"
GPG_KEY_URL="https://keys.openpgp.org/vks/v1/by-fingerprint/$GPG_KEY_ID"

# Update and install required packages
sudo apt update && sudo apt install -y curl ca-certificates gnupg2

# Download and add GPG key for the Freedom Press repository
curl -fsSL "$GPG_KEY_URL" | gpg --no-default-keyring --keyring ./fpf-apt-tools-archive-keyring.gpg --import
sudo mkdir -p /etc/apt/keyrings/
sudo mv fpf-apt-tools-archive-keyring.gpg "$KEYRING_PATH"

# Add Freedom Press repository to the APT sources
. /etc/os-release
echo "deb [signed-by=$KEYRING_PATH] $REPO_URL ${VERSION_CODENAME?} main" | sudo tee "$REPO_LIST_PATH"

# Update package list
sudo apt update

# Install Podman
sudo apt install -y podman

# Install Dangerzone
sudo apt install -y dangerzone

# Installation complete
echo "Dangerzone installation complete!"
