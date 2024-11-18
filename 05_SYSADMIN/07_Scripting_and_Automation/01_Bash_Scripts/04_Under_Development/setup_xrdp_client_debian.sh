#!/usr/bin/env bash

########################################################################
# File Name    : setup_xrdp_client_debian.sh
# Description  : This script configures an XRDP client on Debian to 
#                connect to an XRDP-enabled server. It installs the 
#                xfreerdp package for RDP client functionality and 
#                prompts the user to enter the IP address or hostname of 
#                the XRDP server, along with the username and password 
#                for authentication.
# Dependencies : freerdp2-x11 (xfreerdp), XRDP server IP/hostname, XRDP 
#                server username and password
# Usage        : • Make the script executable with 
#                  sudo chmod +x setup_xrdp_client_debian.sh
#                • Run the script with 
#                  bash setup_xrdp_client_debian.sh
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

echo "Configure XRDP client on Debian"

# Install xfreerdp
echo "Installing xfreerdp for RDP client..."
sudo apt update
sudo apt install -y freerdp2-x11

# Connect to XRDP server
read -p "Enter the IP address or hostname of the XRDP server: " server_ip
xfreerdp /v:$server_ip /u:<username> /p:<password>

