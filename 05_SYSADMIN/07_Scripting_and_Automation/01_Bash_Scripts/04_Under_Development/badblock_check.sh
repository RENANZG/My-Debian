#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: sudo bash badblock_check.sh /dev/sdX"
    exit 1
fi

DEVICE=$1

echo "Checking for bad blocks on $DEVICE..."

# Check if the device exists
if [ ! -b $DEVICE ]; then
    echo "Error: $DEVICE is not a valid block device."
    exit 1
fi

# Unmount the device
umount $DEVICE* &> /dev/null

# Run badblocks
badblocks -v $DEVICE > badblocks.txt

if [ $? -eq 0 ]; then
    echo "Badblock check completed successfully."
    echo "Bad blocks are listed in badblocks.txt"
else
    echo "Error: Badblock check failed."
    exit 1
fi