#!/bin/bash
set -e # exit on errors

# Variables
DISK="/dev/sda"
PARTITION="${DISK}1"
MAPPER_NAME="usbluks"
VG_NAME="usbluks_vg"
LV_NAME="usbluks_logvol"
LV_SIZE="118G"
MOUNT_POINT="/mnt"

# Partition the disk
sudo fdisk "$DISK"
sudo partprobe "$DISK"

# Encrypt the partition
sudo cryptsetup luksFormat "$PARTITION"
sudo cryptsetup luksOpen "$PARTITION" "$MAPPER_NAME"

# Create a logical volume
sudo vgcreate "$VG_NAME" "/dev/mapper/$MAPPER_NAME"
sudo lvcreate -n "$LV_NAME" -L "$LV_SIZE+" "$VG_NAME"

# Format the disk with btrfs
sudo mkfs.btrfs --mixed --data SINGLE --metadata SINGLE "/dev/$VG_NAME/$LV_NAME"

# Mount our new volume
sudo mount "/dev/$VG_NAME/$LV_NAME" "$MOUNT_POINT"

# Backup my files
sudo tar --create --directory /home --file - | tar --directory "$MOUNT_POINT" --extract --file -
