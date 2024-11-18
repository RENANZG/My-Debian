#!/usr/bin/env bash

########################################################################
# File Name    : scan_usb.sh
# Description  : This script prompts the user to scan any USB drive for 
#                viruses upon insertion in Debian GNU/Linux. It utilizes 
#                ClamAV along with YARA rules for advanced detection. 
#                The script waits for the USB drive to be mounted in a 
#                specified directory and then conducts a comprehensive 
#                scan using ClamAV and YARA.
# Explanations : • Create a udev rule to trigger the script when a USB 
#                drive is inserted.
#                • Run:
#                sudo nano /etc/udev/rules.d/99-usb-virusscan.rules
#                • Add the following content:
#                ACTION=="add", KERNEL=="sd[b-z][1-9]", 
#                SUBSYSTEMS=="usb", 
#                RUN+="/usr/local/bin/scan_usb.sh"
#                • After creating the udev rule, reload the rules:
#                sudo udevadm control --reload-rules
#                • Test the Setup to see if the virus scan is triggered 
#                and logs are written. insert a USB drive and check the 
#                log file at:
#                /$HOME/USB_Virus/USB_Virus.txt
# Dependencies : clamav, yara, yara-python
# Usage        : • Make the script executable with:
#                sudo chmod +x /usr/local/bin/scan_usb.sh
#                • To manually run the script:
#                sudo bash /usr/local/bin/scan_usb.sh
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Function to prompt user to confirm scan
prompt_user() {
    read -p "A USB drive has been inserted. Do you want to scan it for viruses? (y/n): " choice
    case "$choice" in
      y|Y )
        echo "Starting virus scan..."
        ;;
      n|N )
        echo "Scan cancelled by user."
        exit 0
        ;;
      * )
        echo "Invalid response. Exiting."
        exit 1
        ;;
    esac
}

# Function to install dependencies if not already installed
install_dependencies() {
    if ! command -v clamscan &>/dev/null; then
        echo "Installing ClamAV..."
        apt-get update
        apt-get install -y clamav
    fi
    
    if ! command -v yara &>/dev/null; then
        echo "Installing YARA and yara-python..."
        apt-get install -y yara yara-python
    fi
}

# Function to update ClamAV virus database
update_clamav_database() {
    echo "Updating ClamAV virus database..."
    freshclam
}

# Function to create and use YARA rules for enhanced detection
configure_yara_rules() {
    local rules_file="/etc/yara/rules.yar"

    # Example YARA rule
    cat <<EOF > "$rules_file"
// Example YARA rule
rule detect_malware {
    strings:
        $a = "malicious_string"
    condition:
        $a
}

// MemoryModule YARA rule
rule MemoryModule {
    meta:
        id = "6O9mUMvPhziJ72IXHf6muZ"
        fingerprint = "4aa0a23f28698898404d700cb363ddf06dd275f5798815e797113656a2a40ae8"
        version = "1.0"
        date = "2020-05-06"
        modified = "2020-05-06"
        status = "RELEASED"
        sharing = "TLP:WHITE"
        source = "CCCS"
        author = "analyst@CCCS"
        description = "Yara rule to detect usage of MemoryModule Library"
        category = "TECHNIQUE"
        technique = "LOADER:MEMORYMODULE"
        mitre_att = "T1129"
        report = "TA20-0192"
        hash = "812bbe8b9acabad05b08add50ee55c883e1f7998f3a7cae273d3f0d572a79adc"

    strings:
        $func_ptr = {55 8B EC 6A 00 68 [3] 00 68 [3] 00 68 [3] 00 68 [3] 00 68 [3] 00}
        $func_ptr_64 = {48 [3] 48 [4] 00 00 00 00 48 8? [5] 48 8? [3] 4? 8? [5] 48 8? [3-5] 48 8?}
        $api_1 = "LoadLibraryA"
        $api_2 = "GetProcAddress"
        $api_3 = "FreeLibrary"
        $api_4 = "VirtualFree"
        $api_5 = "VirtualProtect"
        $api_6 = "VirtualAlloc"

    condition:
        uint16(0) == 0x5a4d and all of ($api*) and ($func_ptr or $func_ptr_64)
}
EOF

    echo "YARA rules configured at: $rules_file"
}

# Function to scan the USB drive using ClamAV and YARA
scan_usb() {
    local mount_point=$1
    local log_dir="/home/$SUDO_USER/USB_Virus"
    local log_file="$log_dir/USB_Virus.txt"

    # Create directory and log file if they don't exist
    mkdir -p "$log_dir"
    touch "$log_file"

    # Perform virus scan with ClamAV
    echo "$(date): Starting virus scan on $mount_point" >> "$log_file"
    clamscan -vir --copy="$log_dir" --alert-encrypted --bell --log="$log_file" "$mount_point"
    echo "$(date): Finished virus scan on $mount_point" >> "$log_file"

    # Perform YARA scan
    echo "$(date): Starting YARA scan on $mount_point" >> "$log_file"
    yara "$rules_file" "$mount_point" >> "$log_file"
    echo "$(date): Finished YARA scan on $mount_point" >> "$log_file"
}

# Check if ClamAV and YARA are installed, install if necessary
install_dependencies

# Update ClamAV virus database
update_clamav_database

# Configure YARA rules
configure_yara_rules

# Prompt user to confirm scan
prompt_user

# Main script logic starts here
echo "Waiting for the USB drive to be mounted..."

# Assuming the USB drive will be mounted under /media/usb
MOUNT_DIR="/media/usb"

# Wait for the device to be mounted
while [ ! -d "$MOUNT_DIR" ]; do
    sleep 1
done

# Scan the USB drive using ClamAV and YARA
scan_usb "$MOUNT_DIR"

