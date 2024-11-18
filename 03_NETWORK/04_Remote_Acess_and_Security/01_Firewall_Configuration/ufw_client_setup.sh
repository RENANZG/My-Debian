#!/bin/bash

########################################################################
# File Name    : ufw_client_setup.sh
# Description  : Script to install and configure UFW firewall on a client system.
# Dependencies : UFW package must be available in the repository.
# Usage        : • Make the script executable with 
#                sudo chmod +x ufw_client_setup.sh
#                • Run the script with no arguments:   
#                bash ufw_client_setup.sh
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Install ufw if it is not installed
if command_exists ufw; then
    echo "ufw is already installed."
else
    echo "ufw is not installed. Installing ufw..."
    sudo apt-get update
    sudo apt-get install -y ufw
    if [ $? -ne 0 ]; then
        echo "Failed to install ufw. Exiting."
        exit 1
    fi
fi

# Enable ufw
echo "Enabling ufw..."
sudo ufw enable

# Function to configure ufw
configure_ufw() {
    echo "Configuring ufw..."

    echo "Warning: The default policies can drop all communication unless specifically allowed."
    echo "Default policy for incoming traffic (deny/allow):"
    read DEFAULT_INCOMING
    sudo ufw default $DEFAULT_INCOMING incoming

    echo "Default policy for outgoing traffic (deny/allow):"
    read DEFAULT_OUTGOING
    sudo ufw default $DEFAULT_OUTGOING outgoing

    echo "Would you like to allow SSH? (yes/no):"
    read ALLOW_SSH
    if [ "$ALLOW_SSH" = "yes" ]; then
        echo "Enter the port number for SSH (default is 22):"
        read SSH_PORT
        sudo ufw allow $SSH_PORT/tcp
    fi

    echo "Would you like to allow HTTP traffic (port 80)? (yes/no):"
    read ALLOW_HTTP
    if [ "$ALLOW_HTTP" = "yes" ]; then
        sudo ufw allow 80
    fi

    echo "Would you like to allow HTTPS traffic (port 443)? (yes/no):"
    read ALLOW_HTTPS
    if [ "$ALLOW_HTTPS" = "yes" ]; then
        sudo ufw allow 443
    fi

    echo "Enter the IP range for internal network (e.g., 192.168.1.0/24):"
    read INTERNAL_IP_RANGE

    echo "Would you like to allow all internal traffic? (yes/no):"
    read ALLOW_INTERNAL
    if [ "$ALLOW_INTERNAL" = "yes" ]; then
        sudo ufw allow from $INTERNAL_IP_RANGE
    fi

    echo "Would you like to allow pings from internal network? (yes/no):"
    read ALLOW_INTERNAL_PING
    if [ "$ALLOW_INTERNAL_PING" = "yes" ]; then
        sudo ufw allow from $INTERNAL_IP_RANGE proto icmp
    fi

    echo "Would you like to allow pings from external sources? (yes/no):"
    read ALLOW_EXTERNAL_PING
    if [ "$ALLOW_EXTERNAL_PING" = "yes" ]; then
        sudo ufw allow proto icmp
    else
        sudo ufw deny proto icmp
    fi

    echo "Configuring VPN..."
    echo "Would you like to allow TUN (VPN) connections? (yes/no):"
    read ALLOW_VPN
    if [ "$ALLOW_VPN" = "yes" ]; then
        sudo ufw allow in on tun0
        sudo ufw allow out on tun0
    fi

    echo "Enter the port for VPN (e.g., 1194 for OpenVPN):"
    read VPN_PORT
    sudo ufw allow $VPN_PORT/udp

    echo "Enter the port for DNS (e.g., 53):"
    read DNS_PORT
    sudo ufw allow $DNS_PORT/udp

    echo "Allowing loopback device (localhost communication)..."
    sudo ufw allow in on lo
    sudo ufw allow out on lo

    echo "Configuration complete. Here is the status of your firewall:"
    sudo ufw status verbose
}

# Configure ufw
configure_ufw

# Function to explain each step
explain_steps() {
    echo ""
    echo "Explanation of the steps:"
    echo "1. Check if ufw is installed: Verifies if 'ufw' command is available."
    echo "2. Install ufw: Uses apt-get to install 'ufw' if not already installed."
    echo "3. Enable ufw: Activates ufw to start managing the firewall."
    echo "4. Configure ufw:"
    echo "   - Set default policy for incoming and outgoing traffic: Choose to allow or deny by default."
    echo "   - Allow SSH: Opens the specified port to allow remote access via SSH."
    echo "   - Allow HTTP: Opens port 80 to allow web traffic."
    echo "   - Allow HTTPS: Opens port 443 to allow secure web traffic."
    echo "   - Allow internal traffic: Allows traffic within the specified internal network range."
    echo "   - Allow internal pings: Allows ICMP (ping) requests from internal network."
    echo "   - Allow/Deny external pings: Allows or denies ICMP (ping) requests from external sources."
    echo "   - Allow TUN connections: Opens VPN tunnel interface."
    echo "   - Allow VPN and DNS ports: Allows specified VPN and DNS ports."
    echo "   - Allow loopback device: Allows internal communication within the host."
    echo "5. Show status: Displays the current configuration and status of the firewall."
}

# Explain the steps
explain_steps
