#!/bin/bash

# Variables
MOUNT_POINT="/mnt/my_volume"  # Mount point directory

# Verify sudo access
if ! sudo -v; then
    echo "You need sudo privileges to run this script."
    exit 1
fi

# Unmount when done
sudo umount "$MOUNT_POINT"
