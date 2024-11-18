#!/bin/bash

########################################################################
# File Name    : scan_memory.sh
# Description  : This script scans running processes on a Linux system
#                using YARA rules to detect potential malware or other
#                suspicious activities.
# Dependencies : Requires `yara` to be installed.
# Usage        : • Make the script executable with:
#                sudo chmod +x scan_memory.sh
#                • Run the script with:
#                sudo bash scan_memory.sh <YARA rule file or URL>
#                • Example usage:
#                 bash scan_memory.sh rule.yara
#                 bash scan_memory.sh https://rule.com/rule.yara
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

# Configuration Variables
YARA_RELEASE_API_URL="https://api.github.com/repos/VirusTotal/yara/releases/latest"
YARA_DOWNLOAD_REGEX="browser_download_url.*linux.*x64\.tar\.gz"
YARA_ARCHIVE="yara-latest.tar.gz"
YARA_EXTRACT_DIR_PREFIX="yara-"
OUTPUT_TIMESTAMP_FORMAT="%Y%m%d%H%M%S"

# Set this to silently ignore progress-related output.
set -o errexit
set -o nounset
set -o pipefail

# Display script usage instructions
function show_usage {
    echo "Invalid argument."
    echo ""
    echo "Usage: ./scan_memory.sh <YARA rule file or URL>"
    echo "Example:"
    echo " ./scan_memory.sh rule.yara"
    echo " ./scan_memory.sh https://rule.com/rule.yara"
    exit 1
}

# Check if the script is run as root (similar to Test-Administrator in PowerShell)
function check_root {
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root."
        exit 1
    fi
}

# Download and install the latest YARA release if not already installed
function download_latest_yara {
    if ! command -v yara &> /dev/null; then
        echo "YARA is not installed. Downloading and installing the latest version."
        
        # Get the latest YARA release download URL
        LATEST_RELEASE_URL=$(curl -s "$YARA_RELEASE_API_URL" | grep -E "$YARA_DOWNLOAD_REGEX" | cut -d '"' -f 4)
        
        # Download and install YARA
        wget "$LATEST_RELEASE_URL" -O "$YARA_ARCHIVE"
        tar -xzf "$YARA_ARCHIVE"
        cd "${YARA_EXTRACT_DIR_PREFIX}"*
        ./configure && make && sudo make install
        cd ..
        rm -rf "$YARA_ARCHIVE" "${YARA_EXTRACT_DIR_PREFIX}"*
    fi
}

# Scan processes with the provided YARA rule
function scan_processes {
    local YARA_RULE_FILE=$1
    if [[ ! -f "$YARA_RULE_FILE" ]]; then
        echo "The YARA rule file could not be found."
        exit 1
    fi

    echo "Scanning Processes..."
    OUTPUT_FILE="${YARA_RULE_FILE%.*}_$(date +$OUTPUT_TIMESTAMP_FORMAT).txt"

    for PID in $(ps -e -o pid=); do
        if RESULT=$(yara -p 10 -D "$YARA_RULE_FILE" "$PID" 2>/dev/null); then
            echo "The following rule matched the following process:" >> "$OUTPUT_FILE"
            echo "$RESULT" >> "$OUTPUT_FILE"
            ps -p "$PID" -o pid,comm=,args= >> "$OUTPUT_FILE"
            echo "----------------------------------------" >> "$OUTPUT_FILE"
        fi
    done

    if [[ ! -s "$OUTPUT_FILE" ]]; then
        echo "No processes were found matching the provided YARA rule: $YARA_RULE_FILE" | tee "$OUTPUT_FILE"
    else
        echo "Any processes that were flagged are saved in $OUTPUT_FILE"
    fi
}

# Download YARA rule if the provided rule is a URL
function download_rule_by_url {
    local YARA_RULE_URL=$1
    FILENAME=$(basename "$YARA_RULE_URL")
    wget -O "$FILENAME" "$YARA_RULE_URL"
    scan_processes "$FILENAME"
    rm -f "$FILENAME"
}

# Main script logic
function main {
    check_root

    if [[ $# -ne 1 ]]; then
        show_usage
    fi

    download_latest_yara

    YARA_RULE_FILE_OR_URL=$1
    if [[ "$YARA_RULE_FILE_OR_URL" =~ ^http.*\.(yara|yar)$ ]]; then
        download_rule_by_url "$YARA_RULE_FILE_OR_URL"
    else
        scan_processes "$YARA_RULE_FILE_OR_URL"
    fi
}

# Execute the main function with all arguments
main "$@"
