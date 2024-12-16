#!/bin/bash
# Script to import GPG keys into the vault VM

KEY_FILE=/path/to/private_key.asc

if [ ! -f "$KEY_FILE" ]; then
  echo "Error: GPG key file not found at $KEY_FILE"
  exit 1
fi

gpg --import "$KEY_FILE"
gpg --list-keys
echo "GPG key successfully imported."
