#!/usr/bin/env bash

########################################################################
# File Name   : text_remover_multibreak.sh
# Description : Script to remove multiple consecutive empty lines 
#               (not including those with spaces or tabs)
# Usage       : • Make the script executable with:
#                 chmod +x text_remover_multibreak.sh
#               • Run the script with arguments, replace `-c 2` with the
#                 number of consecutive empty lines to convert to one:
#                 bash text_remover_multibreak.sh -c 2 <file_or_path>
# Author      : Me and the bois
# License     : Free of charge, no warranty
########################################################################

# Default number of consecutive empty lines to convert to one
DEFAULT_BREAKS=2

# Function to remove multiple consecutive empty lines from a single file
remove_empty_lines() {
    local file="$1"
    local breaks="$2"
    if [ -f "$file" ]; then
        echo "Reducing $breaks or more consecutive empty lines in: $file"
        awk -v n="$breaks" '
            BEGIN {
                count = 0;
            }
            {
                if ($0 ~ /^[[:space:]]*$/) {
                    count++;
                    if (count > n) {
                        next;
                    }
                } else {
                    count = 0;
                }
                print;
            }
        ' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
    else
        echo "File not found: $file"
    fi
}

# Function to process files recursively in a directory
process_directory() {
    local dir="$1"
    local breaks="$2"
    echo "Processing directory: $dir"
    find "$dir" -type f -print0 | while IFS= read -r -d '' file; do
        remove_empty_lines "$file" "$breaks"
    done
}

# Check if argument is a directory or a single file
if [ "$1" == "-c" ]; then
    if [ -z "$2" ]; then
        echo "Option -c requires a number of empty lines to remove."
        exit 1
    fi
    breaks="$2"
    shift 2
else
    breaks="$DEFAULT_BREAKS"
fi

if [ -d "$1" ]; then
    process_directory "$1" "$breaks"
elif [ -f "$1" ]; then
    remove_empty_lines "$1" "$breaks"
else
    echo "Usage: $0 [-c <number>] <file_or_directory>"
    exit 1
fi

echo "Empty lines reduction complete."
