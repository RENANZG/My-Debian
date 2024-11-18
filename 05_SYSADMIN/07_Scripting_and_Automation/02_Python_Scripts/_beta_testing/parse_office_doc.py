"""
parse_office_doc.py

OOXML Analyzer

This script analyzes Microsoft Office Open XML (OOXML) files used by
Microsoft Word, Excel, and PowerPoint. It can extract and parse the XML
content within these files, provide an interactive exploratory tool,
support batch analysis, and optionally integrate with MASTIFF (Malware
Analysis and Storage Toolkit In Forensics and Incident Response).

Usage:
 
 python ooxml_analyzer.py <files> [--interactive] [--output <output.json>]

 <files>         Paths to OOXML files (e.g., .docx, .xlsx, .pptx)
 --interactive   Enable interactive exploration of the extracted XML files
 --output        Path to the output JSON file for storing analysis results
"""

import os
import zipfile
import xml.etree.ElementTree as ET
import argparse
import json

# Variables
output_dir_template = "{}_extracted"

def extract_ooxml(file_path, output_dir):
    with zipfile.ZipFile(file_path, 'r') as zip_ref:
        zip_ref.extractall(output_dir)

def parse_xml_files(output_dir):
    xml_files = []
    for root, dirs, files in os.walk(output_dir):
        for file in files:
            if file.endswith('.xml'):
                xml_files.append(os.path.join(root, file))
    return xml_files

def analyze_xml_files(xml_files):
    analysis_results = []
    for xml_file in xml_files:
        tree = ET.parse(xml_file)
        root = tree.getroot()
        result = {
            'file': xml_file,
            'root_tag': root.tag,
            'root_attributes': root.attrib,
            'children': [{'tag': child.tag, 'attributes': child.attrib, 'text': child.text} for child in root]
        }
        analysis_results.append(result)
    return analysis_results

def display_analysis_results(analysis_results):
    for result in analysis_results:
        print(f"File: {result['file']}")
        print(f"Root tag: {result['root_tag']}, attributes: {result['root_attributes']}")
        for child in result['children']:
            print(f"Child tag: {child['tag']}, attributes: {child['attributes']}, text: {child['text']}")
        print("-" * 40)

def interactive_exploration(xml_files):
    while True:
        for i, xml_file in enumerate(xml_files):
            print(f"[{i}] {xml_file}")
        file_index = int(input(f"Enter the index of the XML file to explore (0-{len(xml_files) - 1}) or -1 to exit: "))
        if file_index == -1:
            break
        elif 0 <= file_index < len(xml_files):
            tree = ET.parse(xml_files[file_index])
            root = tree.getroot()
            print(ET.tostring(root, encoding='utf8').decode('utf8'))
        else:
            print("Invalid index")

def save_analysis_to_json(analysis_results, output_file):
    with open(output_file, 'w') as f:
        json.dump(analysis_results, f, indent=4)

def batch_analysis(file_paths, output_file=None):
    all_analysis_results = []
    for file_path in file_paths:
        output_dir = output_dir_template.format(file_path)
        extract_ooxml(file_path, output_dir)
        xml_files = parse_xml_files(output_dir)
        analysis_results = analyze_xml_files(xml_files)
        all_analysis_results.extend(analysis_results)
        display_analysis_results(analysis_results)
    
    if output_file:
        save_analysis_to_json(all_analysis_results, output_file)

def main():
    parser = argparse.ArgumentParser(description='OOXML Analyzer Toolkit')
    parser.add_argument('files', nargs='+', help='Paths to OOXML files (e.g., .docx, .xlsx, .pptx)')
    parser.add_argument('--interactive', action='store_true', help='Enable interactive exploration')
    parser.add_argument('--output', type=str, help='Path to the output JSON file for storing analysis results')
    args = parser.parse_args()

    print("Choose the mode of operation:")
    print("[1] Batch Analysis")
    print("[2] Interactive Exploration")
    mode_choice = int(input("Enter your choice (1 or 2): "))

    if mode_choice == 1:
        batch_analysis(args.files, args.output)
    elif mode_choice == 2:
        for file_path in args.files:
            output_dir = output_dir_template.format(file_path)
            extract_ooxml(file_path, output_dir)
            xml_files = parse_xml_files(output_dir)
            interactive_exploration(xml_files)
    else:
        print("Invalid choice. Exiting.")

if __name__ == "__main__":
    main()
