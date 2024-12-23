#!/usr/bin/env bash

########################################################################
# File Name    : kicksecure_whonix_live.sh
# Description  : Script to download, verify, modify Kicksecure Live XFCE
#                ISO, install Whonix and write it to a USB stick.
# Dependencies : curl gpg unsquashfs mksquashfs xorriso dosfstools
#                qemu-utils
# Usage        : • Make the script executable with:
#                sudo chmod +x kicksecure_whonix_live.sh
#                • Run the script with:
#                sudo bash kicksecure_whonix_live.sh
# Author       : Me and the bois
# License      : Free of charge, no warranty
# Last edited  : 2024-12-23
# Inspired by  : https://forums.whonix.org/t/whonix-host-developers-only-preview-version-15-0-1-2-7-released/9360
#                https://forums.whonix.org/t/whonix-host-operating-system-os-iso/3931/343
########################################################################

# Variables
KICKSECURE_DATA_DIR="kicksecure_data"
KICKSECURE_BASE_URL="https://www.kicksecure.com/download/iso"
KICKSECURE_KEY_URL="https://www.kicksecure.com/keys/derivative.asc"
WHONIX_INSTALLER_URL="https://www.whonix.org/dist-installer-cli"
WHONIX_INSTALLER_SIG_URL="https://www.whonix.org/dist-installer-cli.sig"
WHONIX_INSTALLER_KEY_URL="https://www.whonix.org/whonix.asc"
WHONIX_INSTALLER="whonix-xfce-installer-cli"

# Ensure the script is run with root only when needed
ensure_root() {
  if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (use sudo) for disk writing operations."
    exit 1
  fi
}

# Function to clean up the old kicksecure_data directory if it exists
clean_up() {
  if [ -d "$KICKSECURE_DATA_DIR" ]; then
    find "$KICKSECURE_DATA_DIR" -mindepth 1 -delete
    echo -e "\nCleaned up the old $KICKSECURE_DATA_DIR/ directory!\n"
  else
    echo -e "\n$KICKSECURE_DATA_DIR/ directory does not exist.\n"
  fi
}

# Function to check dependencies
check_dependencies() {
    local dependencies=("curl" "gpg" "unsquashfs" "mksquashfs" "xorriso" "dosfstools" "qemu-utils")

    echo "[+] Checking for required dependencies..."

    for cmd in "${dependencies[@]}"; do
        if ! command -v "$cmd" &>/dev/null; then
            echo "Error: $cmd is not installed."
            echo "Please install the required dependency before proceeding."
            exit 1
        else
            echo "[+] $cmd is installed."
        fi
    done
}

# Function to ensure KICKSECURE_DATA_DIR exists
ensure_data_dir() {
  if [ ! -d "$KICKSECURE_DATA_DIR" ]; then
    echo "[+] Creating $KICKSECURE_DATA_DIR directory..."
    mkdir -p "$KICKSECURE_DATA_DIR"
  fi
}

# Function to download the latest Kicksecure Live ISO
download_kicksecure_iso() {
  # Get the latest version dynamically using regex
  echo -e "\n[+] Fetching the latest Kicksecure version..."

  # Use curl to fetch the HTML page and extract the latest ISO version using regex
  KICKSECURE_LATEST_VERSION=$(curl -s "$KICKSECURE_BASE_URL" | \
    grep -oP 'Kicksecure-Xfce-\K[\d\.]+(?=\.Intel_AMD64\.iso)' | head -n 1)

  if [ -z "$KICKSECURE_LATEST_VERSION" ]; then
    echo "Error: Could not fetch the latest Kicksecure version!"
    exit 1
  fi

  echo -e "\n[+] Latest Kicksecure version found: $KICKSECURE_LATEST_VERSION"

  # Define the full URL for the ISO and its signature
  ISO_URL="$KICKSECURE_BASE_URL/Kicksecure-Xfce-$KICKSECURE_LATEST_VERSION.Intel_AMD64.iso"
  SIG_URL="$KICKSECURE_BASE_URL/Kicksecure-Xfce-$KICKSECURE_LATEST_VERSION.Intel_AMD64.iso.asc"

  # Download the Kicksecure ISO
  echo -e "\n[+] Downloading Kicksecure Live XFCE ISO..."
  curl --retry 5 --retry-delay 10 --max-time 3600 -L -C - -o "$KICKSECURE_DATA_DIR/Kicksecure-Xfce-$KICKSECURE_LATEST_VERSION.Intel_AMD64.iso" "$ISO_URL"
}

# Function to verify the Kicksecure ISO image
verify_iso() {
  echo -e "\n[+] Checking the integrity and authenticity of the Kicksecure ISO image..."

  # Download the signing key
  curl --retry 5 --retry-delay 10 --max-time 3600 -L -C - -o "$KICKSECURE_DATA_DIR/derivative.asc" "$KICKSECURE_KEY_URL"

  # Download the signature
  curl --retry 5 --retry-delay 10 --max-time 3600 -L -C - -o "$KICKSECURE_DATA_DIR/Kicksecure-Xfce-$KICKSECURE_LATEST_VERSION.Intel_AMD64.iso.asc" "$SIG_URL"

  # Import and verify the Kicksecure developer key
  gpg --no-default-keyring --keyring "$KICKSECURE_DATA_DIR/tmp_keyring.pgp" --import "$KICKSECURE_DATA_DIR/derivative.asc"

  # Verify that the key was imported correctly
  if gpg --no-default-keyring --keyring "$KICKSECURE_DATA_DIR/tmp_keyring.pgp" --fingerprint | grep -q "A490 D0F4 D311 A415 3E2B B7CA DBB8 02B2 58AC D84F"; then
    echo -e "\n[+] The imported Kicksecure developer key is valid.\n"
  else
    echo -e "\nERROR! The imported key does not seem to be the right one. Something is fishy!"
    exit 1
  fi

  # Set trust for the key manually
  echo -e "5\ny\n" | gpg --no-default-keyring --keyring "$KICKSECURE_DATA_DIR/tmp_keyring.pgp" --command-fd 0 --edit-key "58ACD84F" trust

  # Verify the image signature
  if gpg --no-default-keyring --keyring "$KICKSECURE_DATA_DIR/tmp_keyring.pgp" --verify \
    "$KICKSECURE_DATA_DIR/Kicksecure-Xfce-$KICKSECURE_LATEST_VERSION.Intel_AMD64.iso.asc" \
    "$KICKSECURE_DATA_DIR/Kicksecure-Xfce-$KICKSECURE_LATEST_VERSION.Intel_AMD64.iso" > /dev/null 2>&1; then
    echo -e "\n[+] The ISO seems legit."
  else
    echo -e "\nERROR! The ISO does not seem to be signed by the Kicksecure key. Something is fishy!"
    exit 1
  fi
}

