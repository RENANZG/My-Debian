#!/usr/bin/env bash

########################################################################
# File Name    : setup_vnc_gui_openbox.sh
# Description  : This script sets up VNC with Openbox
# Dependencies : Debian-based Linux distribution, Openbox, 
#                TightVNCServer
# Usage        : • Make the script executable with 
#                  sudo chmod +x setup_vnc_gui_openbox.sh
#                • Run the script without any arguments:   
#                  bash setup_vnc_gui_openbox.sh
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

echo "Setting up VNC over SSH on Debian with minimal window manager"

# Server Setup
echo "Server Setup"
echo "Installing required software..."
sudo apt update
sudo apt install -y openbox tightvncserver

# Configure Openbox autostart for VNC
echo "Configuring Openbox autostart for VNCServer..."
mkdir -p ~/.config/openbox
echo 'xsetroot -solid black &' > ~/.config/openbox/autostart
echo 'x-terminal-emulator -e vncserver :1' >> ~/.config/openbox/autostart

# Start VNCServer
vncserver :1 -geometry 1280x960 -depth 16

# Final Instructions
echo "Final Instructions#"
echo "Connect to the server using a VNCViewer and specify the display number 1 (e.g., 127.0.0.1:1) to access the graphical environment."
