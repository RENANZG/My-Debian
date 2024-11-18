#!/usr/bin/env bash

########################################################################
# File Name   : file_duplicate_locator_two.sh
# Description : Script to locate duplicate files between two directories
#               based on size and hash.
# Usage       : • Make the script executable with:
#                 chmod +x file_duplicate_locator_two.sh
#               • Run the script with two directory arguments:
#                 bash file_duplicate_locator_two.sh <dir1> <dir2>
# Author      : Me and the bois
# License     : Free of charge, no warranty
########################################################################

# Check if two directories are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <dir1> <dir2>"
    exit 1
fi

dir1="$1"
dir2="$2"

echo "Finding and identifying duplicate files between $dir1 and $dir2..."

# Combine files from both directories and process
find "$dir1" "$dir2" -not -empty -type f -printf "%s\n" | sort -rn | uniq -d |
while read -r size; do
    echo "Duplicates for files of size ${size} bytes:"
    # Find files of the same size in both directories
    find "$dir1" "$dir2" -type f -size "${size}c" -print0 |
    # Calculate MD5 hash and sort based on hash
    xargs -0 md5sum |
    sort |
    # Identify files with duplicate hashes
    uniq -w32 --all-repeated=separate |
    # Print hash, file size, and file paths
    awk '{print "Hash: "$1", Size: '$size' bytes, File: "$2}'
done

echo "Done."
