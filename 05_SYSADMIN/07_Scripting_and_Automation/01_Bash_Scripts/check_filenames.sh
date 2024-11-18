#!/bin/bash

#######################################################################
# File Name    : check_filenames.sh
# Description  : This script checks file names and paths in a directory
#                and its subdirectories for compatibility with file
#                systems like FAT32, NTFS, and exFAT.
#                It detects invalid characters and long file names or
#                paths that exceed the limits of these file systems.
# Dependencies : find (coreutils)
# Usage        : • Make the script executable with:
#                 chmod +x check_filenames.sh
#                • Run the script with directory:
#                 bash check_filenames.sh /path/to/directory
# Author       : Me and the bois
# License      : Free of charge, no warranty
#######################################################################

# Directory to check (defaults to the current directory)
DIR=${1:-$(pwd)}

# Function to check file names
check_file_name() {
  local file_path="$1"
  local file_name=$(basename "$file_path")

  # Check if the file name contains invalid characters using grep
  echo "$file_name" | grep -q '[\\/:*?"<>|]' && echo "Invalid name: $file_path (contains invalid characters)"

  # Check if the file name exceeds 255 characters
  if [ ${#file_name} -gt 255 ]; then
    echo "Invalid name: $file_path (name exceeds 255 characters)"
  fi

  # Check if the full path exceeds 260 characters
  if [ ${#file_path} -gt 260 ]; then
    echo "Invalid name: $file_path (path exceeds 260 characters)"
  fi
}

# Traverse through directories and subdirectories
find "$DIR" -type f | while read -r file; do
  check_file_name "$file"
done
