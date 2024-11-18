#!/bin/bash

#######################################################################
# File Name    : secure_delete_ssd_file.sh
# Description  : This script securely deletes files from SSD storage
#                using an encrypted container with VeraCrypt and
#                ensures that data is unrecoverable.
# Dependencies : veracrypt; openssl; secure-delete (srm)
# Usage        : • Make the script executable with:
#                chmod +x secure_delete_ssd_file.sh
#                • Run the script with:
#                bash secure_delete_ssd_file.sh
# Author       : Me and the bois
# License      : Free of charge, no warranty
#######################################################################

# User-configurable variables
file_to_delete="/path/to/your/file.txt"
container_size="100M"
container_path="/path/to/container.vc"
mount_point="/path/to/mounted/container/"

# Generate a strong random password
password=$(openssl rand -base64 20)

# Create an encrypted container using the generated password
veracrypt --text --create "$container_path" \
          --size "$container_size" \
          --encryption AES \
          --filesystem ext4 \
          --password "$password" \
          --pim 0 \
          --quick

# Mount the container
veracrypt --text --mount "$container_path" --password "$password"

# Copy a file to the mounted container
cp "$file_to_delete" "$mount_point"

# Securely delete the original file
srm "$file_to_delete"

# Unmount the container
veracrypt --text --dismount "$container_path"

# Delete the encrypted container
rm "$container_path"

# Run TRIM on the SSD
fstrim "$mount_point"
