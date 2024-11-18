#!/usr/bin/env bash

########################################################################
# File Name    : install_kvm_qemu.sh
# Description  : Script to install or uninstall QEMU/KVM and securely
#                wipe images on Debian GNU/Linux.
# Disclaimer   : If you have sensitive data, consider additional
#                measures to ensure the destruction of the image data.
#                For SSDs, shred may not be as effective due to wear
#                leveling and the TRIM command. SSDs manage data
#                differently, potentially leaving some blocks untouched
#                by overwrite operations.
# Usage        : • Make the script executable with
#                sudo chmod +x install_kvm_qemu.sh
#                • Run the script with arguments:
#                 - To install:
#                  sudo bash install_qemu_kvm.sh
#                 - To uninstall:
#                  sudo bash install_kvm_qemu.sh remove
#                 - To securely wipe a file:
#                  sudo bash install_kvm_qemu.sh shred <path_to_file>
#                 - How to locate the folder
#                  sudo virsh list --all
#                  sudo virsh domstats name | grep path
#                 - Example: /var/lib/libvirt/images/name.qcow2
# Author       : Me and the bois
# License      : Free of charge, no warranty
# References   : https://www.linux-kvm.org
#                https://www.qemu.org
#                https://wiki.qemu.org/Category:User_documentation
########################################################################

# Function to display usage information
usage() {
    echo "Usage:"
    echo "  To install QEMU/KVM and related packages:"
    echo "    sudo ./install_qemu_kvm.sh"
    echo "  To uninstall QEMU/KVM and related packages:"
    echo "    sudo ./install_qemu_kvm.sh remove"
    echo "  To securely wipe a file with random data:"
    echo "    sudo ./install_qemu_kvm.sh shred <path_to_file>"
    echo ""
    echo "Disclaimer: If you have extremely sensitive data, consider additional measures such as encryption or physical destruction of the storage media."
    exit 1
}

# Function to securely wipe a file with shred
shred() {
    local file="$1"
    if [[ -z "$file" ]]; then
        echo "Error: Path to file not provided."
        usage
    fi

    echo "Securely wiping $file with random data..."
    shred --verbose --random-source=/dev/urandom -n1 --zero "$file"
    echo "Secure wipe complete."
}

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Default action is to install
ACTION="install"

# Check if an argument is provided
if [[ $# -gt 0 ]]; then
    case $1 in
        remove)
            ACTION="remove"
            ;;
        shred)
            ACTION="shred"
            ;;
        *)
            usage
            ;;
    esac
fi

# Handle installation
if [[ $ACTION == "install" ]]; then
    # Update package lists
    apt update

    # Install necessary packages
    apt install -y qemu-kvm qemu-system-x86 libvirt-daemon-system libvirt-clients virt-manager gir1.2-spiceclientgtk-3.0 dnsmasq qemu-utils iptables

    # Add current user to necessary groups
    usermod -aG libvirt $(whoami)
    usermod -aG kvm $(whoami)

    # Enable and start libvirtd service
    systemctl enable libvirtd
    systemctl start libvirtd

    echo "QEMU-KVM installation completed. Please log out and log back in for group membership changes to take effect."

# Handle uninstallation
elif [[ $ACTION == "remove" ]]; then
    # Stop and disable libvirtd service
    systemctl stop libvirtd
    systemctl disable libvirtd

    # Purge packages
    apt purge -y qemu-kvm qemu-system-x86 libvirt-daemon-system libvirt-clients virt-manager gir1.2-spiceclientgtk-3.0 dnsmasq qemu-utils

    # Remove configuration and user data
    rm -rf /etc/libvirt
    rm -rf ~/.config/dconf/user.d/virt-manager
    rm -rf ~/.virt-manager

    echo "QEMU-KVM and related packages have been uninstalled."

# Handle secure wipe
elif [[ $ACTION == "shred" ]]; then
    # Securely wipe the specified file
    shred "$2"

else
    usage
fi

exit 0
