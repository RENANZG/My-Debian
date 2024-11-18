#!/bin/bash

set -e

# Variables
ENV_FILE="/etc/restic/b2.env"
REPO="b2:my-repo:/backup"
EXCLUDE_FILE="/etc/restic/excludes.txt"
BACKUP_DIR="/home/tony"
CURRENT_DATE=$(date +%m_%d_%y_%H_%M_%S)
REPORT_FILE="/tmp/backup_$CURRENT_DATE"
EMAIL="email@example.com"
DIFF_SNAPSHOTS_COUNT=2

# Load environment variables
source "$ENV_FILE"

# Backup command
restic -r "$REPO" --exclude-file="$EXCLUDE_FILE" --verbose backup "$BACKUP_DIR" > "$REPORT_FILE" 2>&1

# Get diff of the latest snapshots
restic -r "$REPO" snapshots | tail -n 4 | head -n "$DIFF_SNAPSHOTS_COUNT" | cut -f 1 -d ' ' | xargs restic -r "$REPO" diff >> "$REPORT_FILE" 2>&1

# Send backup report via email
mail -s "Backup Report $CURRENT_DATE" "$EMAIL" < "$REPORT_FILE"

# Optional curl command
curl -s https://<redacted>

# Clean up
rm "$REPORT_FILE"
