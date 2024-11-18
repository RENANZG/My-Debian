#!/usr/bin/env bash

########################################################################
# File Name   : text_remover_delimiter.sh
# Description : Script to remove text between delimiter in batch
# Usage       : • Make the script executable with:
#                 chmod +x text_remover_delimiter.sh
#               • Run the script with arguments: 
#                 bash text_remover_delimiter.sh 'start_delimiter' 
#                 'end_delimiter' file1.txt file2.sh file3.md 
#                 OR
#                 bash text_remover_delimiter.sh 'start_delimiter' 
#                 'end_delimiter' /path/to/directory
# Author      : Me and the bois
# License     : Free of charge, no warranty
########################################################################

# Check if at least two arguments are provided
if [ $# -lt 3 ]; then
    echo "Usage: $0 'start_delimiter' 'end_delimiter' file1.txt file2.sh file3.md ..."
    echo "       $0 'start_delimiter' 'end_delimiter' /path/to/directory"
    exit 1
fi

# Extract the delimiters
start_delimiter=$1
end_delimiter=$2
shift 2

# Function to process a single file
process_file() {
    local file="$1"
    local start_delimiter="$2"
    local end_delimiter="$3"

    # Check if the file exists
    if [ ! -f "$file" ]; then
        echo "Error: File '$file' not found!"
        return 1
    fi

    # Check if the start delimiter exists in the file
    if ! grep -qF "$start_delimiter" "$file"; then
        echo "Error: Start delimiter '$start_delimiter' not found in file '$file'!"
        return 1
    fi

    # Check if the end delimiter exists in the file
    if ! grep -qF "$end_delimiter" "$file"; then
        echo "Error: End delimiter '$end_delimiter' not found in file '$file'!"
        return 1
    fi

    # Remove text between delimiters from the file
    sed -i "/$start_delimiter/,/$end_delimiter/d" "$file"

    echo "Text between '$start_delimiter' and '$end_delimiter' removed successfully from '$file'."
}

# Export the function and variables so they're available in subshells
export -f process_file
export start_delimiter
export end_delimiter

# Function to process files within a directory recursively
process_directory() {
    local dir="$1"

    # Find all files in the directory (including hidden files) and process each
    find "$dir" -type f -exec bash -c 'process_file "$0" "$start_delimiter" "$end_delimiter"' {} \;
}

# Iterate over all arguments
for arg in "$@"; do
    # Check if the argument is a directory
    if [ -d "$arg" ]; then
        process_directory "$arg"
    else
        # If it's not a directory, treat it as a single file
        process_file "$arg" "$start_delimiter" "$end_delimiter"
    fi
done
