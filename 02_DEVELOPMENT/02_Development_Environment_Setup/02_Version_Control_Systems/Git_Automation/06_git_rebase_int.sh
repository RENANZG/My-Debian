#!/bin/bash

# Ensure the user is on a branch
if [ -z "$(git rev-parse --abbrev-ref HEAD)" ]; then
    echo "You are not on a branch."
    exit 1
fi

echo "Select an action:"
echo "1. Merge a branch"
echo "2. Rebase a branch"
echo "3. Interactive rebase"
read -p "Enter your choice (1/2/3): " choice

case $choice in
    1)
        # Merge a branch
        read -p "Enter the branch to merge into current branch: " merge_branch
        git fetch origin
        git merge origin/$merge_branch
        ;;
    2)
        # Rebase a branch
        read -p "Enter the branch to rebase onto current branch: " rebase_branch
        git fetch origin
        git rebase origin/$rebase_branch
        ;;
    3)
        # Interactive rebase
        read -p "Enter the number of commits to rebase interactively (e.g., 10): " num_commits
        git rebase -i HEAD~$num_commits
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

echo "Operation completed."
