#!/bin/bash

# Variables
MOUNT_POINT="/mnt/my_volume"  # Mount point directory
LOGICAL_VOLUME="/dev/xvdi"    # Logical volume device
USER="user"                    # User and group for ownership

# Verify sudo access
if ! sudo -v; then
    echo "You need sudo privileges to run this script."
    exit 1
fi

# Create a Mount Point
sudo mkdir -p "$MOUNT_POINT"

# Adjust Permissions (if needed)
sudo chmod 755 "$MOUNT_POINT"

# Change Ownership
sudo chown "$USER:$USER" "$MOUNT_POINT"

# Mount the Logical Volume
sudo mount "$LOGICAL_VOLUME" "$MOUNT_POINT"

# Access the Mounted Volume
echo "You can now access the contents of the logical volume at $MOUNT_POINT."
