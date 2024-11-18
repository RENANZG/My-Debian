#!/usr/bin/env bash

########################################################################
# File Name    : qubes_usb_install.sh
# Description  : Script to download, verify, and write Qubes OS on a
#                USB drive. This script prepares the USB drive as a
#                Qubes OS installer, not as a bootable live Qubes OS
#                environment. The size of the ISO is around 6 GB.
#                Qubes OS is designed to be installed on internal
#                storage devices rather than USB drives due to its
#                complex architecture and resource requirements.
#                Running Qubes OS from a USB drive is generally not
#                recommended because of performance, stability, and
#                security reasons. Qubes OS, by default, blocks direct
#                access to USB devices for security reasons, because of
#                assigns USB devices to a dedicated USB qube.
# Dependencies : curl, gpg, dd, coreutils
# Usage        : • Make the script executable with
#                sudo chmod +x qubes_usb_install.sh
#                • Run the script with no arguments:
#                sudo bash qubes_usb_install.sh
#                • To clean up the qubes_data directory:
#                sudo bash qubes_usb_install.sh clean
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

# Variables
QUOTES_URL="https://www.qubes-os.org/downloads/"
MIRROR_URL="https://mirrors.edge.kernel.org/qubes/iso/"
KEY_URL="https://keys.qubes-os.org/keys/qubes-release-4-signing-key.asc"
TEMP_KEYRING="./qubes_data/tmp_keyring.pgp"
FINGERPRINT="427F11FD"
KEY_FINGERPRINT="427F 11FD 0FAA 4B08 15C2 67FD 5C65 68D3 8D17 93A9"

# Function to clean up the qubes_data directory
clean_up() {
  find qubes_data -not -path qubes_data -delete
  echo "Cleaned up the qubes_data/ directory!"
  echo "You can now re-run the script with:"
  echo "$0"
  exit 0
}

if [ "$1" == "clean" ]; then
  clean_up
fi

# Function to check dependencies
check_dependencies() {
    for cmd in curl gpg dd lsblk; do
        if ! command -v $cmd &>/dev/null; then
            echo "Error: $cmd is not installed."
            exit 1
        fi
    done
}

# Function to download the latest Qubes version
download_qubes() {
    echo "[+] Detecting the latest Qubes version..."
    QUBES_VERSION=$(curl -s -L $QUOTES_URL | grep -oP 'Qubes-R\K[0-9.]+-x86_64' | head -1)

    if [ -z "$QUBES_VERSION" ]; then
        echo "Could not detect the latest version of Qubes."
        exit 1
    fi

    echo "[+] Latest Qubes version detected: $QUBES_VERSION"

    QUBES_ISO_URL="${MIRROR_URL}Qubes-R${QUBES_VERSION}.iso"
    QUBES_SIG_URL="${MIRROR_URL}Qubes-R${QUBES_VERSION}.iso.asc"

    mkdir -p qubes_data
    curl -L -o qubes_data/Qubes-R${QUBES_VERSION}.iso $QUBES_ISO_URL
    curl -L -o qubes_data/Qubes-R${QUBES_VERSION}.iso.asc $QUBES_SIG_URL
    curl -L -o qubes_data/qubes-release-4-signing-key.asc $KEY_URL
}

# Function to verify Qubes ISO
verify_qubes() {
    echo "[+] Verifying Qubes ISO..."

    # Import the Qubes signing key into a temporary keyring
    gpg --no-default-keyring --keyring $TEMP_KEYRING --import ./qubes_data/qubes-release-4-signing-key.asc

    # Check if the fingerprint of the imported key matches the expected fingerprint
    if gpg --no-default-keyring --keyring $TEMP_KEYRING --fingerprint $FINGERPRINT | grep -q "$KEY_FINGERPRINT"; then
        echo "The imported Qubes developer key is valid."
    else
        echo "ERROR! The imported key does not seem to be the correct one. Something is wrong!"
        exit 1
    fi

    # Set the key as ultimately trusted in the temporary keyring
    echo -e "trust\n5\nquit" | gpg --no-default-keyring --keyring $TEMP_KEYRING --edit-key $FINGERPRINT > /dev/null

    echo "The key is now set to ultimate trust."

    # Verify the Qubes ISO file using the imported key
    if gpg --no-default-keyring --keyring $TEMP_KEYRING --verify ./qubes_data/Qubes-R${QUBES_VERSION}.iso.asc ./qubes_data/Qubes-R${QUBES_VERSION}.iso > /dev/null 2>&1; then
        echo "The Qubes ISO is legit."
    else
        echo "ERROR! The Qubes ISO does not seem to be signed by the Qubes key. Something is wrong!"
        exit 1
    fi
}

# Function to choose a target disk
choose_disk() {
    echo "What disk would you like to use for the Qubes installer?"
    lsblk
    echo "For example: /dev/sdc"
    read TARGET_DISK
}

# Function to create and write the Qubes installer to the USB drive
create_installer() {
    choose_disk

    echo "Warning: $TARGET_DISK will be erased. Do you wish to continue [y|n]? "
    read ans

    if [[ $ans =~ ^[Yy]([Ee][Ss])?$ ]]; then
        echo "Ok, you wanted it!"
    else
        echo "Bye!"
        exit 1
    fi

    if [ -f "qubes_data/Qubes-R${QUBES_VERSION}.iso" ]; then
        echo "[+] Found Qubes ISO in qubes_data/Qubes-R${QUBES_VERSION}.iso. Using it!"
    else
        download_qubes
        verify_qubes
    fi

    echo "[+] Writing Qubes ISO to $TARGET_DISK. This may take a while..."
    dd if="qubes_data/Qubes-R${QUBES_VERSION}.iso" of="$TARGET_DISK" bs=16M oflag=direct status=progress

    echo "All done"
}

# Main script execution
main() {
    check_dependencies

    if [ ! -f "qubes_data/Qubes-R${QUBES_VERSION}.iso" ]; then
        download_qubes
        verify_qubes
    fi

    create_installer

    echo -e "\n#### Qubes OS installer creation on USB completed successfully. ####\n"
    exit 0
}

main
