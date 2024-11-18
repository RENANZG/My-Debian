#!/usr/bin/env bash

########################################################################
# File Name     : file_backup_incremental_simple.sh
# Description   : Simplified incremental backup using tar with log file, 
#                 the script to handle multiple files or directories and 
#                 perform incremental backups without overwriting 
#                 previous backups or logs.
# Dependencies  : tar
# Invoked By    : cron
# Usage       : • Make the script executable with 
#                 chmod +x file_backup_incremental_simple.sh
#                 • Run the script with arguments:
#                 bash /file_backup_incremental_simple.sh <source_dir> 
#                 <destination_dir>
#                 • The script prompts the user to enter the 
#                 <crontab_schedule> interactively, see below for the 
#                 crontab format 
# Author        : Me and the bois
# License       : Free of charge, no warranty
########################################################################
########################################################################
# HOW TO EDIT CRONTAB
# Open the crontab file for editing:
# crontab -e
# To schedule this script using crontab, adopt this format:
# 
# * * * * * command(s)
# - - - - -
# | | | | |
# | | | | ----- Day of week (0 - 7) (Sunday=0 or 7)
# | | | ------- Month (1 - 12)
# | | --------- Day of month (1 - 31)
# | ----------- Hour (0 - 23)
# ------------- Minute (0 - 59)
# 
# For example, to run the script:
# - Every 30 minutes:
# 	*/30 * * * * /path/to/your/file_backup_incremental_simple.sh
# - Every hour:
# 	0 * * * * /path/to/your/file_backup_incremental_simple.sh
# - Every day at midnight:
# 	0 0 * * * /path/to/your/file_backup_incremental_simple.sh
# - Every Sunday at 8 PM:
# 	0 20 * * 0 /path/to/your/file_backup_incremental_simple.sh
# - Every Monday at 3 PM:
# 	0 15 * * 1 /path/to/your/file_backup_incremental_simple.sh
# - Every weekday at noon:
# 	0 12 * * 1-5 /path/to/your/file_backup_incremental_simple.sh
# - On the 1st of every month at 5 AM:
# 	0 5 1 * * /path/to/your/file_backup_incremental_simple.sh
# - Every 15th of the month at 6 AM:
# 	0 6 15 * * /path/to/your/file_backup_incremental_simple.sh
# Special keywords for common intervals
# - @reboot: Run at system startup
# - @hourly: Run every hour (0 * * * *)
# - @daily: Run every day at midnight (0 0 * * *)
# - @weekly: Run every Sunday at midnight (0 0 * * 0)
# - @monthly: Run on the 1st of every month at midnight (0 0 1 * *)
# Save and exit the editor. The script will now run at the
# specified intervals.
########################################################################

# Check if all required arguments are provided
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <input_file_or_directory> <output_file_or_directory>"
    echo "Logs are stored in /var/log/simplebackups.log"
    exit 1
fi

# Echo explanation of crontab scheduling
echo "To schedule this script using crontab, adopt this format:"
echo ""
echo "* * * * * command(s)"
echo "- - - - -"
echo "| | | | |"
echo "| | | | ----- Day of week (0 - 7) (Sunday=0 or 7)"
echo "| | | ------- Month (1 - 12)"
echo "| | --------- Day of month (1 - 31)"
echo "| ----------- Hour (0 - 23)"
echo "------------- Minute (0 - 59)"
echo ""
echo "For example, to run the script every 30 minutes:"
echo "*/30 * * * * /path/to/your/file_backup_incremental_simple.sh"
echo ""
echo "Special keywords for common intervals:"
echo "- @reboot: Run at system startup"
echo "- @hourly: Run every hour"
echo "- @daily: Run every day at midnight"
echo "- @weekly: Run every Sunday at midnight"
echo "- @monthly: Run on the 1st of every month at midnight"
echo ""

# Prompt for crontab schedule
read -p "Enter the crontab schedule for your backup job: " crontab_schedule

# Check if crontab_schedule is provided
if [ -z "$crontab_schedule" ]; then
    echo "Error: Crontab schedule not provided."
    exit 1
fi

# Assign command-line arguments to variables
source_paths=("${@:1:$#-1}")  # All arguments except the last one
destination_dir="${@: -1}"    # Last argument is the destination directory

# Create the backup directory if it doesn't exist
mkdir -p "$destination_dir"

# Create a timestamp for the backup directory
timestamp=$(date +"%Y%m%d%H%M%S")
new_backup_dir="$destination_dir/$timestamp"

# Create the new backup directory
mkdir -p "$new_backup_dir"

# Loop through each source path and perform incremental backup
for source_dir in "${source_paths[@]}"; do
    # Get base name of source directory or file
    base_name=$(basename "$source_dir")
    
    # Perform the incremental backup
    tar --create --listed-incremental="$new_backup_dir/latest.snapshot" --file="$new_backup_dir/${base_name}.tar" "$source_dir"
done

# Update the latest symlink to point to the latest backup directory
ln -sfn "$new_backup_dir" "$destination_dir/latest"

# Append timestamp to log file using sed
echo "Last backup on: $(date '+%Y-%m-%d %H:%M:%S')" >> /var/log/simplebackups.log

echo "Backup completed successfully."
