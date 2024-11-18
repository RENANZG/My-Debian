#!/usr/bin/env python3

########################################################################
# File Name    : security_analysis_usb.py
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
#                RUN+="/usr/local/bin/security_analysis_usb.py"
#                • After creating the udev rule, reload the rules:
#                sudo udevadm control --reload-rules
#                • Test the Setup to see if the virus scan is triggered 
#                and logs are written. insert a USB drive and check the 
#                log file at:
#                /$HOME/USB_Virus/USB_Virus.txt
# Dependencies : clamav, yara, yara-python
# Usage        : • Make the script executable with:
#                sudo chmod +x /usr/local/bin/security_analysis_usb.py
#                • To manually run the script:
#                sudo python3 /usr/local/bin/security_analysis_usb.py
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

import os
import subprocess
import time
import getpass

def is_root():
    return os.geteuid() == 0

def prompt_user():
    choice = input("A USB drive has been inserted. Do you want to scan it for viruses? (y/n): ").strip().lower()
    if choice == 'y':
        print("Starting virus scan...")
    elif choice == 'n':
        print("Scan cancelled by user.")
        exit(0)
    else:
        print("Invalid response. Exiting.")
        exit(1)

def install_dependencies():
    if not shutil.which("clamscan"):
        print("Installing ClamAV...")
        subprocess.run(['apt-get', 'update'])
        subprocess.run(['apt-get', 'install', '-y', 'clamav'])

    if not shutil.which("yara"):
        print("Installing YARA and yara-python...")
        subprocess.run(['apt-get', 'install', '-y', 'yara', 'yara-python'])

def update_clamav_database():
    print("Updating ClamAV virus database...")
    subprocess.run(['freshclam'])

def configure_yara_rules():
    rules_file = "/etc/yara/rules.yar"
    rules_content = """
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
    """
    with open(rules_file, 'w') as file:
        file.write(rules_content)
    print(f"YARA rules configured at: {rules_file}")

def scan_usb(mount_point):
    log_dir = f"/home/{getpass.getuser()}/USB_Virus"
    log_file = f"{log_dir}/USB_Virus.txt"

    os.makedirs(log_dir, exist_ok=True)
    
    with open(log_file, 'a') as logfile:
        logfile.write(f"{time.ctime()}: Starting virus scan on {mount_point}\n")
        subprocess.run(['clamscan', '-vir', '--copy', log_dir, '--alert-encrypted', '--bell', '--log', log_file, mount_point])
        logfile.write(f"{time.ctime()}: Finished virus scan on {mount_point}\n")
        
        logfile.write(f"{time.ctime()}:
