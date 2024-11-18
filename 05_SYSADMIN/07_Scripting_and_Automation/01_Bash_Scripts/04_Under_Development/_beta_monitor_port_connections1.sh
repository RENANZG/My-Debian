#!/bin/bash

########################################################################
#            UNDERRRRRRRRRRRRRRR TESTSSSSSSSSSSSSSSSSSS !!!!
# File Name   : monitor_port_connections.sh
# Description : Monitor specific port connections and log them with 
#               timestamps, ignoring localhost and specified IP ranges.
#               Configures iptables and ufw rules, and sets up logging
#               through rsyslog.
# Usage       : • Make the script executable with 
#               chmod +x monitor_port_connections.sh 
#               • Run the script with no arguments:
#               sudo ./monitor_port_connections.sh
# Author      : 
# License     : 
########################################################################

# Configuration
PORTS="25,80,443,22,21"  # Ports to monitor
LOGFILE="/var/log/port_monitor.log"
IGNORED_IPS=("127.0.0.1" "192.168.1.0/24" "10.0.0.0/8")  # IP ranges to ignore

# Function to add iptables rules
setup_iptables() {
    echo "Setting up iptables rules..."
    # Create a new chain for monitoring if it doesn't exist
    iptables -N PORT_MONITOR 2>/dev/null || iptables -F PORT_MONITOR

    # Add rules to the monitoring chain
    for PORT in $(echo $PORTS | tr ',' ' '); do
        iptables -A PORT_MONITOR -p tcp --dport $PORT -j RETURN
    done

    # Ignore localhost and specified IP ranges
    for IP in "${IGNORED_IPS[@]}"; do
        iptables -A PORT_MONITOR -s $IP -j RETURN
    done

    # Log the rest of the connections
    for PORT in $(echo $PORTS | tr ',' ' '); do
        iptables -A PORT_MONITOR -p tcp --dport $PORT -j LOG --log-prefix "PORT_MONITOR: " --log-level 4
    done

    # Jump to the monitoring chain for the specified ports
    for PORT in $(echo $PORTS | tr ',' ' '); do
        iptables -A INPUT -p tcp --dport $PORT -j PORT_MONITOR
    done
}

# Function to set up logging
setup_logging() {
    echo "Setting up logging..."
    if ! grep -q "PORT_MONITOR" /etc/rsyslog.conf; then
        # Add a new rule to rsyslog configuration
        echo ':msg, contains, "PORT_MONITOR:" '"$LOGFILE"'' >> /etc/rsyslog.conf
        # Restart rsyslog service to apply changes
        systemctl restart rsyslog
    else
        echo "Logging configuration already exists."
    fi
}

# Function to set up ufw rules
setup_ufw() {
    echo "Setting up ufw rules..."
    # Enable UFW if not already enabled
    ufw enable
    # Allow the specified ports through ufw
    for PORT in $(echo $PORTS | tr ',' ' '); do
        ufw allow $PORT/tcp
    done
}

# Function to revert changes
revert_changes() {
    echo "Reverting iptables changes..."
    iptables -F PORT_MONITOR
    iptables -X PORT_MONITOR

    echo "Reverting UFW changes..."
    for PORT in $(echo $PORTS | tr ',' ' '); do
        ufw delete allow $PORT/tcp
    done

    echo "Reverting rsyslog changes..."
    sed -i '/PORT_MONITOR/d' /etc/rsyslog.conf
    systemctl restart rsyslog

    echo "Reversion complete."
}

# Main function
main() {
    if [[ $1 == "revert" ]]; then
        revert_changes
    else
        setup_iptables
        setup_logging
        setup_ufw
        echo "Port monitoring setup complete."
    fi
}

# Ensure the script runs as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Execute the main function with arguments
main "$@"
