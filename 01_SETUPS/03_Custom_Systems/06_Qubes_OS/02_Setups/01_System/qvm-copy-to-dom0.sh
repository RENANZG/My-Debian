#!/bin/bash

# qvm-copy-to-dom0

# Copy a file from an AppVM to dom0
#
# Use it only if extremely necessary.
#
# Usage:
# qvm-copy-to-dom0 <AppVM> <SourcePath> [<DestinationPath>]
#
# Example:
#   qvm-copy-to-dom0 myAppVM /path/to/file.txt
#   qvm-copy-to-dom0 myAppVM /path/to/file.txt /path/in/dom0.txt
#
# https://forum.qubes-os.org/t/copying-files-to-dom0/19025

AppVM="$1"       # mandatory
Source="$2"      # mandatory
Destination="$3" # optional (will use ~/QubesIncoming/AppVM/ folder if null)

# Validate inputs
if [ -z "$AppVM" ] || [ -z "$Source" ]; then
  echo "Usage: $0 appVM srcPath [ dst ]" >&2
  exit 1
fi

# Check if the source file exists
if ! qvm-run "$AppVM" "[ -e '$Source' ]"; then
  echo "Source file '$Source' does not exist in AppVM '$AppVM'" >&2
  exit 1
fi

if [ -z "$Destination" ]; then
  Destination="$HOME/QubesIncoming/$AppVM/$(basename "$Source")"
  mkdir -p "$HOME/QubesIncoming/$AppVM"
fi

if [ -e "$Destination" ]; then
  echo "'$Destination' exists; aborting" >&2
  exit 1
fi

# Copy the file
if ! qvm-run --pass-io "$AppVM" "cat '$Source'" > "$Destination"; then
  echo "Failed to copy '$Source' from '$AppVM' to '$Destination'" >&2
  exit 1
fi

echo "Successfully copied '$Source' to '$Destination'"
