#!/usr/bin/env bash

########################################################################
# File Name    : whonix_kvm_setup.sh
# Description  : This script sets up the Whonix KVM environment and can
#                securely clean up data.
# Dependencies : curl, virsh, tar, gpg, shred
# Usage        : • Make the script executable with
#                sudo chmod +x whonix_kvm_setup.sh
#                • Run the script with no arguments to setup:
#                sudo ./whonix_kvm_setup.sh
#                • Run the script with 'secure_wipe' to clean up:
#                sudo ./whonix_kvm_setup.sh clean
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

# Function to display usage information
usage() {
    echo "Usage:"
    echo "  To setup Whonix KVM environment:"
    echo "    sudo ./whonix_kvm_setup.sh"
    echo "  To clean up Whonix data directory securely:"
    echo "    sudo ./whonix_kvm_setup.sh secure_wipe"
    exit 1
}

# Function for securely wiping a file with shred
secure_wipe() {
    local file="$1"
    if [[ -z "$file" ]]; then
        echo "Error: Path to file not provided."
        usage
    fi

    echo "Securely wiping $file with random data..."
    shred --verbose --random-source=/dev/urandom -n1 --zero "$file"
    echo "Secure wipe complete."
}

# Function to clean up the whonix_data directory
if [ "$1" == "secure_wipe" ]; then
    echo "Cleaning up the whonix_data directory..."
    find whonix_data -type f -exec secure_wipe {} \;
    find whonix_data -type d -exec rm -rf {} +
    echo "Cleaned up the whonix_data/ directory!"
    echo "You can now re-run the script with:"
    echo "$0"
    exit 0
fi

# Function to check dependencies
check_dependencies() {
    for cmd in curl virsh tar gpg; do
        if ! command -v $cmd &>/dev/null; then
            echo "Error: $cmd is not installed."
            exit 1
        fi
    done

    # Check if libvirt and KVM are installed
    if ! systemctl is-active --quiet libvirtd; then
        echo "Error: libvirtd is not running or not installed."
        exit 1
    fi

    if ! lsmod | grep -q kvm; then
        echo "Error: KVM is not loaded."
        exit 1
    fi
}

# Function to download the latest Whonix version
download_whonix() {
    echo "[+] Detecting the latest Whonix version..."
    WHONIX_VERSION=$(curl -s -L https://www.whonix.org/wiki/Download | grep -oP 'Whonix-Gateway-XFCE-\K[\d\.]+' | head -1)

    if [ -z "$WHONIX_VERSION" ]; then
        echo "Could not detect the latest version of Whonix."
        exit 1
    fi

    echo "[+] Latest Whonix version detected: $WHONIX_VERSION"

    WHONIX_GATEWAY_URL="https://download.whonix.org/libvirt/$WHONIX_VERSION/Whonix-Gateway-XFCE-$WHONIX_VERSION.libvirt.xz"
    WHONIX_WORKSTATION_URL="https://download.whonix.org/libvirt/$WHONIX_VERSION/Whonix-Workstation-XFCE-$WHONIX_VERSION.libvirt.xz"
    WHONIX_KEY_URL="https://www.whonix.org/keys/whonix-signing-key.asc"
    WHONIX_GATEWAY_SIG_URL="https://download.whonix.org/libvirt/$WHONIX_VERSION/Whonix-Gateway-XFCE-$WHONIX_VERSION.libvirt.xz.asc"
    WHONIX_WORKSTATION_SIG_URL="https://download.whonix.org/libvirt/$WHONIX_VERSION/Whonix-Workstation-XFCE-$WHONIX_VERSION.libvirt.xz.asc"

    mkdir -p whonix_data
    curl -L -o whonix_data/Whonix-Gateway.libvirt.xz $WHONIX_GATEWAY_URL
    curl -L -o whonix_data/Whonix-Workstation.libvirt.xz $WHONIX_WORKSTATION_URL
    curl -L -o whonix_data/Whonix-Gateway.libvirt.xz.asc $WHONIX_GATEWAY_SIG_URL
    curl -L -o whonix_data/Whonix-Workstation.libvirt.xz.asc $WHONIX_WORKSTATION_SIG_URL
    curl -L -o whonix_data/whonix-signing-key.asc $WHONIX_KEY_URL
}

# Function to verify Whonix images
verify_whonix() {
    echo "[+] Verifying Whonix images..."
    gpg --no-default-keyring --keyring ./whonix_data/tmp_keyring.pgp --import ./whonix_data/whonix-signing-key.asc

    if gpg --no-default-keyring --keyring ./whonix_data/tmp_keyring.pgp --fingerprint 916B 01C6 | grep "916B 01C6 7113 EA83 77FA  AD09 6D1D 8367 916B 01C6"; then
        echo "The imported Whonix developer key is valid."
    else
        echo "ERROR! The imported key does not seem to be the correct one. Something is wrong!"
        exit 1
    fi

    if gpg --no-default-keyring --keyring ./whonix_data/tmp_keyring.pgp --verify ./whonix_data/Whonix-Gateway.libvirt.xz.asc ./whonix_data/Whonix-Gateway.libvirt.xz; then
        echo "The Whonix-Gateway image is legit."
    else
        echo "ERROR! The Whonix-Gateway image does not seem to be signed by the Whonix key. Something is wrong!"
        exit 1
    fi

    if gpg --no-default-keyring --keyring ./whonix_data/tmp_keyring.pgp --verify ./whonix_data/Whonix-Workstation.libvirt.xz.asc ./whonix_data/Whonix-Workstation.libvirt.xz; then
        echo "The Whonix-Workstation image is legit."
    else
        echo "ERROR! The Whonix-Workstation image does not seem to be signed by the Whonix key. Something is wrong!"
        exit 1
    fi
}

# Function to extract Whonix images
extract() {
    echo "[+] Extracting Whonix images..."
    mkdir -p whonix_data/extracted
    tar -xvf whonix_data/Whonix-Gateway.libvirt.xz -C whonix_data/extracted
    tar -xvf whonix_data/Whonix-Workstation.libvirt.xz -C whonix_data/extracted
}

# Function to import networks
import_networks() {
    echo "[+] Importing Whonix networks..."
    sed -i 's/\bvirbr1\b/virbr100/g' whonix_data/extracted/Whonix_external*.xml
    sed -i 's/\bvirbr2\b/virbr101/g' whonix_data/extracted/Whonix_internal*.xml

    virsh net-define whonix_data/extracted/Whonix_external*.xml
    virsh net-define whonix_data/extracted/Whonix_internal*.xml

    virsh net-autostart Whonix-External
    virsh net-start Whonix-External
    virsh net-autostart Whonix-Internal
    virsh net-start Whonix-Internal
}

# Function to import images
import_images() {
    echo "[+] Importing Whonix images..."
    mv whonix_data/extracted/Whonix-Gateway*.qcow2 /var/lib/libvirt/images/Whonix-Gateway.qcow2
    mv whonix_data/extracted/Whonix-Workstation*.qcow2 /var/lib/libvirt/images/Whonix-Workstation.qcow2

    virsh define whonix_data/extracted/Whonix-Gateway*.xml
    virsh define whonix_data/extracted/Whonix-Workstation*.xml
}

# Main script execution
main() {
    check_dependencies

    if [ ! -d "whonix_data/extracted" ]; then
        download_whonix
        verify_whonix
        extract
    fi

    import_networks
    import_images

    echo -e "\n#### Whonix setup completed successfully. ####\n"
    exit 0
}

main
