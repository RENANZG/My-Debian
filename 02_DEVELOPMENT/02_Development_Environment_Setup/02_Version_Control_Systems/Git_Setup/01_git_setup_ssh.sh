#!/usr/bin/env bash

#######################################################################
# File Name    : git_setup_ssh.sh
# Description  : This script sets up Git with SSH keys for
#                authentication and configures your Git user
#                information. It generates an `ed25519` SSH key if one
#                does not already exist. Users can choose how to store
#                SSH keys securely, including KeePassXC integration.
# Dependencies : git; ssh-keygen; ssh-agent; optional KeePassXC for key
#                management; shred for secure deletion
# Usage        : • Make the script executable with:
#                 chmod +x git_setup_ssh.sh
#                • Run the script with:
#                 bash git_setup_ssh.sh
# Author       : Me and the bois
# License      : Free of charge, no warranty
#######################################################################

# Check if Git is installed
if ! command -v git &> /dev/null; then
  echo "Git is not installed."
  read -p "Would you like to install Git? (y/n): " install_git
  if [[ "$install_git" =~ ^[Yy]$ ]]; then
    sudo apt update
    sudo apt install -y git || { echo "Git installation failed. Exiting."; exit 1; }
  else
    echo "Please install Git and run the script again."
    exit 1
  fi
fi

# Check if ssh-keygen is installed
if ! command -v ssh-keygen &> /dev/null; then
  echo "ssh-keygen is not installed."
  read -p "Would you like to install OpenSSH? (y/n): " install_ssh
  if [[ "$install_ssh" =~ ^[Yy]$ ]]; then
    sudo apt update
    sudo apt install -y openssh-client || { echo "OpenSSH installation failed. Exiting."; exit 1; }
  else
    echo "Please install OpenSSH and run the script again."
    exit 1
  fi
fi

# Set Git user configuration
read -p "Enter your name for Git: " GIT_NAME

while true; do
  read -p "Enter your email for Git (use a noreply email if you prefer): " GIT_EMAIL
  echo "You entered: $GIT_EMAIL"
  read -p "Is this correct? (y/n): " email_confirm
  if [[ "$email_confirm" =~ ^[Yy]$ ]]; then
    break
  fi
done

git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"

# Check if SSH key already exists in the agent
echo "Checking for existing SSH keys in the ssh-agent..."
if ssh-add -l &> /dev/null; then
  echo "Existing SSH keys found in ssh-agent."
  echo "You may want to manage these keys or proceed with creating a new one."
else
  echo "No SSH keys found in ssh-agent."
fi

# Generate SSH key if it doesn't already exist
SSH_KEY_PATH="$HOME/.ssh/id_ed25519"
if [ ! -f "$SSH_KEY_PATH" ]; then
  read -s -p "Enter a strong passphrase for your SSH key: " SSH_PASSPHRASE
  echo
  echo "Generating a new SSH key..."
  ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f "$SSH_KEY_PATH" -N "$SSH_PASSPHRASE" || { echo "SSH key generation failed. Exiting."; exit 1; }
else
  echo "SSH key already exists at $SSH_KEY_PATH"
  echo "Listing the existing SSH key files:"
  ls -l "$SSH_KEY_PATH" "$SSH_KEY_PATH.pub"
fi

# Display the public key for copying
if [ -f "$SSH_KEY_PATH.pub" ]; then
  echo
  echo "Your SSH public key (copy this to GitHub):"
  echo -e "\033[1m$(cat "$SSH_KEY_PATH.pub")\033[0m"
  echo
  echo "Add your SSH key to GitHub here: https://github.com/settings/ssh/new"
else
  echo "Public key not found at $SSH_KEY_PATH.pub."
  exit 1
fi

# Handle the keys securely
chmod 600 "$SSH_KEY_PATH"
chmod 600 "$SSH_KEY_PATH.pub"
echo
echo "Your private key has been securely stored at:"
echo "$SSH_KEY_PATH"
echo "Important: Never share your private key with anyone!"

# Give the user storage method options
echo
echo "Choose how you want to manage your SSH keys:"
echo "1. Gnome Keyring"
echo "2. KDE Wallet"
echo "3. KeePassXC SSH Agent integration"
echo "4. No auto-add, read the instructions to manage manually"
read -p "Enter the number corresponding to your preferred method (1-4): " storage_option

