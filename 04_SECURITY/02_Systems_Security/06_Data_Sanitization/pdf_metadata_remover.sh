#!/usr/bin/env bash

########################################################################
# File Name    : pdf_metadata_remover.sh
# Description  : This script removes metadata from PDF files using
#                exiftool and qpdf. It works on a single file or
#                processes all PDF files in a specified directory.
# Dependencies : exiftool, qpdf
# Usage        : • Make the script executable with
#                  chmod +x pdf_metadata_remover.sh
#                • Run the script with arguments:
#                  bash pdf_metadata_remover.sh <file-or-directory>
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

# Function to remove metadata from a single file
remove_metadata() {
    input_file="$1"
    temp_file="temp_$input_file"

    # Remove all metadata using exiftool and overwrite the original file
    exiftool -all:all= "$input_file" -overwrite_original

    # Linearize the PDF using qpdf
    qpdf --linearize "$input_file" "$temp_file"
    mv "$temp_file" "$input_file"

    echo "Metadata removed and file linearized for: $input_file"
}

# Check if the script received a file or a directory
if [ -f "$1" ]; then
    # Single file mode
    remove_metadata "$1"
elif [ -d "$1" ]; then
    # Directory mode
    for file in "$1"/*.pdf; then
        if [ -f "$file" ]; then
            remove_metadata "$file"
        fi
    done
else
    echo "Usage: $0 <file-or-directory>"
    exit 1
fi
