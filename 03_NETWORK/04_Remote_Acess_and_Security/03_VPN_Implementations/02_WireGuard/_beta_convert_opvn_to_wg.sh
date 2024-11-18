#!/bin/bash

########################################################################
# File Name    : convert_ovpn_to_wg.sh
# Description  : Converts .ovpn files to WireGuard configuration files
# Dependencies : Bash
# Usage        : • Make the script executable with:
#                chmod +x convert_ovpn_to_wg.sh
#                • Run the script with the .ovpn file as an argument:
#                bash convert_ovpn_to_wg.sh <ovpn_file>
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

# Path to the .ovpn file
INPUT_OVPN="$1"
# Output config file name based on the .ovpn file
WG_CONFIG_OUTPUT="${INPUT_OVPN%.ovpn}.conf"
# Generate WireGuard private key
PRIVATE_KEY=$(wg genkey)
# Corresponding public key
PUBLIC_KEY=$(echo "$PRIVATE_KEY" | wg pubkey)
# Server's WireGuard public key (replace manually)
PEER_PUBLIC_KEY="REPLACE_WITH_SERVER_PUBLIC_KEY"
# Client's WireGuard IP (adjust as needed)
ADDRESS="10.0.0.2/32"
# Default DNS (Cloudflare) if none found in .ovpn
DNS="1.1.1.1"

# Function to show usage information
function usage() {
    echo "Usage: $0 <ovpn_file>"
    echo "Converts an OpenVPN (.ovpn) file to a WireGuard configuration."
    exit 1
}

# Check if OpenVPN file is provided
if [[ -z "$INPUT_OVPN" ]]; then
    usage
fi

# Ensure OpenVPN file exists
if [[ ! -f "$INPUT_OVPN" ]]; then
    echo "Error: OpenVPN file not found!"
    exit 1
fi

# Extract the remote server and DNS from the .ovpn file
ENDPOINT=$(grep -i "^remote " "$INPUT_OVPN" | awk '{print $2 ":" $3}')
DNS_OVPN=$(grep -i "^dhcp-option DNS" "$INPUT_OVPN" | awk '{print $3}')

# Use DNS from .ovpn if it exists, otherwise use the default DNS
if [[ -n "$DNS_OVPN" ]]; then
    DNS="$DNS_OVPN"
fi

# Generate WireGuard configuration file
cat <<EOF > "$WG_CONFIG_OUTPUT"
[Interface]
PrivateKey = $PRIVATE_KEY
Address = $ADDRESS
DNS = $DNS

[Peer]
PublicKey = $PEER_PUBLIC_KEY
AllowedIPs = 0.0.0.0/0, ::/0
Endpoint = $ENDPOINT
PersistentKeepalive = 25
EOF

echo "WireGuard configuration file '$WG_CONFIG_OUTPUT' created successfully!"
exit 0
