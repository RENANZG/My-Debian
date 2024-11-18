#!/bin/bash

# Make the script executable:
# chmod +x /path/to/check_open_ports.sh
# Conky example:
# ${execi 60 /path/to/check_open_ports.sh}

# Define the target IP address or hostname. Change it as needed.
TARGET="localhost"

# Run nmap to scan for open ports on the target and format the output.
nmap -p- $TARGET | grep "open"
