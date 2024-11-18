#!/usr/bin/env bash

########################################################################
# File Name    : setup_vnc_secure_no_gui.sh
# Description  : This script sets up VNC in a secure manner without a 
#                graphical interface by using SSH tunneling for added 
#                security. It installs TightVNCServer, configures a VNC 
#                password, creates a startup script for the VNC server, 
#                and sets up an SSH tunnel for VNC using port forwarding. 
#                The script provides final instructions for starting the 
#                VNC server and connecting to it securely using SSH 
#                tunneling.
# Dependencies : Debian-based Linux distribution, TightVNCServer, SSH
# Usage        : • Make the script executable with 
#                  sudo chmod +x setup_vnc_secure_no_gui.sh
#                • Run the script without any arguments:   
#                  bash setup_vnc_secure_no_gui.sh
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

echo "Setting up VNC securely without a graphical interface"

# Install required software
echo "Installing required software..."
sudo apt update
sudo apt install -y tightvncserver

# Configure VNC password
echo "Configuring VNC password..."
vncpasswd

# Configure SSH tunnel for VNC
echo "Configuring SSH tunnel for VNC..."
read -p "Enter server hostname/IP: " server
read -p "Enter server username: " user
read -p "Enter path to SSH key: " ssh_key

cat <<EOF >> ~/.ssh/config
Host $server
    Hostname $server
    User $user
    IdentityFile $ssh_key
    IdentitiesOnly yes
    LocalForward 5900 127.0.0.1:5900
EOF

echo "SSH tunnel configured."

# Final Instructions
echo "Final Instructions"
echo "1. Start the VNC server:"
echo "   vncserver -localhost :0"
echo "2. Connect to the server securely using SSH and port forwarding:"
echo "   ssh -L 5900:localhost:5900 -i $ssh_key $user@$server"
echo "3. Use a VNC viewer on your local machine to connect to localhost:5900"
echo "   This will establish a secure connection to the VNC server through SSH tunneling."

