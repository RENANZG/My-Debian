#!/usr/bin/env bash

########################################################################
# File Name   : file_duplicate_locator_one.sh
# Description : Script to locate duplicate files within a single 
#               directory based on size and hash.
# Usage       : • Make the script executable with:
#                 chmod +x file_duplicate_locator_one.sh
#               • Run the script with one directory argument:
#                 bash file_duplicate_locator_one.sh <directory>
# Author      : Me and the bois
# License     : Free of charge, no warranty
########################################################################

# Check if one directory is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

dir="$1"

echo "Finding and identifying duplicate files in $dir..."

# Find all non-empty files in the specified directory, sort them by size, and identify duplicates based on size
find "$dir" -not -empty -type f -printf "%s\n" | sort -rn | uniq -d |
while read -r size; do
    echo "Duplicates for files of size ${size} bytes:"
    # Find files of the same size
    find "$dir" -type f -size "${size}c" -print0 |
    # Calculate MD5 hash and sort based on hash
    xargs -0 md5sum |
    sort |
    # Identify files with duplicate hashes
    uniq -w32 --all-repeated=separate |
    # Print hash, file size, and file paths
    awk '{print "Hash: "$1", Size: '$size' bytes, File: "$2}'
done

echo "Done."
