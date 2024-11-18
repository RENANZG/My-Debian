#!/bin/bash

########################################################################
# File Name    : install_strongswan.sh
# Description  : Installs StrongSwan along with essential utilities
# Dependencies : Debian-based system
# Usage        : • Make the script executable with:
#                sudo chmod +x install_strongswan.sh
#                • Run the script with:
#                sudo bash install_strongswan.sh
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

# Install StrongSwan and related utilities
print_message "Installing StrongSwan and essential utilities..."
sudo apt install -y strongswan strongswan-charon

# Verify installation
print_message "Checking StrongSwan version..."
strongswan --version

# Enable and start StrongSwan service
print_message "Enabling and starting StrongSwan service..."
sudo systemctl enable strongswan
sudo systemctl start strongswan

# Check the status of StrongSwan service
print_message "Checking StrongSwan service status..."
sudo systemctl status strongswan

# Print usage of essential utilities
print_message "Printing usage information for essential StrongSwan utilities..."
print_message "Usage for 'ipsec':"
sudo ipsec --help | head -n 10

print_message "Usage for 'ipsec pki':"
ipsec pki --help | head -n 10

print_message "Usage for 'ipsec status':"
sudo ipsec status | head -n 10

print_message "Usage for 'ipsec statusall':"
sudo ipsec statusall | head -n 10

print_message "Usage for 'ipsec sas':"
sudo ipsec sas | head -n 10

print_message "Usage for 'ipsec strokes':"
sudo ipsec strokes | head -n 10

print_message "Usage for 'ipsec traffic':"
sudo ipsec traffic | head -n 10

print_message "Installation and setup complete!"