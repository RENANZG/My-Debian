#!/bin/bash

# Make the script executable:
# chmod +x /path/to/check_network_connections.sh
# Conky example:
# ${execi 60 /path/to/check_network_connections.sh}

# List active network connections using netstat. You might need to use 'ss' for modern systems.

netstat -tuln | grep -E 'Proto|tcp|udp'
