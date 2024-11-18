#!/bin/bash

# This script checks and fixes AppArmor configurations and log files
# on a Debian system.
#
# Usage: Save this script as fix_apparmor.sh, make it executable with:
# chmod +x fix_apparmor.sh
# and run it with:
# sudo bash fix_apparmor.sh

# Function to check and create log files
create_log_files() {
  echo "Checking if log directories and files exist..."

  if [ ! -d /var/log/audit ]; then
    echo "Creating directory /var/log/audit..."
    sudo mkdir -p /var/log/audit
  fi

  if [ ! -f /var/log/audit/audit.log ]; then
    echo "Creating file /var/log/audit/audit.log..."
    sudo touch /var/log/audit/audit.log
    sudo chmod 644 /var/log/audit/audit.log
  fi

  if [ ! -f /var/log/messages ]; then
    echo "Creating file /var/log/messages..."
    sudo touch /var/log/messages
    sudo chmod 644 /var/log/messages
  fi

  echo "Log files are ready."
}

# Function to check and restart AppArmor
restart_apparmor() {
  echo "Checking the status of AppArmor..."
  # Using --no-pager to avoid interactive output
  sudo systemctl status apparmor --no-pager

  echo "Restarting the AppArmor service..."
  sudo systemctl restart apparmor

  echo "AppArmor has been restarted."
}

# Function to check auditd
check_auditd() {
  if ! command -v auditd &> /dev/null; then
    echo "auditd is not installed. Would you like to install it? [y/N]"
    read install_auditd

    if [[ "$install_auditd" == "y" || "$install_auditd" == "Y" ]]; then
      sudo apt update && sudo apt install -y auditd
      sudo systemctl start auditd
      echo "auditd installed and started."
    else
      echo "auditd will not be installed."
    fi
  else
    echo "auditd is already installed."
  fi
}

# Function to fix permissions
fix_permissions() {
  echo "Adjusting permissions of log files..."
  sudo chmod 644 /var/log/audit/audit.log
  sudo chmod 644 /var/log/messages
  echo "Permissions adjusted."
}

# Execute functions
create_log_files
restart_apparmor
check_auditd
fix_permissions

echo "AppArmor fix process completed."
