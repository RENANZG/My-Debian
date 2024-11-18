#!/bin/bash

# Define repository and backup directory
REPO_DIR="/path/to/repo"
BACKUP_DIR="/path/to/backup/$(date +'%Y-%m-%d')"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Change to repository directory
cd "$REPO_DIR" || exit

# Create a incremental tarball of the repository
tar -czf "$BACKUP_DIR/repo_backup.tar.gz" .
