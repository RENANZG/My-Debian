#!/usr/bin/env bash

########################################################################
# File Name    : pdf_sanitizer.sh
# Description  : Sanitizes PDF files by removing potentially harmful
#                content, flattening, and optimizing the PDFs.
# Dependencies : qpdf, pdftk, gs (Ghostscript)
# Usage        : • Make the script executable with:
#                  sudo chmod +x pdf_sanitizer.sh
#                • Run the script with a PDF file or folder as an argument:
#                  ./pdf_sanitizer.sh input.pdf
#                  ./pdf_sanitizer.sh /path/to/pdf/folder
# Author       : Your Name
# License      : Free to use, no warranty
########################################################################

# Check for required commands
for cmd in qpdf pdftk gs; do
    if ! command -v $cmd &> /dev/null; then
        echo "Error: $cmd is not installed."
        exit 1
    fi
done

# Function to sanitize a single PDF file
sanitize_pdf() {
    local input_pdf="$1"
    local output_folder="$2"
    local temp_pdf1="temp_cleaned1.pdf"
    local temp_pdf2="temp_cleaned2.pdf"
    local output_pdf="${output_folder}/sanitized_$(basename "$input_pdf")"

    echo "Sanitizing file: $input_pdf"

    # Step 1: Clean with qpdf
    echo "  - Cleaning with qpdf..."
    qpdf --object-streams=disable --remove-references --optimize-images --decrypt "$input_pdf" "$temp_pdf1"

    # Step 2: Flatten with pdftk
    echo "  - Flattening with pdftk..."
    pdftk "$temp_pdf1" output "$temp_pdf2"

    # Step 3: Recreate with Ghostscript
    echo "  - Recreating with Ghostscript..."
    gs -dSAFER -dBATCH -dNOPAUSE -dNOCACHE -sDEVICE=pdfwrite -sOutputFile="$output_pdf" -f "$temp_pdf2"

    # Clean up temporary files
    rm "$temp_pdf1" "$temp_pdf2"

    echo "Sanitized file saved as: $output_pdf"
}

# Function to sanitize all PDFs in a folder
sanitize_folder() {
    local folder="$1"
    echo "Sanitizing all PDFs in folder: $folder"
    for pdf_file in "$folder"/*.pdf; do
        sanitize_pdf "$pdf_file" "$folder"
    done
}

# Main logic
if [ -z "$1" ]; then
    echo "Usage: $0 input.pdf"
    echo "       $0 /path/to/pdf/folder"
    exit 1
fi

input="$1"

# Check if input is a file or directory
if [ -f "$input" ]; then
    sanitize_pdf "$input" "$(dirname "$input")"
elif [ -d "$input" ]; then
    sanitize_folder "$input"
else
    echo "Error: Input is not a valid file or directory."
    exit 1
fi