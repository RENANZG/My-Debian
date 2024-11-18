#!/usr/bin/env bash

#######################################################################
# File Name    : git_setup_gcm.sh
# Description  : This script sets up Git with Git Credential Manager
#                (GCM) for HTTPS authentication and configures your Git #                user information. It guides the user through the
#                process of logging in with their GitHub using GCM.
# Dependencies : git; gcm (Git Credential Manager)
# Usage        : • Make the script executable with:
#                 chmod +x git_setup_gcm.sh
#                • Run the script with:
#                 bash git_setup_gcm.sh
# Author       : Me and the bois
# License      : Free of charge, no warranty
#######################################################################

# Check if Git is installed
if ! command -v git &> /dev/null; then
  echo "Git is not installed. Please install Git and run the script again."
  exit 1
fi

# Check if Git Credential Manager (GCM) is installed
if ! command -v git-credential-manager-core &> /dev/null; then
  echo "Git Credential Manager (GCM) is not installed. Installing GCM..."
  # Download and install GCM
  sudo apt-get update
  sudo apt-get install -y git-credential-manager-core
  if [ $? -ne 0 ]; then
    echo "Failed to install Git Credential Manager (GCM). Please install it manually and rerun the script."
    exit 1
  fi
fi

# Set up GCM as the credential helper
git config --global credential.helper manager-core

# Set Git user configuration
echo "Set Git your user configuration (you could use aliases)."
read -p "Enter your name for Git configuration: " GIT_NAME
read -p "Enter your email for Git configuration: " GIT_EMAIL

git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"

echo "Git has been configured with the following settings:"
echo "Name: $GIT_NAME"
echo "Email: $GIT_EMAIL"

# Guide the user to authenticate with GitHub using GCM
echo "Git Credential Manager (GCM) has been configured as your credential helper."
echo "You will need to authenticate with GitHub using GCM. This will open a web browser for you to log in."

# Prompt the user to perform a Git operation to trigger GCM authentication
echo "To authenticate, please run a Git command that requires authentication, such as:"
echo "  git clone https://github.com/your-repository.git"
echo "Replace 'your-repository' with a valid repository you have access to."

echo "Setup completed."
