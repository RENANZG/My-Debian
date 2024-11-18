#!/usr/bin/env bash

#######################################################################
# File Name    : git_setup_gh.sh
# Description  : Script to set up Git with GitHub CLI (gh) for HTTPS
#                authentication and configure Git user information.
# Dependencies : git, gh (GitHub CLI)
# Usage        : 1. Make the script executable:
#                   chmod +x git_setup_gh.sh
#                2. Run the script:
#                   bash git_setup_gh.sh
# Author       : Me and the bois
# License      : Free of charge, no warranty
#######################################################################

# Check if Git is installed
if ! command -v git &> /dev/null; then
  echo "Error: Git is not installed. Please install Git and rerun the script."
  exit 1
fi

# Check if GitHub CLI (gh) is installed
if ! command -v gh &> /dev/null; then
  echo "GitHub CLI (gh) is not installed. Installing it now..."

  # Download and install GitHub CLI
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
  sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

  sudo apt update && sudo apt install -y gh
  if [ $? -ne 0 ]; then
    echo "Error: Failed to install GitHub CLI (gh). Please install it manually and rerun the script."
    exit 1
  fi
fi

# Configure Git user information
echo "You can choose to use your actual name and email or aliases for privacy."

read -p "Do you want to use aliases instead of your actual name and email? (y/n): " USE_ALIASES
USE_ALIASES=${USE_ALIASES,,}  # Convert to lowercase

if [[ "$USE_ALIASES" == "y" ]]; then
  read -p "Enter your Git alias name: " GIT_NAME
  if [ -z "$GIT_NAME" ]; then
    echo "Error: Alias name cannot be empty."
    exit 1
  fi

  read -p "Enter your Git alias email: " GIT_EMAIL
  if [ -z "$GIT_EMAIL" ]; then
    echo "Error: Alias email cannot be empty."
    exit 1
  fi
else
  read -p "Enter your Git user name: " GIT_NAME
  if [ -z "$GIT_NAME" ]; then
    echo "Error: Name cannot be empty."
    exit 1
  fi

  read -p "Enter your Git email address: " GIT_EMAIL
  if [ -z "$GIT_EMAIL" ]; then
    echo "Error: Email cannot be empty."
    exit 1
  fi
fi

git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"

echo "Git has been configured with:"
echo "  Name : $GIT_NAME"
echo "  Email: $GIT_EMAIL"

# Authenticate with GitHub CLI (gh)
echo "Starting GitHub authentication..."
gh auth login

if [ $? -ne 0 ]; then
  echo "Error: Authentication failed. Please try again."
  exit 1
fi

echo "GitHub CLI (gh) has been successfully configured. You can now use Git and GitHub CLI to manage your repositories."

echo "Setup complete."
