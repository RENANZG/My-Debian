#!/bin/bash

# Fetch updates from the remote repository
git fetch --all

# Checkout all branches and pull latest changes
for branch in $(git branch -r | grep -v '\->'); do
    git checkout "${branch#origin/}"
    git pull
done

# Checkout the original branch
git checkout main
