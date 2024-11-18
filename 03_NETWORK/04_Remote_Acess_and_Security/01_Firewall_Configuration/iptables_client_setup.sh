#!/bin/bash

########################################################################
# File Name    : iptables_client_setup.sh
# Description  : Script to install and configure UFW firewall on a client system.
# Dependencies : UFW package must be available in the repository.
# Usage        : • Make the script executable with 
#                sudo chmod +x iptables_client_setup.sh
#                • Run the script with no arguments:   
#                bash iptables_client_setup.sh
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

# Function to confirm steps
confirm_step() {
    echo "$1"
    echo "Do you want to proceed with this step? (yes/no):"
    read CONFIRM
    if [ "$CONFIRM" != "yes" ]; then
        echo "Skipping this step."
        return 1
    fi
    return 0
}

# Clear the current iptables rules
confirm_step "Clearing current iptables rules..."
if [ $? -eq 0 ]; then
    iptables -F
    iptables -X
fi

# Set default policies to drop
confirm_step "Setting default policies to drop..."
if [ $? -eq 0 ]; then
    iptables -P INPUT DROP
    iptables -P OUTPUT DROP
    iptables -P FORWARD DROP
fi

# Allow loopback device communication
confirm_step "Allowing loopback device communication..."
if [ $? -eq 0 ]; then
    iptables -A INPUT -i lo -j ACCEPT
    iptables -A OUTPUT -o lo -j ACCEPT
fi

# Prompt for SSH port and allow SSH traffic
confirm_step "Enter the port number for SSH (default is 22):"
if [ $? -eq 0 ]; then
    read SSH_PORT
    if [ -z "$SSH_PORT" ]; then
        SSH_PORT=22
    fi
    iptables -A INPUT -p tcp --dport $SSH_PORT -m state --state NEW -j ACCEPT
    iptables -A OUTPUT -p tcp --sport $SSH_PORT -m state --state ESTABLISHED -j ACCEPT
fi

# Prompt for DNS port and allow DNS traffic
confirm_step "Enter the port number for DNS (default is 53):"
if [ $? -eq 0 ]; then
    read DNS_PORT
    if [ -z "$DNS_PORT" ]; then
        DNS_PORT=53
    fi
    iptables -A INPUT -p udp --dport $DNS_PORT -m state --state NEW,ESTABLISHED -j ACCEPT
    iptables -A OUTPUT -p udp --sport $DNS_PORT -m state --state ESTABLISHED -j ACCEPT
fi

# Prompt for VPN port and allow VPN traffic
confirm_step "Enter the port number for VPN (e.g., 1194 for OpenVPN):"
if [ $? -eq 0 ]; then
    read VPN_PORT
    iptables -A INPUT -p udp --dport $VPN_PORT -j ACCEPT
    iptables -A OUTPUT -p udp --sport $VPN_PORT -j ACCEPT
fi

# Allow HTTP and HTTPS traffic
confirm_step "Allowing HTTP and HTTPS traffic..."
if [ $? -eq 0 ]; then
    iptables -A INPUT -p tcp --dport 80 -m state --state NEW -j ACCEPT
    iptables -A OUTPUT -p tcp --sport 80 -m state --state ESTABLISHED -j ACCEPT
    iptables -A INPUT -p tcp --dport 443 -m state --state NEW -j ACCEPT
    iptables -A OUTPUT -p tcp --sport 443 -m state --state ESTABLISHED -j ACCEPT
fi

# Allow established and related packets
confirm_step "Allowing established and related packets..."
if [ $? -eq 0 ]; then
    iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
    iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
fi

# Drop invalid packets
confirm_step "Dropping invalid packets..."
if [ $? -eq 0 ]; then
    iptables -A INPUT -m state --state INVALID -j DROP
    iptables -A OUTPUT -m state --state INVALID -j DROP
    iptables -A FORWARD -m state --state INVALID -j DROP
fi

# Protect against brute-force attacks
confirm_step "Protecting against brute-force attacks..."
if [ $? -eq 0 ]; then
    iptables -A INPUT -p tcp --dport $SSH_PORT -m state --state NEW -m recent --set --name SSH --rsource
    iptables -A INPUT -p tcp --dport $SSH_PORT -m state --state NEW -m recent --update --seconds 86400 --hitcount 4 --name SSH --rsource -j DROP
fi

# Protect against various types of scans
confirm_step "Protecting against port scans..."
if [ $? -eq 0 ]; then
    iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
    iptables -A INPUT -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
    iptables -A INPUT -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
    iptables -A INPUT -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
    iptables -A INPUT -p tcp --tcp-flags FIN,ACK FIN -j DROP
    iptables -A INPUT -p tcp --tcp-flags ACK,URG URG -j DROP
    iptables -A INPUT -p tcp --tcp-flags ACK,PSH PSH -j DROP
    iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP
fi

# Allow ping from inside to outside
confirm_step "Allowing ping from inside to outside..."
if [ $? -eq 0 ]; then
    iptables -A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT
    iptables -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT
fi

# Configure VPN traffic
confirm_step "Configuring VPN traffic..."
if [ $? -eq 0 ]; then
    # Allow traffic to the VPN server
    iptables -A INPUT -i tun+ -j ACCEPT
    iptables -A OUTPUT -o tun+ -j ACCEPT

    # Allow forwarding for VPN traffic
    iptables -A FORWARD -i tun+ -o eth0 -j ACCEPT
    iptables -A FORWARD -i eth0 -o tun+ -j ACCEPT

    # Allow forwarding for established and related VPN traffic
    iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
fi

# Save the iptables rules
confirm_step "Saving iptables rules..."
if [ $? -eq 0 ]; then
    service iptables save
fi

# Restart iptables service
confirm_step "Restarting iptables service..."
if [ $? -eq 0 ]; then
    systemctl restart iptables
fi

# Display iptables rules
confirm_step "Displaying iptables rules..."
if [ $? -eq 0 ]; then
    iptables -L INPUT -v -w
fi

echo "Configuration complete!"
