#!/bin/bash

# List of repositories
REPOS=(
    "https://github.com/user/repo1.git"
    "https://github.com/user/repo2.git"
    # Add more repositories
)

# Directory to clone repositories
BASE_DIR="${HOME}/repositories"

# Create base directory if it doesn't exist
mkdir -p "$BASE_DIR"

# Function to clone or pull repositories
sync_repo() {
    local repo_url=$1
    local repo_name=$(basename "$repo_url" .git)
    local repo_path="$BASE_DIR/$repo_name"

    if [ -d "$repo_path" ]; then
        echo "Updating $repo_name..."
        cd "$repo_path" && git pull
    else
        echo "Cloning $repo_name..."
        git clone "$repo_url" "$repo_path"
    fi
}

# Loop through repositories and sync each
for repo in "${REPOS[@]}"; do
    sync_repo "$repo"
done
