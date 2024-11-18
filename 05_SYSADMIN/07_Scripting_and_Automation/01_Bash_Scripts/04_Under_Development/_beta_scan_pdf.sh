#!/usr/bin/env bash

########################################################################
# File Name    : scan_pdf.sh
# Description  : This script performs simple and deep scans on PDF files
#                using PDFid and PDFParser to extract metadata and 
#                analyze objects for security analysis.
# Dependencies : PDFid (pdfid.py), PDFParser (pdf-parser.py)
# Configuration: - Ensure PDFid (pdfid.py) and PDFParser (pdf-parser.py) 
#                  are installed and accessible in your environment.
#                - Customize additional keys, heuristics, and plugins 
#                  for PDFid as per specific security analysis 
#                  requirements.
# Usage        : • Make the script executable with:
#                  chmod +x scan_pdf.sh
#                • Run the script with:
#                  bash scan_pdf.sh
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

# Function to display options and prompt user choice
display_menu() {
    echo "Choose scan type:"
    echo "1. Simple Scan"
    echo "2. Deep Scan"
    echo "0. Exit"
    read -p "Enter your choice: " choice
}

# Function to perform simple scan using PDFid
simple_scan() {
    echo "Performing Simple Scan..."
    pdfid.py "$input_pdf" -h
    pdfid.py "$input_pdf" -a > "$output_dir/simple_scan_results.txt"
    echo "Simple Scan completed. Results saved in: $output_dir/simple_scan_results.txt"
}

# Function to perform deep scan using PDFid and PDFParser
deep_scan() {
    echo "Performing Deep Scan..."
    pdfid.py "$input_pdf" -h
    pdfid.py "$input_pdf" --additional=ADDITIONAL_KEYS --plugin=pdf_id/pdfid/plugin_embeddedfile --plugin=pdf_id/pdfid/plugin_nameobfuscation --plugin=pdf_id/pdfid/plugin_suspicious_properties --plugin=pdf_id/pdfid/plugin_triage > "$output_dir/deep_scan_pdfid_results.txt"

    if grep -q "suspicious elements detected" "$output_dir/deep_scan_pdfid_results.txt"; then
        echo "Suspicious elements detected. Running PDFParser..."
        pdf-parser.py -s "$input_pdf" > "$output_dir/deep_scan_pdfparser_results.txt"
        echo "Deep Scan completed. PDFParser results saved in: $output_dir/deep_scan_pdfparser_results.txt"
    else
        echo "No suspicious elements detected. Skipping PDFParser analysis."
        echo "Deep Scan completed. PDFid results only saved in: $output_dir/deep_scan_pdfid_results.txt"
    fi
}

# Main script logic
while :
do
    display_menu

    case $choice in
        1)
            read -p "Enter the path to the PDF file for Simple Scan: " input_pdf
            output_dir="simple_scan_output"
            mkdir -p "$output_dir"
            simple_scan
            ;;
        2)
            read -p "Enter the path to the PDF file for Deep Scan: " input_pdf
            output_dir="deep_scan_output"
            mkdir -p "$output_dir"
            deep_scan
            ;;
        0)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please enter 1, 2, or 0."
            ;;
    esac

    echo "------------------------------------"
done

