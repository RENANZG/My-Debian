#!/usr/bin/env bash

########################################################################
# File Name   : file_secure_gpg_encrypt.sh
# Description : This script encrypts files in a directory using GPG 
#               with passphrase protection. It securely handles the 
#               passphrase by temporarily storing it in a file with 
#               restricted permissions and cleaning up the file after 
#               use. The script ensures data security by avoiding 
#               exposure in shell history or memory. It also provides 
#               functionality to securely wipe the original files after 
#               encryption using 'shred' if requested by the user.
# Dependencies: gpg, shred
# Disclaimer  : Use a strong passphrase. If you handle sensitive data, 
#               consider additional measures for data destruction. Note 
#               that 'shred' on SSDs may not be as effective due to wear 
#               leveling and TRIM commands.
# Usage       : • Make the script executable with 
#                 chmod +x file_secure_gpg_encrypt.sh
#               • Encrypt files or directories:
#                 bash /file_secure_gpg_encrypt.sh /input/directory 
#                 /output/file.gpg
#               • Securely wipe a file with shred argument:
#                 bash /file_secure_gpg_encrypt.sh shred 
#                 <path_or_file>
# Author      : Me and the bois
# License     : Free of charge, no warranty
# References  : https://gnupg.org
#               https://www.gnu.org/software/coreutils
########################################################################

# Function to display usage information
usage() {
    echo "Usage:"
    echo "  To encrypt: sudo bash /file_secure_gpg_encrypt.sh <file_or_directory>"
    echo "  To shred after encrypting: sudo bash /file_secure_gpg_encrypt.sh shred <file_or_directory>"
    read -p "Press enter to continue"
    exit 1
}

# Ensure root privileges
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root (sudo)."
    exit 1
fi

# Check number of arguments
if [ $# -lt 1 ] || [ $# -gt 2 ]; then
    usage
fi

# Determine the operation mode (with or without shred)
if [ "$1" == "shred" ]; then
    mode="shred"
    target="$2"
else
    mode="encrypt_only"
    target="$1"
fi

# Validate target file or directory
if [ ! -e "$target" ]; then
    echo "Target '$target' does not exist."
    exit 1
fi

# Generate output archive path
output_archive="${target}.gpg"

# Encrypt function
encrypt() {
    local input="$1"
    local output="$2"
    
    # Prompt for passphrase securely
    read -sp "Enter passphrase: " passphrase
    echo
    
    # Create a temporary file for the passphrase
    pw_file=$(mktemp)
    chmod 600 "$pw_file"
    echo -n "$passphrase" > "$pw_file"
    
    # Encrypt files using GPG and the passphrase file
    gpg --batch --yes --passphrase-file "$pw_file" --symmetric --cipher-algo AES256 -o "$output" "$input"
    
    # Check if the encryption was successful
    if [ $? -ne 0 ]; then
        echo "Encryption failed."
        rm -f "$pw_file"
        exit 1
    fi
    
    # Clean up the temporary passphrase file
    rm -f "$pw_file"
    
    echo "Encryption complete."
}

# Main logic
case "$mode" in
    encrypt_only)
        encrypt "$target" "$output_archive"
        ;;
    shred)
        # Prompt user to confirm before shredding
        read -p "Are you sure you want to shred '$target'? (y/n): " confirm
        if [ "$confirm" == "y" ]; then
            encrypt "$target" "$output_archive"
            shred --verbose --random-source=/dev/urandom -n1 --zero -u "$target"
            if [ $? -eq 0 ]; then
                echo "Secure wipe complete."
            else
                echo "Secure wipe failed."
            fi
        else
            echo "Operation canceled."
        fi
        ;;
    *)
        usage
        ;;
esac

echo "Operation completed."
