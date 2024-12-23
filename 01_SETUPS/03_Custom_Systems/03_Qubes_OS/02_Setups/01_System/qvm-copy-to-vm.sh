#!/bin/bash

# qvm-copy-to-vm

# Copy a file from dom0 to an AppVM
#
# Usage:
# qvm-copy-to-vm <target_vm> <file>
#
# Example:
#   qvm-copy-to-vm myAppVM /path/to/file.txt
#
# https://forum.qubes-os.org/t/copying-files-to-dom0/19025

TargetVM="$1"  # mandatory
File="$2"      # mandatory

# Validate inputs
if [ -z "$TargetVM" ] || [ -z "$File" ]; then
  echo "Usage: $0 <target_vm> <file>" >&2
  exit 1
fi

# Check if the source file exists
if [ ! -e "$File" ]; then
  echo "Source file '$File' does not exist in dom0" >&2
  exit 1
fi

# Copy the file to the target VM
if ! qvm-copy-to-vm "$TargetVM" "$File"; then
  echo "Failed to copy '$File' to '$TargetVM'" >&2
  exit 1
fi

echo "Successfully copied '$File' to '$TargetVM'"