case $storage_option in
  1)
    echo "Setting up Gnome Keyring..."
    if command -v gnome-keyring-daemon &> /dev/null; then
      eval $(gnome-keyring-daemon --start --components=ssh) || { echo "Failed to start GNOME Keyring."; exit 1; }
      ssh-add "$SSH_KEY_PATH" || { echo "Failed to add SSH key to GNOME Keyring."; exit 1; }
      echo "SSH key added to GNOME Keyring."
    else
      echo "GNOME Keyring is not installed. Please install it first."
    fi
    ;;

  2)
    echo "Configuring KDE Wallet..."
    if command -v kwalletcli &> /dev/null; then
      kwalletcli --open 1> /dev/null || { echo "Failed to open KDE Wallet."; exit 1; }
      ssh-add "$SSH_KEY_PATH" || { echo "Failed to add SSH key to KDE Wallet."; exit 1; }
      echo "SSH key added to KDE Wallet."
    elif command -v ksshaskpass &> /dev/null; then
      export SSH_ASKPASS='/usr/bin/ksshaskpass'
      ssh-add "$SSH_KEY_PATH" || { echo "Failed to add SSH key to KDE Wallet using ksshaskpass."; exit 1; }
      echo "SSH key added using ksshaskpass."
    else
      echo "Neither kwalletcli nor ksshaskpass is installed. Please install them first."
    fi
    ;;

  3)
    echo "Configuring KeePassXC integration..."

    # Check if KeePassXC is installed
    if ! command -v keepassxc &> /dev/null; then
      echo "KeePassXC is not installed. Please install it first."
      read -p "Would you like to install KeePassXC? (y/n): " install_keepassxc
      if [[ "$install_keepassxc" =~ ^[Yy]$ ]]; then
        sudo apt update
        sudo apt install -y keepassxc || { echo "KeePassXC installation failed. Exiting."; exit 1; }
      else
        echo "Please install KeePassXC and run the script again."
        exit 1
      fi
    fi

    # Check if SSH_AUTH_SOCK is set and valid
    if [ -z "$SSH_AUTH_SOCK" ] || [ ! -S "$SSH_AUTH_SOCK" ]; then
      echo "Warning: SSH_AUTH_SOCK is not set or the socket is invalid."
      echo "KeePassXC integration may not work correctly."
    else
      echo "SSH_AUTH_SOCK is set to: $SSH_AUTH_SOCK"
    fi

    echo
    echo "Please follow these steps to set up KeePassXC SSH Agent integration:"
    echo "1. Open KeePassXC."
    echo "2. Go to 'Tools > Settings' and select 'SSH Agent' from the sidebar."
    echo "3. Enable 'SSH Agent integration'."
    echo "4. Create a new entry, or open an existing entry in edit mode (CTRL + E)."
    echo "5. Set the password you used for the key file in the password field."
    echo "6. Go to 'SSH Agent' from the sidebar."
    echo "7. Add the private key '$SSH_KEY_PATH' in the Attachment field."
    echo "8. Choose the options for this key as needed."
    echo "9. Press OK to accept the entry. "
    echo
    echo "More info: https://keepassxc.org/docs/KeePassXC_UserGuide#_ssh_agent_integration"
    ;;

  4)
    echo "No automatic storage selected. You can manually manage your SSH key."
    echo
    echo "## Manual SSH Key Management with KeePassXC ##"
    echo ""
    echo "1. Open KeePassXC."
    echo "2. Go to 'Tools > Settings' and select 'SSH Agent' from the sidebar."
    echo "3. Enable 'SSH Agent integration'."
    echo "4. Create a new entry, or open an existing entry in edit mode (CTRL + E)."
    echo "5. Set the password you used for the key file in the password field."
    echo "6. Go to 'SSH Agent' from the sidebar."
    echo "7. Add the private key '$SSH_KEY_PATH' in the Attachment field."
    echo "8. Choose the options for this key as needed."
    echo "9. Press OK to accept the entry. "
    echo
    echo "More info: https://keepassxc.org/docs/KeePassXC_UserGuide#_ssh_agent_integration"
    ;;

  *)
    echo "Invalid option selected. Exiting."
    exit 1
    ;;
esac

# Optional cleanup of key files from disk
echo "Have you completed the process and backed up the keys safely?"
read -p "Would you like to securely delete the SSH key files from disk using shred? (y/n): " delete_keys
if [[ "$delete_keys" =~ ^[Yy]$ ]]; then
  echo "Deleting SSH key files securely using shred..."
  shred -u "$SSH_KEY_PATH" "$SSH_KEY_PATH.pub" || { echo "Failed to securely delete key files."; exit 1; }
  echo "SSH key files have been securely deleted."
else
  echo "SSH key files have been retained."
fi

echo "Setup completed successfully."
exit 0
