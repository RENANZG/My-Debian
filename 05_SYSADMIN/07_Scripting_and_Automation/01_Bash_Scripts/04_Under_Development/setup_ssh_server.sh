#!/usr/bin/env bash

########################################################################
# File Name    : configure_server_ssh.sh
# Description  : This script automates the configuration of Secure Shell 
#                (SSH) on the server side, specifically targeting the 
#                initrd (initial RAM disk) phase for added security 
#                during boot. It sets up both OpenSSH server and 
#                Dropbear in the initramfs environment. To run such a 
#                script on a VPS (Virtual Privite Server), you would 
#                first need access to the VPS, usually through SSH. You 
#                can SSH into your VPS and execute the script directly 
#                on the server that allow remote execution.
# Dependencies : This script requires sudo privileges to install 
#                packages and configure system settings. It assumes 
#                access to a KVM virtualization environment with serial 
#                console access and interaction through a VNC server 
#                during boot.
# Usage        : • Before running the script on your VPS, make any 
#                  necessary modifications such as updating placeholder 
#                  values like SSH keys or server IP addresses to match 
#                  your actual configuration.
#                • Make the script executable with:
#                  sudo chmod +x configure_server_ssh.sh
#                • Run the script with no arguments:
#                  bash configure_server_ssh.sh
# Author       : Me and the bois
# License      : Free of charge, no warranty
# References   : https://www.openssh.com
#                https://matt.ucc.asn.au/dropbear/dropbear.html
########################################################################

# Exit immediately if a command exits with a non-zero status
set -e

# Function to check if the script is run as root
check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "This script must be run as root"
        exit 1
    fi
}

# Prompt for password securely
read -sp "Enter password: " password
echo

# Create a temporary file for the password
pw_file=$(mktemp)
chmod 600 "$pw_file"
echo -n "$password" > "$pw_file"

# Clean up the temporary password file
cleanup() {
    rm -f "$pw_file"
}
trap cleanup EXIT

# Call the check_root function to ensure the script is run as root
check_root

# Install necessary packages
sudo apt update
sudo apt install -y openssh-server dropbear-initramfs debian-archive-keyring

# Configure SSH server
sudo systemctl enable ssh
sudo systemctl start ssh

# Add your SSH key to authorized_keys
mkdir -p ~/.ssh
echo "your-public-ssh-key" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
chmod 700 ~/.ssh

# Configure Dropbear for initramfs
echo "Adding Dropbear configuration to initramfs..."
sudo bash -c 'cat <<EOF > /etc/dropbear-initramfs/config
DROPBEAR_OPTIONS="-p 2222"
EOF'

# Add your SSH key to Dropbear authorized_keys
sudo mkdir -p /etc/dropbear-initramfs/.ssh
sudo cp ~/.ssh/authorized_keys /etc/dropbear-initramfs/.ssh/authorized_keys

# Update initramfs to include Dropbear
sudo update-initramfs -u

# Print instructions for VNC access
echo "Configuration complete. You can now reboot the server."
echo "To access the server during the initrd phase, connect via VNC and use the serial console or netboot image to initiate QEMU."
echo "Once the initrd phase starts, you can SSH into the server using the following command:"
echo "ssh -p 2222 root@your-server-ip"

echo "Note: Replace 'your-server-ip' with the actual IP address of your server."

# Optional: Set a passphrase for the server's root account if needed
# echo "Setting a passphrase for the root account..."
# sudo passwd root

echo "Done."
