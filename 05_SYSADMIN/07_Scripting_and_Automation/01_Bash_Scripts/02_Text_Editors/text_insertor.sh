#!/usr/bin/env bash

########################################################################
# File Name   : text_insertor.sh
# Description : Script to insert text in batch after a specified line.
# Usage       : • Make the script executable with:
#                 chmod +x text_insertor.sh
#               • Run the script with arguments:
#                 bash text_insertor.sh <line_number> 'text_to_insert' 
#                 /full/path/to/file1.txt /full/path/to/file2.sh ...
#                 OR
#                 bash text_insertor.sh <line_number> 'text_to_insert' 
#                 /full/path/to/directory
# Author      : Me and the bois
# License     : Free of charge, no warranty
########################################################################

# Check if at least two arguments are provided (line_number and at least one file or directory)
if [ $# -lt 2 ]; then
    echo "Usage: $0 <line_number> 'text_to_insert' /full/path/to/file1.txt /full/path/to/file2.sh ..."
    echo "       $0 <line_number> 'text_to_insert' /full/path/to/directory"
    read -p "Press enter to continue"
    exit 1
fi

# Extract the line number and text to be inserted
line_number=$1
text_to_insert=$2
shift 2

# Function to insert text into a single file
insert_into_file() {
    local file="$1"

    # Check if the file exists
    if [ ! -f "$file" ]; then
        echo "Error: File '$file' not found!"
        return 1
    fi

    # Insert the text into the file after the specified line
    sed -i "${line_number}a\\
$text_to_insert" "$file"

    echo "Text '$text_to_insert' inserted successfully into '$file' after line $line_number."
}

# Function to process a directory recursively
process_directory() {
    local dir="$1"

    # Iterate over all files in the directory
    while IFS= read -r -d '' file; do
        if [ -f "$file" ]; then
            insert_into_file "$file"
        fi
    done < <(find "$dir" -type f -print0)
}

# Iterate over all arguments
for arg in "$@"; do
    # Check if the argument is a directory
    if [ -d "$arg" ]; then
        process_directory "$arg"
    else
        # If it's not a directory, treat it as a single file
        insert_into_file "$arg"
    fi
done
