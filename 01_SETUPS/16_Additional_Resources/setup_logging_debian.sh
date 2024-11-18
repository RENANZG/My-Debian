#!/usr/bin/env bash

#######################################################################
# File Name    : setup_logging_debian.sh
# Description  : This script sets up default logging for rsyslog on a
#                Debian system. It updates the rsyslog configuration to
#                ensure logs are written to standard files such as
#                /var/log/syslog, /var/log/auth.log, and
#                /var/log/messages. It also creates these log files if
#                they do not exist and sets appropriate permissions.
#                Finally, it restarts the rsyslog service to apply the
#                changes. Its a basic approach, consider writing logs
#                on an external write-only device.
# Dependencies : Requires root privileges to modify system files.
# Usage        : • Make the script executable with:
#                sudo chmod +x setup_logging_debian.sh
#                • Run the script with:
#                sudo bash setup_logging_debian.sh
# Author       : Me and the bois
# License      : Free of charge, no warranty
#######################################################################

# Define log file paths
SYSLOG_PATH="/var/log/syslog"
AUTHLOG_PATH="/var/log/auth.log"
MESSAGES_PATH="/var/log/messages"
PORTMONITOR_PATH="/var/log/port_monitor.log"

# Define rsyslog configuration
RSYSLOG_CONF="/etc/rsyslog.conf"
RSYSLOG_D_CONF_DIR="/etc/rsyslog.d"
RSYSLOG_D_CONF_FILE="$RSYSLOG_D_CONF_DIR/50-default.conf"

# Function to create or update the rsyslog configuration
update_rsyslog_conf() {
    echo "Updating rsyslog configuration..."

    # Backup existing configuration
    if [ -f "$RSYSLOG_CONF" ]; then
        cp "$RSYSLOG_CONF" "$RSYSLOG_CONF.bak"
        echo "Backup of $RSYSLOG_CONF created as $RSYSLOG_CONF.bak"
    fi

    # Add default logging configuration if not present
    if ! grep -q "$SYSLOG_PATH" "$RSYSLOG_CONF"; then
        echo "*.*;auth,authpriv.none                $SYSLOG_PATH" >> "$RSYSLOG_CONF"
        echo "Default syslog configuration added to $RSYSLOG_CONF"
    fi

    # Check if 50-default.conf exists
    if [ ! -f "$RSYSLOG_D_CONF_FILE" ]; then
        # Create a new configuration file if it does not exist
        echo "Creating $RSYSLOG_D_CONF_FILE"
        echo "*.*;auth,authpriv.none                $SYSLOG_PATH" > "$RSYSLOG_D_CONF_FILE"
        echo "auth,authpriv.*                       $AUTHLOG_PATH" >> "$RSYSLOG_D_CONF_FILE"
        echo "*.*;mail.none;news.none              -$MESSAGES_PATH" >> "$RSYSLOG_D_CONF_FILE"
    fi
}

# Function to create log files and set permissions
create_log_files() {
    echo "Creating log files and setting permissions..."

    # Create log files if they do not exist
    for log_file in "$SYSLOG_PATH" "$AUTHLOG_PATH" "$MESSAGES_PATH" "$PORTMONITOR_PATH"; do
        if [ ! -f "$log_file" ]; then
            touch "$log_file"
            echo "Created $log_file"
        fi
        # Set permissions and ownership
        chown root:adm "$log_file"
        chmod 644 "$log_file"
        echo "Permissions set for $log_file"
    done
}

# Function to restart rsyslog service
restart_rsyslog() {
    echo "Restarting rsyslog service..."
    systemctl restart rsyslog

    if [ $? -eq 0 ]; then
        echo "Rsyslog service restarted successfully."
    else
        echo "Failed to restart rsyslog service."
    fi
}

# Main script execution
update_rsyslog_conf
create_log_files
restart_rsyslog

echo "Logging setup complete."
