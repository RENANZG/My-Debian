#!/bin/bash

#######################################################################
# File Name    : setup_salt_policy.sh
# Description  : Installs user salt and pillar directories for personal
#                state configurations, populates the POLICY_DIR with
#                default .sls files and applies them.
# Dependencies : Requires root privileges and must be run in dom0.
# Usage        : • Make the script executable:
#                  [user@dom0 ~]$ sudo chmod +x setup_salt_policy.sh
#                • Run the script:
#                  [user@dom0 ~]$ sudo bash setup_salt_policy.sh
# Author       : Me and the bois
# License      : Free of charge, no warranty
#######################################################################

set -eu

# Define variables
POLICY_DIR="/srv/user_salt/policies"
CONFIG_FILE="/etc/salt/master"
SOURCE_DIR="/my_saltpolicy/saltpolicy"

# Ensure script is running in dom0
if [ "$(qubes-prefs default-template 2>/dev/null || echo "not-dom0")" == "not-dom0" ]; then
  echo "This script must be run in dom0 of Qubes OS." >&2
  exit 1
fi

# Ensure root privileges
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root (or with sudo)." >&2
  exit 1
fi

echo "Setting up SaltStack policy directory and configuration in dom0..."

# Erase the old policy directory
if [ -d "$POLICY_DIR" ]; then
  echo "Removing the old policy directory: $POLICY_DIR"
  rm -rf "$POLICY_DIR"
fi

# Create policy directory
echo "Creating policy directory: $POLICY_DIR"
mkdir -p "$POLICY_DIR"

# Populate POLICY_DIR with default .sls files
if [ -d "$SOURCE_DIR" ]; then
  echo "Copying default policies from $SOURCE_DIR to $POLICY_DIR..."
  cp -r "$SOURCE_DIR"/* "$POLICY_DIR"
else
  echo "Source directory $SOURCE_DIR does not exist. Exiting..." >&2
  exit 1
fi

# Ensure permissions are correct
echo "Setting permissions for $POLICY_DIR..."
chown -R root:root "$POLICY_DIR"
chmod -R 750 "$POLICY_DIR"

# Configure SaltStack master file roots
echo "Configuring SaltStack master file roots in $CONFIG_FILE..."
cat > "$CONFIG_FILE" <<EOF
# vim:ft=yaml
file_roots:
  base:
    - $POLICY_DIR
EOF

# Check if configuration was written
if [ -f "$CONFIG_FILE" ]; then
  echo "Configuration file written to: $CONFIG_FILE"
else
  echo "Failed to write configuration file: $CONFIG_FILE" >&2
  exit 1
fi

# Apply Salt policies
echo "Applying Salt policies..."
if qubesctl state.highstate; then
  echo "Salt policies applied successfully."
else
  echo "Failed to apply Salt policies." >&2
  exit 1
fi

# Completion message
echo "SaltStack policy setup and application complete in dom0."
