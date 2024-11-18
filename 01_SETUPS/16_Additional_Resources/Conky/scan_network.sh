#!/bin/bash

# Make the script executable:
# chmod +x /path/to/scan_network.sh
# Conky example:
# ${execi 300 /path/to/scan_network.sh}

# Define the local network range. Adjust the IP range to match your network.
NETWORK="192.168.1.0/24"

# Run nmap to scan the local network for active hosts.
nmap -sn $NETWORK | grep "Nmap scan report for"
