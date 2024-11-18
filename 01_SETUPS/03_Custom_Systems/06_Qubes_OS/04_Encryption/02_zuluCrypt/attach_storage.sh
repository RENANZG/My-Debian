#!/bin/bash

# Variables
QUBE="your-qube-name"  # Replace with your target Qube name
UUID="your-uuid"       # Replace with the UUID you want to search for

# Attach the block device to the specified Qube
qvm-block attach "$QUBE" $(sudo blkid -o value -s UUID | grep "$UUID" | awk -F':' '{print "dom0:" $1}')
