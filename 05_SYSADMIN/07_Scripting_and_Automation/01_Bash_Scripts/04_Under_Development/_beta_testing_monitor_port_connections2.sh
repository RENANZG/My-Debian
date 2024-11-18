#!/bin/bash

########################################################################
#            UNDERRRRRRRRRRRRRRR TESTSSSSSSSSSSSSSSSSSS !!!!
# File Name   : monitor_port_connections.sh
# Description : Monitor specific port connections and log them with 
#               timestamps, ignoring localhost and certain IP ranges.
# Usage       : • Make the script executable with 
#               chmod +x monitor_port_connections.sh 
#               • Run the script with no arguments:
#               sudo ./monitor_port_connections.sh
# Author      : 
# License     : 
########################################################################

# File to store the connection states
LOG_FILE="/var/log/connectionstate.log"

# Ports to monitor (e.g., SMTP, HTTP, HTTPS, SSH, FTP)
PORTS="25,80,443,22,21"

# Debug mode (set to 1 for debug output, 0 to disable)
DEBUG=0

# IP address to ignore (by default, the local host's IP address)
IP_IGNORE=$(hostname -i)

# Function to get current connections
get_connections() {
  ss -tnp | awk -v ports="$PORTS" -v ip_ignore="$IP_IGNORE" '
  BEGIN {
    split(ports, port_array, ",");
    for (i in port_array) port_list[port_array[i]] = 1;
  }
  $4 ~ /:[0-9]+$/ {
    split($4, addr_port, ":");
    port = addr_port[2];
    split($5, client_addr, ":");
    ip = client_addr[1];
    if (port_list[port] && ip !~ /^127\.0\.0\.1/ && ip !~ /^::1/ && ip !~ ip_ignore && ip !~ /^10\.|^192\.168\./) {
      print ip ":" port;
    }
  }'
}

# Function to log connections with timestamp
log_connections() {
  local timestamp=$(date +"%Y-%m-%d_%H%M%S")
  local connections=$(get_connections)
  local temp_file=$(mktemp)

  # Read the existing log file into an associative array
  declare -A log_entries
  if [[ -f "$LOG_FILE" ]]; then
    while IFS=: read -r ip port old_timestamp; do
      log_entries["$ip:$port"]=$old_timestamp
    done < "$LOG_FILE"
  fi

  # Update log entries with current connections
  if [[ ! -z "$connections" ]]; then
    while read -r connection; do
      if [[ -n ${log_entries[$connection]} ]]; then
        # Update the timestamp for existing connection
        if [[ $DEBUG -eq 1 ]]; then
          echo "Updating timestamp for existing connection: ${connection}"
        fi
        log_entries["$connection"]=$timestamp
      else
        # Add new connection
        if [[ $DEBUG -eq 1 ]]; then
          echo "Inserting new connection: ${connection}"
        fi
        log_entries["$connection"]=$timestamp
      fi
    done <<< "$connections"
  fi

  # Write the updated log entries back to the log file
  for entry in "${!log_entries[@]}"; do
    echo "${entry}:${log_entries[$entry]}" >> "$temp_file"
  done

  mv "$temp_file" "$LOG_FILE"

  # Output connections to the terminal
  echo "Current connections at ${timestamp}:"
  echo "$connections"
}

# Function to configure UFW
configure_ufw() {
  # Enable UFW if not already active
  if ! ufw status | grep -qw active; then
      echo "UFW is not active. Enabling UFW."
      ufw enable
  fi

  # Allow traffic on the specified ports
  IFS=',' read -ra PORT_ARRAY <<< "$PORTS"
  for PORT in "${PORT_ARRAY[@]}"; do
      ufw allow "$PORT"
  done
}

# Function to revert UFW changes
revert_ufw() {
  IFS=',' read -ra PORT_ARRAY <<< "$PORTS"
  for PORT in "${PORT_ARRAY[@]}"; do
      ufw delete allow "$PORT"
  done
}

# Function to configure iptables
configure_iptables() {
  # Allow traffic on the specified ports
  IFS=',' read -ra PORT_ARRAY <<< "$PORTS"
  for PORT in "${PORT_ARRAY[@]}"; do
      iptables -A INPUT -p tcp --dport "$PORT" -j ACCEPT
  done
}

# Function to revert iptables changes
revert_iptables() {
  IFS=',' read -ra PORT_ARRAY <<< "$PORTS"
  for PORT in "${PORT_ARRAY[@]}"; do
      iptables -D INPUT -p tcp --dport "$PORT" -j ACCEPT
  done
}

# Ensure the script runs as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Configure UFW or iptables based on availability
if command -v ufw &> /dev/null; then
  configure_ufw
  trap revert_ufw EXIT
elif command -v iptables &> /dev/null; then
  configure_iptables
  trap revert_iptables EXIT
else
  echo "Neither UFW nor iptables is installed. Exiting."
  exit 1
fi

# Main loop to run every minute
while true; do
  log_connections
  sleep 60
done
