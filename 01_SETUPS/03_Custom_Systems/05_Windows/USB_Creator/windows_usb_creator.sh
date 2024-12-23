#!/bin/bash

#######################################################################
# File Name    : windows_usb_creator.sh
# Description  : This script prepares a USB drive to be used as a
#                 bootable Windows installer. It formats the USB drive, #                 sets up the necessary partitions (including a FAT16
#                 partition for booting and an NTFS partition for the
#                 Windows files), and transfers the Windows
#                 installation  files to the NTFS partition. Using a
#                 Linux environment, this script allows you to choose a #                 Windows ISO and write it by setting the variable
#                 path.
# Dependencies : wget; parted; mkfs.ntfs; dd; rsync; mount (util-linux)
# Usage        : • Make the script executable with:
#                   sudo chmod +x windows_usb_creator.sh
#                 • Run the script with:
#                   sudo bash windows_usb_creator.sh
# Author       : Me and the bois
# License      : Free of charge, no warranty.
# Reference    : https://github.com/brunowollinger/windows-usb
########################################################################

# Variables
ISO_PATH="/path/to/your/windows.iso"  # Replace with the actual path
IMG_URL="https://raw.githubusercontent.com/pbatard/rufus/master/res/uefi/uefi-ntfs.img"
IMG_PATH="$HOME/Downloads/uefi-ntfs.img"
ISO_MOUNT_POINT="/mnt/iso"
NTFS_MOUNT_POINT="/mnt/ntfs"
TARGET_DISK=""

# Function to choose a target disk for the operation
choose_target_disk() {
  echo "What disk would you like to use for the USB preparation?"
  lsblk
  echo "Please enter the device name (e.g., /dev/sdc):"
  read -r TARGET_DISK

  # Validate if the chosen disk exists
  if ! lsblk | grep -q "$TARGET_DISK"; then
    echo "Error: Disk $TARGET_DISK not found!"
    exit 1
  fi
}

# Choose the target disk
choose_target_disk

# Overwrite the partition table
echo "Overwriting the partition table on $TARGET_DISK..."
parted "$TARGET_DISK" mklabel gpt

# Create a FAT16 partition of 1MB
echo "Creating FAT16 partition on $TARGET_DISK..."
parted "$TARGET_DISK" mkpart primary fat16 1MiB 2MiB

# Set the bootable flag
echo "Setting the bootable flag on the FAT16 partition..."
parted "$TARGET_DISK" set 1 boot on

# Create an NTFS partition with the remaining space
echo "Creating NTFS partition on $TARGET_DISK..."
parted "$TARGET_DISK" mkpart primary ntfs 2MiB 100%

# Set the Microsoft Basic Data flag to the partition
echo "Setting the msftdata flag on the NTFS partition..."
parted "$TARGET_DISK" set 2 msftdata on

# Format the NTFS partition
echo "Formatting the NTFS partition..."
mkfs.ntfs -f "${TARGET_DISK}2"

# Download the .img that contains the custom binaries
echo "Downloading the uefi-ntfs.img..."
wget "$IMG_URL" -O "$IMG_PATH"

# Write the image to the FAT16 partition
echo "Writing the image to the FAT16 partition..."
dd if="$IMG_PATH" of="${TARGET_DISK}1" status=progress

# Mount the Windows ISO
echo "Mounting the Windows ISO..."
mkdir -p "$ISO_MOUNT_POINT"
mount "$ISO_PATH" "$ISO_MOUNT_POINT"

# Mount the NTFS partition
echo "Mounting the NTFS partition..."
mkdir -p "$NTFS_MOUNT_POINT"
mount "${TARGET_DISK}2" "$NTFS_MOUNT_POINT"

# Transfer the ISO contents to the NTFS partition
echo "Transferring the ISO contents to the NTFS partition..."
rsync -av "$ISO_MOUNT_POINT/" "$NTFS_MOUNT_POINT"

# Unmount partitions
echo "Unmounting the partitions..."
umount "$ISO_MOUNT_POINT"
umount "$NTFS_MOUNT_POINT"

echo "USB drive preparation is complete."
