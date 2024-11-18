#!/usr/bin/env bash

########################################################################
# File Name    : rename_epub_metatag.sh
# Description  : Batch rename ePub files based on title and creator 
#                metadata tags, with filename truncation
# Dependencies : exiftool
# Usage        : • Make the script executable with 
#                chmod +x rename_epub_metatag.sh
#                • Run the script with path or a single file:
#                bash rename_epub_metatag.sh <path_or_file>
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

# Exit immediately if a command exits with a non-zero status or if an unset variable is used
set -euo pipefail

# Maximum length for filenames (adjust as needed)
MAX_FILENAME_LENGTH=100

# Check if at least one argument is provided
if [ $# -lt 1 ]; then
    echo "Usage: bash rename_epub_metatag.sh <path_or_file> [additional_files...]"
    exit 1
fi

# Function to sanitize metadata to be used in filenames
sanitize_metadata() {
    local metadata="$1"
    echo "$metadata" | sed 's/[ /:*?"<>|]/_/g'
}

# Function to truncate a string to a maximum length
truncate_string() {
    local string="$1"
    local max_length="$2"
    if [ ${#string} -gt "$max_length" ]; then
        echo "${string:0:max_length}"
    else
        echo "$string"
    fi
}

# Function to rename a single ePub file
rename_single_epub() {
    local file="$1"
    local title creator title_sanitized creator_sanitized new_filename original_filename

    if [ ! -f "$file" ]; then
        echo "Error: '$file' not found."
        return 1
    fi

    title=$(exiftool -s -s -s -Title "$file")
    creator=$(exiftool -s -s -s -Creator "$file")

    # Use the original filename if metadata is missing
    original_filename=$(basename "$file" .epub)

    title_sanitized=$(sanitize_metadata "$title")
    creator_sanitized=$(sanitize_metadata "$creator")

    # Combine sanitized title and creator with "_-_"
    if [ -n "$title_sanitized" ] && [ -n "$creator_sanitized" ]; then
        new_filename="${title_sanitized}_-_${creator_sanitized}.epub"
    elif [ -n "$title_sanitized" ]; then
        new_filename="${title_sanitized}.epub"
    elif [ -n "$creator_sanitized" ]; then
        new_filename="${creator_sanitized}.epub"
    else
        new_filename="${original_filename}.epub"
    fi

    # Truncate filename if it exceeds maximum length
    new_filename=$(truncate_string "$new_filename" "$MAX_FILENAME_LENGTH")

    echo "Renaming '$file' to '$new_filename'"
    mv -n "$file" "$(dirname "$file")/$new_filename"
}

# Function to rename ePub files in a directory
rename_files_in_directory() {
    local dir="$1"
    find "$dir" -type f -name "*.epub" -print0 | while IFS= read -r -d '' file; do
        rename_single_epub "$file"
    done
}

# Loop through all arguments provided
for arg in "$@"; do
    if [ -d "$arg" ]; then
        rename_files_in_directory "$arg"
    elif [ -f "$arg" ]; then
        if [[ "$arg" == *.epub ]]; then
            rename_single_epub "$arg"
        else
            echo "Error: '$arg' is not an ePub file."
            exit 1
        fi
    else
        echo "Error: '$arg' is neither a directory nor a file."
        exit 1
    fi
done
