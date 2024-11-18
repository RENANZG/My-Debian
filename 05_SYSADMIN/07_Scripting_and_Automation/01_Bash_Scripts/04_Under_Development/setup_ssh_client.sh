#!/usr/bin/env bash

########################################################################
# File Name    : configure_client_ssh.sh
# Description  : This script helps you set up SSH access from your 
#                Debian system (client) to a remote server securely.
#                It generates an SSH key pair if one doesn't exist, 
#                starts the ssh-agent, and connects to the server.
#                SSH keys are used for secure, password-less login.
# Dependencies : ssh; ssh-agent; ssh-keygen
# Usage        : • Replace the placeholders for server_username, 
#                  server_ip, and server_ssh_port with your server
#                  details.
#                • Make the script executable with:
#                  chmod +x configure_client_ssh.sh
#                • Run the script with no arguments:
#                  ./configure_client_ssh.sh
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

# User-configurable variables
server_username="your-username"  # Your server username
server_ip="your-server-ip"       # Your server IP address
server_ssh_port="2222"           # Your server's SSH port
email="your_email@example.com"   # Your email for SSH key comment

# Function to check if SSH key exists
check_ssh_key() {
    if [ ! -f ~/.ssh/id_ed25519 ]; then
        echo "SSH key not found."
        read -p "Do you want to generate an SSH key pair now? (yes/no): " generate_key
        if [ "$generate_key" == "yes" ]; then
            generate_ssh_key
        else
            echo "Please generate an SSH key pair using the 'ssh-keygen' command and run this script again."
            exit 1
        fi
    else
        echo "SSH key found."
    fi
}

# Function to generate SSH key
generate_ssh_key() {
    if [ -f ~/.ssh/id_ed25519 ]; then
        echo "SSH key already exists. Not overwriting."
    else
        echo "Generating SSH key pair..."
        # Generating a new SSH key pair using the ed25519 algorithm
        # ed25519 is a modern, high-security cryptographic algorithm
        # that provides better security and performance compared to
        # older methods like RSA.
        ssh-keygen -t ed25519 -C "$email" -f ~/.ssh/id_ed25519
        # Set proper permissions for the private key
        chmod 600 ~/.ssh/id_ed25519
        chmod 644 ~/.ssh/id_ed25519.pub
        echo "SSH key pair generated."
    fi
}

# Function to start ssh-agent and add the key
start_ssh_agent() {
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
}

# Check if ssh-agent is running and start it if not
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    echo "Starting ssh-agent..."
    start_ssh_agent
else
    echo "ssh-agent is already running."
fi

# Check if SSH key exists and prompt to generate if not
check_ssh_key

# SSH into the server
echo "Connecting to the server..."
ssh -p "$server_ssh_port" "$server_username@$server_ip"

# Confirm connection closure
echo "Connection closed."
