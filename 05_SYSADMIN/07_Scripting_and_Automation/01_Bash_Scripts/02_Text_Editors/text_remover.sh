#!/usr/bin/env bash

########################################################################
# File Name   : text_remover.sh
# Description : Script to remove text in batch with advanced options.
# Usage       : • Make the script executable with:
#                 chmod +x text_remover.sh
#               • Run the script with arguments: 
#                 bash text_remover.sh [-l <line_number>]
#                 'text_to_remove' file1.txt file2.sh file3.md 
#                 OR
#                 bash text_remover.sh [-l <line_number>]
#                 text_to_remove' /path/to/directory
# Author      : Me and the bois
# License     : Free of charge, no warranty
########################################################################

# Function to print usage instructions
usage() {
    echo "Usage: $0 [-l <line_number>] 'text_to_remove' file1.txt file2.sh file3.md ..."
    echo "       $0 [-l <line_number>] 'text_to_remove' /path/to/directory"
    exit 1
}

# Check if at least two arguments are provided
if [ $# -lt 2 ]; then
    usage
fi

# Default values
line_number=""

# Parse options
while getopts ":l:" opt; do
    case $opt in
        l) line_number="$OPTARG";;
        \?) echo "Invalid option: -$OPTARG" >&2; usage;;
    esac
done
shift $((OPTIND - 1))

# Extract the text to be removed
text_to_remove="$1"
shift 1

# Function to remove text based on occurrence or line number
remove_text() {
    local file="$1"
    local text="$2"
    local line="$3"

    # Check if the file exists
    if [ ! -f "$file" ]; then
        echo "Error: File '$file' not found!"
        return 1
    fi

    # Check if the text exists in the file
    if ! grep -qF "$text" "$file"; then
        echo "Error: Text '$text' not found in file '$file'!"
        return 1
    fi

    # Remove based on line number
    if [ -n "$line" ]; then
        sed -i "${line}d" "$file"
        echo "Line $line removed successfully from '$file'."
    fi
}

# Function to process a single file
process_file() {
    local file="$1"

    # Call remove_text function with specified options
    remove_text "$file" "$text_to_remove" "$line_number"
}

# Function to process files within a directory recursively
process_directory() {
    local dir="$1"

    # Iterate over all files in the directory
    while IFS= read -r -d '' file; do
        process_file "$file"
    done < <(find "$dir" -type f -print0)
}

# Iterate over all arguments
for arg in "$@"; do
    # Check if the argument is a directory
    if [ -d "$arg" ]; then
        process_directory "$arg"
    else
        # If it's not a directory, treat it as a single file
        process_file "$arg"
    fi
done
