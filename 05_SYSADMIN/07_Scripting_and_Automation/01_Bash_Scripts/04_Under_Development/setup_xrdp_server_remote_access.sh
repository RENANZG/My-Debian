#!/usr/bin/env bash

########################################################################
# File Name    : setup_xrdp_remote_access_debian.sh
# Description  : This script configures remote access on a Debian system *                using XRDP (Remote Desktop Protocol). It installs XRDP 
#                from the Debian repositories, confirms XRDP service 
#                status, adds the xrdp user to the ssl-cert group for 
#                SSL authentication, enables the XRDP service to start 
#                on boot, adds a Policy Kit rule for XRDP, and restarts 
#                the XRDP service to apply changes.
# Dependencies : XRDP, dbus-x11, SSH (for connection)
# Usage        : • Make the script executable with 
#                  sudo chmod +x setup_xrdp_remote_access_debian.sh
#                • Run the script without any arguments:   
#                  bash setup_xrdp_remote_access_debian.sh
# Author       : Me and the bois
# License      : Free of charges, no warranty
########################################################################

echo " Configure remote access with XRDP on Debian "

# Install XRDP and dbus-x11
echo "1. Installing XRDP from the Debian repositories..."
sudo apt update
sudo apt install -y xrdp dbus-x11

# Confirm XRDP service status
echo "2. Confirming XRDP service status..."
sudo systemctl status xrdp

# Add xrdp user to ssl-cert group
echo "3. Adding xrdp user to the ssl-cert group..."
sudo adduser xrdp ssl-cert

# Enable XRDP service to start on boot
echo "4. Enabling XRDP service..."
sudo systemctl enable xrdp

# Add Policy Kit rule for XRDP
echo "5. Adding Policy Kit rule for XRDP..."
sudo bash -c 'cat <<EOF > /etc/polkit-1/localauthority.conf.d/02-allow-colord.conf
polkit.addRule(function(action, subject) {
    if ((action.id == "org.freedesktop.color-manager.create-device" || action.id == "org.freedesktop.color-manager.create-profile" || action.id == "org.freedesktop.color-manager.delete-device" || action.id == "org.freedesktop.color-manager.delete-profile" || action.id == "org.freedesktop.color-manager.modify-device" || action.id == "org.freedesktop.color-manager.modify-profile") && subject.isInGroup("ssl-cert"))
    {
        return polkit.Result.YES;
    }
});
EOF'

# Restart XRDP service for changes to take effect
echo "6. Restarting XRDP service..."
sudo systemctl restart xrdp

echo " XRDP setup completed successfully "
