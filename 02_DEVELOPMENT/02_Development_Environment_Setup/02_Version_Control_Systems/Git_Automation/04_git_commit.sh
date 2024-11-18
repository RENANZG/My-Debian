#!/bin/bash

# Set the commit message template file
TEMPLATE_FILE="/path/to/.gitmessage"

# Check if the template file exists
if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "Template file not found!"
    exit 1
fi

echo "Select an action:"
echo "1. Commit changes"
echo "2. Amend the last commit"
read -p "Enter your choice (1/2): " choice

case $choice in
    1)
        # Commit changes
        echo "Using commit message template: $TEMPLATE_FILE"
        git config --local commit.template "$TEMPLATE_FILE"
        git add .
        git commit
        ;;
    2)
        # Amend the last commit
        echo "Using commit message template for amend: $TEMPLATE_FILE"
        git config --local commit.template "$TEMPLATE_FILE"
        git add .
        git commit --amend
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

# Reset the commit template configuration
git config --local --unset commit.template

echo "Operation completed."
