#!/bin/bash

# Make the script executable:
# chmod +x /path/to/get_public_ip.sh
# Conky example:
# ${execi 600 /path/to/get_public_ip.sh}

curl -s ifconfig.me
