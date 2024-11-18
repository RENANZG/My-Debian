#!/bin/bash

########################################################################
# File Name    : install_wireguard.sh
# Description  : Installs WireGuard and essential utilities
# Dependencies : Debian-based system
# Usage        : • Make the script executable with:
#                sudo chmod +x install_wireguard_with_utils.sh
#                • Run the script with:
#                sudo bash install_wireguard_with_utils.sh
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

# Function to print messages
function print_message() {
    echo "[INFO] $1"
}

# Update package index
print_message "Updating package index..."
sudo apt update

# Install WireGuard and essential utilities
print_message "Installing WireGuard and essential utilities..."
sudo apt install -y wireguard wireguard-tools

# Verify installation
print_message "Checking WireGuard version..."
wg --version

# Load WireGuard kernel module
print_message "Loading WireGuard kernel module..."
sudo modprobe wireguard

# Check if the WireGuard module is loaded
if lsmod | grep -q wireguard; then
    print_message "WireGuard kernel module is loaded."
else
    print_message "WireGuard kernel module is not loaded. Please check for kernel compatibility."
fi

# Print usage of essential utilities
print_message "Printing usage information for essential WireGuard utilities..."
print_message "Usage for 'wg':"
wg --help | head -n 10

print_message "Usage for 'wg-quick':"
wg-quick --help | head -n 10

# Enable and start WireGuard service if a config file exists
CONFIG_FILE="/etc/wireguard/wg0.conf"
if [[ -f "$CONFIG_FILE" ]]; then
    print_message "Enabling and starting WireGuard service for wg0..."
    sudo systemctl enable wg-quick@wg0
    sudo systemctl start wg-quick@wg0
else
    print_message "Configuration file $CONFIG_FILE not found. Skipping service enablement."
fi

print_message "Installation and setup complete!"
