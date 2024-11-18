#!/usr/bin/env bash

########################################################################
# File Name   : text_insertor_permanent.sh
# Description : Script to insert specific text in batch with an option
#               to specify the line number.
# Usage       : • Make the script executable with:
#                 chmod +x text_insertor_permanent.sh
#               • Run the script with:
#                 bash text_insertor_permanent.sh <line_number> 
#                 /full/path/to/file1.txt /full/path/to/file2.sh ...
#                 OR
#                 bash text_insertor_permanent.sh <line_number>
#                 /full/path/to/directory
# Author      : Me and the bois
# License     : Free of charge, no warranty
########################################################################

# Check if at least two arguments are provided (line_number and at least one file or directory)
if [ $# -lt 2 ]; then
    echo "Usage: $0 <line_number> /full/path/to/file1.txt /full/path/to/file2.sh ..."
    echo "       $0 <line_number> /full/path/to/directory"
    read -p "Press enter to continue"
    exit 1
fi

# Function to insert text into a single file
insert_into_file() {
    local file="$1"

    # Check if the file exists
    if [ ! -f "$file" ]; then
        echo "Error: File '$file' not found!"
        return 1
    fi
    
     # Get the filename without the path
    filename=$(basename "$file")

    # Text to be inserted
    text_to_insert=$(cat <<EOF
########################################################################
# VISIT: 
# SCRIPT CREDITS: https://portable-linux-apps.github.io
# 
# USAGE:
#  Make it executable:
#   \$ sudo chmod +x ~/Downloads/$filename
#  Then run
#   \$ sudo bash ~/Downloads/$filename
########################################################################
\n
EOF
    )

    # Temporary file to hold modified content
    tmp_file=$(mktemp)

    # Insert text after the specified line number
    awk -v line_number="$line_number" -v text="$text_to_insert" '
        { print }
        NR == line_number + 1 { printf "%s\n", text }
    ' "$file" > "$tmp_file"

    # Replace the original file with the modified one
    mv "$tmp_file" "$file"

    echo "Text inserted successfully in $file after line $line_number."
}

# Extract the line number and remove it from the arguments
line_number=$1
shift 1

# Function to handle processing a directory
process_directory() {
    local dir="$1"

    # Iterate over all files within the directory
    find "$dir" -type f -print0 | while IFS= read -r -d '' file; do
        insert_into_file "$file"
    done
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
