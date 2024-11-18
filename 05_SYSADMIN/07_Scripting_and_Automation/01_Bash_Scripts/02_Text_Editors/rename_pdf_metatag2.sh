#!/usr/bin/env bash

#######################################################################
# File Name    : rename_pdf_metatag2.sh
# Description  : Batch rename PDF files based on title, author, and
#                date metadata tags.
# Dependencies : libimage-exiftool-perl
# Usage        : • Make the script executable with
#                chmod +x rename_pdf_metatag2.sh
#                • Run the script with path or a single file:
#                bash rename_pdf_metatag2.sh <path_or_file>
# Author       : Me and the bois
# License      : Free of charge, no warranty
#######################################################################

# Exit immediately if a command exits with a non-zero status or if an unset variable is used
set -euo pipefail

# Check if argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: bash rename_pdf_metatag2.sh /path/to/your/directory_or_file"
    exit 1
fi

# Function to sanitize metadata to be used in filenames
sanitize_metadata() {
    local metadata="$1"
    echo "$metadata" | sed 's/[ /:*?"<>|]/_/g'
}

# Function to rename a single PDF file
rename_single_pdf() {
    local file="$1"
    local title author creation_date title_snake author_snake year new_filename original_filename

    if [ ! -f "$file" ]; then
        echo "Error: '$file' not found."
        return 1
    fi

    title=$(exiftool -s -s -s -Title "$file")
    author=$(exiftool -s -s -s -Author "$file")
    creation_date=$(exiftool -s -s -s -CreateDate "$file" | awk '{print substr($1, 1, 4)}')

    # Use the original filename if metadata is missing
    original_filename=$(basename "$file" .pdf)

    title_snake=$(sanitize_metadata "$title")
    author_snake=$(sanitize_metadata "$author")
    year=$(sanitize_metadata "$creation_date")

    if [ -n "$title_snake" ] && [ -n "$author_snake" ] && [ -n "$year" ]; then
        new_filename="${title_snake}_${author_snake}_(${year}).pdf"
    elif [ -n "$title_snake" ] && [ -n "$author_snake" ]; then
        new_filename="${title_snake}_${author_snake}.pdf"
    elif [ -n "$title_snake" ]; then
        new_filename="${title_snake}.pdf"
    elif [ -n "$author_snake" ]; then
        new_filename="${author_snake}.pdf"
    else
        new_filename="${original_filename}.pdf"
    fi

    echo "Renaming '$file' to '$new_filename'"
    mv -n "$file" "$(dirname "$file")/$new_filename"
}

# Function to rename PDF files in a directory
rename_files_in_directory() {
    local dir="$1"
    find "$dir" -type f -name "*.pdf" -print0 | while IFS= read -r -d '' file; do
        rename_single_pdf "$file"
    done
}

# Loop through all arguments provided
for arg in "$@"; do
    if [ -d "$arg" ]; then
        rename_files_in_directory "$arg"
    elif [ -f "$arg" ]; then
        if [[ "$arg" == *.pdf ]]; then
            rename_single_pdf "$arg"
        else
            echo "Error: '$arg' is not a PDF file."
            exit 1
        fi
    else
        echo "Error: '$arg' is neither a directory nor a file."
        exit 1
    fi
done
