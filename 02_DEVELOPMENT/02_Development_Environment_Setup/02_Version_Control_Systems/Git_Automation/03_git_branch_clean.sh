#!/usr/bin/env bash

########################################################################
# File Name    : git_branch_clean.sh
# Description  : This script cleans up local and remote branches.
#                It switches to the main branch, fetches updates from 
#                the remote, deletes local branches that have been
#                merged into main, and removes remote branches that no 
#                longer exist.
# Dependencies : git
# Usage        : • Make the script executable with:
#                 chmod +x git_branch_clean.sh
#                • Run the script with:
#                 bash git_branch_clean.sh
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

# Check if we are in a Git repository
if [ ! -d ".git" ]; then
  echo "This directory is not a Git repository."
  exit 1
fi

# Checkout to the main branch
echo "Checking out to the main branch..."
git checkout main

# Fetch updates from the remote
echo "Fetching updates from the remote..."
git fetch --all

# Update the main branch
echo "Updating the main branch..."
git pull origin main

# Remove local branches merged into main
echo "Removing local branches merged into main..."
for branch in $(git branch --merged main | grep -v '^\*' | grep -v 'main'); do
    echo "Removing local branch: $branch"
    git branch -d "$branch"
done

# Remove remote branches that no longer exist on the remote
echo "Removing remote branches that no longer exist on the remote..."
for branch in $(git branch -r | grep -v '\->' | grep -v 'origin/main' | sed 's/origin\///'); do
    if ! git show-ref --quiet refs/heads/"$branch"; then
        echo "Removing remote branch: origin/$branch"
        git push origin --delete "$branch"
    fi
done

echo "Script completed."
