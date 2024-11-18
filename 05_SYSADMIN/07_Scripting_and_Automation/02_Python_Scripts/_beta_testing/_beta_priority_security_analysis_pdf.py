#!/usr/bin/env python3

########################################################################
# File Name    : security_analysis_pdf.py
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
#                  chmod +x security_analysis_pdf.py
#                • Run the script with:
#                  python3 security_analysis_pdf.py
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

import os
import subprocess

def display_menu():
    print("Choose scan type:")
    print("1. Simple Scan")
    print("2. Deep Scan")
    print("0. Exit")
    choice = input("Enter your choice: ")
    return choice

def simple_scan(input_pdf, output_dir):
    print("Performing Simple Scan...")
    subprocess.run(['pdfid.py', input_pdf, '-h'])
    with open(f"{output_dir}/simple_scan_results.txt", 'w') as outfile:
        subprocess.run(['pdfid.py', input_pdf, '-a'], stdout=outfile)
    print(f"Simple Scan completed. Results saved in: {output_dir}/simple_scan_results.txt")

def deep_scan(input_pdf, output_dir):
    print("Performing Deep Scan...")
    subprocess.run(['pdfid.py', input_pdf, '-h'])
    with open(f"{output_dir}/deep_scan_pdfid_results.txt", 'w') as outfile:
        subprocess.run([
            'pdfid.py', input_pdf, 
            '--additional=ADDITIONAL_KEYS',
            '--plugin=pdf_id/pdfid/plugin_embeddedfile',
            '--plugin=pdf_id/pdfid/plugin_nameobfuscation',
            '--plugin=pdf_id/pdfid/plugin_suspicious_properties',
            '--plugin=pdf_id/pdfid/plugin_triage'
        ], stdout=outfile)
    
    with open(f"{output_dir}/deep_scan_pdfid_results.txt", 'r') as infile:
        if "suspicious elements detected" in infile.read():
            print("Suspicious elements detected. Running PDFParser...")
            with open(f"{output_dir}/deep_scan_pdfparser_results.txt", 'w') as parser_outfile:
                subprocess.run(['pdf-parser.py', '-s', input_pdf], stdout=parser_outfile)
            print(f"Deep Scan completed. PDFParser results saved in: {output_dir}/deep_scan_pdfparser_results.txt")
        else:
            print("No suspicious elements detected. Skipping PDFParser analysis.")
            print(f"Deep Scan completed. PDFid results only saved in: {output_dir}/deep_scan_pdfid_results.txt")

def main():
    while True:
        choice = display_menu()
        if choice == '1':
            input_pdf = input("Enter the path to the PDF file for Simple Scan: ")
            output_dir = "simple_scan_output"
            os.makedirs(output_dir, exist_ok=True)
            simple_scan(input_pdf, output_dir)
        elif choice == '2':
            input_pdf = input("Enter the path to the PDF file for Deep Scan: ")
            output_dir = "deep_scan_output"
            os.makedirs(output_dir, exist_ok=True)
            deep_scan(input_pdf, output_dir)
        elif choice == '0':
            print("Exiting...")
            break
        else:
            print("Invalid choice. Please enter 1, 2, or 0.")
        print("------------------------------------")

if __name__ == "__main__":
    main()