# Function to install Whonix through chroot
install_whonix() {
  echo -e "\n[+] Installing Whonix through chroot..."

  # Download the Whonix installer and verify its signature
  curl --tlsv1.3 --output "$KICKSECURE_DATA_DIR/$WHONIX_INSTALLER" --url "$WHONIX_INSTALLER_URL"
  curl --tlsv1.3 --output "$KICKSECURE_DATA_DIR/$WHONIX_INSTALLER.sig" --url "$WHONIX_INSTALLER_SIG_URL"
  curl --tlsv1.3 --output "$KICKSECURE_DATA_DIR/whonix.asc" --url "$WHONIX_INSTALLER_KEY_URL"

  # Verify the Whonix installer signature
  gpg --import "$KICKSECURE_DATA_DIR/whonix.asc"
  gpg --verify "$KICKSECURE_DATA_DIR/$WHONIX_INSTALLER.sig" "$KICKSECURE_DATA_DIR/$WHONIX_INSTALLER"

  # Mount the Kicksecure Live ISO
  MOUNT_DIR=$(mktemp -d)
  sudo mount -o loop "$KICKSECURE_DATA_DIR/Kicksecure-Xfce-$KICKSECURE_LATEST_VERSION.Intel_AMD64.iso" "$MOUNT_DIR"

  # Create a working directory and copy the ISO contents
  WORK_DIR=$(mktemp -d)
  cp -a "$MOUNT_DIR/"* "$WORK_DIR/"

  # Extract the SquashFS filesystem
  EDIT_DIR=$(mktemp -d)
  sudo unsquashfs -d "$EDIT_DIR" "$WORK_DIR/live/filesystem.squashfs"

  # Mount necessary filesystems for chroot
  sudo mount --bind /dev "$EDIT_DIR/dev"
  sudo mount --bind /sys "$EDIT_DIR/sys"
  sudo mount --bind /proc "$EDIT_DIR/proc"
  sudo mount --bind /dev/pts "$EDIT_DIR/dev/pts"

  # Copy the installer into the chroot and run it
  sudo cp "$KICKSECURE_DATA_DIR/$WHONIX_INSTALLER" "$EDIT_DIR/home/user/"
  sudo chroot "$EDIT_DIR" /bin/bash -c "bash /home/user/$WHONIX_INSTALLER"

  # Cleanup chroot environment
  sudo umount "$EDIT_DIR/dev/pts"
  sudo umount "$EDIT_DIR/proc"
  sudo umount "$EDIT_DIR/sys"
  sudo umount "$EDIT_DIR/dev"

  # Repack the SquashFS filesystem with the Whonix installer
  sudo mksquashfs "$EDIT_DIR" "$WORK_DIR/live/filesystem.squashfs.new" -comp xz
  sudo mv "$WORK_DIR/live/filesystem.squashfs.new" "$WORK_DIR/live/filesystem.squashfs"

  # Create the new ISO with Whonix installed
  sudo xorriso -as mkisofs \
    -o "$KICKSECURE_DATA_DIR/modified-Kicksecure-with-Whonix.iso" \
    -isohybrid-mbr "$WORK_DIR/isolinux/isohdpfx.bin" \
    -c isolinux/boot.cat \
    -b isolinux/isolinux.bin \
    -no-emul-boot -boot-load-size 4 -boot-info-table \
    -J -r -V "KICKSECURE_LIVE" \
    -cache-inodes \
    -isohybrid-gpt-basdat \
    "$WORK_DIR"

  # Cleanup temporary directories
  sudo umount "$MOUNT_DIR"
  rm -rf "$MOUNT_DIR" "$WORK_DIR" "$EDIT_DIR"
}

# Function to choose a target disk for the Kicksecure image
choose_target_disk() {
  echo -e "\nWhat disk would you like to use for the Kicksecure Live ISO?"
  lsblk
  echo -e "\nFor example: /dev/sdc"
  read -r TARGET_DISK
}

# Function to write modified ISO to the target disk
write_to_usb() {
  ensure_root

  echo -e "\n[+] Unmounting any existing partitions on $TARGET_DISK..."
  umount "${TARGET_DISK}"* 2>/dev/null || true

  echo -e "\n[+] Writing modified Kicksecure Live ISO to $TARGET_DISK...\n"
  sudo dd if="$KICKSECURE_DATA_DIR/modified-Kicksecure-with-Whonix.iso" of="$TARGET_DISK" bs=16M oflag=direct status=progress
  echo -e "\nAll done!"
}

# Main script execution
main() {
  ensure_root
  check_dependencies
  ensure_data_dir
  clean_up
  download_kicksecure_iso
  verify_iso
  install_whonix
  choose_target_disk
  write_to_usb
}

# Invoke the main function
main
