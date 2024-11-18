#!/bin/bash

# Make the script executable:
# chmod +x /path/to/check_auth_log.sh
# Conky example:
# ${execi 60 /path/to/check_auth_log.sh}

# Define the log file location. Adjust for your distribution if needed.
LOG_FILE="/var/log/auth.log"

# Get the last 10 failed login attempts.
grep "Failed password" $LOG_FILE | tail -n 10
