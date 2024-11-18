#!/bin/bash

### Method 1: Use realpath to get the directory where the script is located

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

### Alternative Method 2: Use $BASH_SOURCE to get the directory where the script is located

# SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"

### Alternative Method 3: Use $0 with a fallback to current directory

# SCRIPT_DIR="$(dirname "$0")"

# If this method is used, make sure to run the script using an absolute path or from its own directory to ensure correct behavior.

# Output file where metadata will be stored
OUTPUT_FILE="$SCRIPT_DIR/metadata.txt"

# Check if at least one argument is provided
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 file_or_directory [file_or_directory...]"
    exit 1
fi

# Empty the output file if it exists
> "$OUTPUT_FILE"

# Function to process a single PDF file
process_pdf() {
    local file="$1"
    if [ -f "$file" ]; then
        # Extract the file name without path
        local file_name="$(basename "$file")"
        
        echo "File: $file_name" >> "$OUTPUT_FILE"
        if pdfinfo "$file" >> "$OUTPUT_FILE" 2>/dev/null; then
            echo "" >> "$OUTPUT_FILE"  # Add a blank line after each file's metadata
        else
            echo "Error: Failed to process $file" >> "$OUTPUT_FILE"
            echo "" >> "$OUTPUT_FILE"  # Add a blank line after error message
        fi
    else
        echo "Warning: $file is not a valid file" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"  # Add a blank line after warning
    fi
}

# Function to process all PDF files in a directory
process_directory() {
    local dir="$1"
    if [ -d "$dir" ]; then
        find "$dir" -type f -name "*.pdf" | while read -r file; do
            process_pdf "$file"
        done
    else
        echo "Warning: $dir is not a valid directory" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"  # Add a blank line after warning
    fi
}

# Main processing loop
for input in "$@"; do
    if [ -d "$input" ]; then
        process_directory "$input"
    elif [ -f "$input" ]; then
        process_pdf "$input"
    else
        echo "Warning: $input is not a valid file or directory" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"  # Add a blank line after warning
    fi
done

echo "Metadata extraction completed. Check $OUTPUT_FILE for results."
