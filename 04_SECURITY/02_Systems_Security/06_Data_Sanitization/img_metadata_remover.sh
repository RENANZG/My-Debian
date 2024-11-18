#!/usr/bin/env bash

########################################################################
# File Name    : img_metadata_remover.sh
# Description  : This script removes metadata from image files using
#                exiftool. It works on a single file or processes all
#                image files in a specified directory.
# Disclaimer   : Removing metadata can potentially damage image files.
#                Ensure you have backups before running the script, the
#                script will ask for a backup. About secure delete, if
#                you have sensitive data, consider additional measures  #                to ensure the destruction of the image data. For SSDs,
#                shred may not be as effective due to wear leveling and
#                the TRIM command. SSDs manage data differently,
#                potentially leaving some blocks untouched by overwrite
#                operations.
# Dependencies : exiftool, shred
# Support      : jpg, jpeg, png, tiff, webp, avif, gif
# Usage        : • Make the script executable with
#                 chmod +x img_metadata_remover.sh
#                • Run the script with to remove metadata:
#                 bash img_metadata_remover.sh <file-or-directory>
#                • To securely wipe backups, use shred argument after:
#                 bash img_metadata_remover.sh shred <file-or-
#                 directory>
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

# Function to ask user if they want to create backups
ask_backup() {
    read -p "Do you want to create backups before removing metadata? (y/n): " create_backup
    if [[ "$create_backup" == "y" || "$create_backup" == "Y" ]]; then
        backup=true
    else
        backup=false
    fi
}

# Function to securely wipe a file using shred
securely_wipe_file() {
    local file="$1"
    if [[ -z "$file" ]]; then
        echo "Error: Path to file not provided."
        exit 1
    fi

    echo "Securely wiping $file with random data..."
    shred --verbose --random-source=/dev/urandom -n1 --zero "$file"
    echo "Secure wipe complete for: $file"
}

# Function to remove metadata from a single image file
remove_metadata() {
    input_file="$1"
    backup_file="${input_file}.bak"

    # Create a backup of the original file if required
    if [ "$backup" = true ]; then
        cp "$input_file" "$backup_file"
        echo "Backup created for: $input_file"

        # Securely wipe the backup file after creating it
        securely_wipe_file "$backup_file"
    fi

    # Remove all metadata using exiftool and overwrite the original file
    exiftool -all= "$input_file" -overwrite_original
    echo "Metadata removed for: $input_file"

    # Verify metadata removal
    remaining_metadata=$(exiftool "$input_file" | wc -l)
    if [ "$remaining_metadata" -eq 0 ]; then
        echo "Verification passed: No metadata remaining in $input_file"
    else
        echo "Verification failed: Metadata still present in $input_file"
    fi
}

# Check if the script was invoked with 'shred' command
if [ "$1" == "shred" ]; then
    shift  # Remove the 'shred' argument from the list of positional parameters
    # Check if the script received a file or a directory
    if [ -f "$1" ]; then
        # Single file mode
        securely_wipe_file "$1"
    elif [ -d "$1" ]; then
        # Directory mode
        for file in "$1"/*.{jpg,jpeg,png,tiff,webp,avif,gif}; do
            if [ -f "$file" ]; then
                securely_wipe_file "$file"
            fi
        done
    else
        echo "Usage: $0 shred <file-or-directory>"
        exit 1
    fi
    exit 0  # Exit after securely wiping files, if 'shred' command is used
fi

# Ask if user wants to create backups
ask_backup

# Check if the script received a file or a directory
if [ -f "$1" ]; then
    # Single file mode
    remove_metadata "$1"
elif [ -d "$1" ]; then
    # Directory mode
    for file in "$1"/*.{jpg,jpeg,png,tiff,webp,avif,gif}; do
        if [ -f "$file" ]; then
            remove_metadata "$file"
        fi
    done
else
    echo "Usage: $0 <file-or-directory>"
    exit 1
fi

