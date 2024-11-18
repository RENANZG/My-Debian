#!/bin/bash

# Variables
HOST_A="A.com" # Replace with the actual hostname or IP of Host A
BACKUP_DIR="/var/ServerBackup"
SSH_KEY_DIR="/root/.ssh"
SSH_KEY_PRIVATE="$SSH_KEY_DIR/id_rsa"
SSH_KEY_PUBLIC="$SSH_KEY_DIR/id_rsa.pub"
CRONTAB_ENTRY="0 2 * * * root bash $BACKUP_DIR/backup.sh" # Backup time schedule

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Ensure rsync is installed
if ! command_exists rsync; then
    echo "Installing rsync..."
    yum install -y rsync
fi

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Generate SSH key pair if it doesn't exist
if [ ! -f "$SSH_KEY_PRIVATE" ]; then
    echo "Generating SSH key pair..."
    ssh-keygen -t rsa -b 2048 -f "$SSH_KEY_PRIVATE" -N ""
fi

# Copy public key to Host A
echo "Copying SSH public key to Host A..."
scp "$SSH_KEY_PUBLIC" root@$HOST_A:/root/id_rsa.pub

# Login to Host A to set up authorized_keys
echo "Setting up authorized_keys on Host A..."
ssh root@$HOST_A <<EOF
mkdir -p /root/.ssh
chmod 700 /root/.ssh
touch /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
cat /root/id_rsa.pub >> /root/.ssh/authorized_keys
EOF

# Create the backup script
BACKUP_SCRIPT="$BACKUP_DIR/backup.sh"
cat << 'EOF' > "$BACKUP_SCRIPT"
#!/bin/bash
/usr/bin/rsync -avz -e "ssh -i /root/.ssh/id_rsa" root@A.com:/etc /var/ServerBackup
/usr/bin/rsync -avz -e "ssh -i /root/.ssh/id_rsa" --exclude mysite/updraft --exclude mysite/.cache root@A.com:/var/www /var/ServerBackup
/usr/bin/rsync -avz -e "ssh -i /root/.ssh/id_rsa" root@A.com:/var/lib/mysql /var/ServerBackup
# Add other rsync commands as needed
EOF

# Make the backup script executable
chmod +x "$BACKUP_SCRIPT"

# Add backup script to crontab if it doesn't exist
if ! crontab -l | grep -q "$BACKUP_SCRIPT"; then
    echo "Adding backup script to crontab..."
    (crontab -l; echo "$CRONTAB_ENTRY") | crontab -
fi

echo "Backup setup completed successfully!"
