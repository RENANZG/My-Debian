#!/bin/bash

# List of GitHub repositories to clone
REPOS=(
    "https://github.com/user/repo1.git"
    "https://github.com/user/repo2.git"
    "https://github.com/user/repo3.git"
    # Add more repositories as needed
)

# Directory to clone repositories into
TARGET_DIR="${HOME}/cloned_repos"

# Create the target directory if it does not exist
mkdir -p "$TARGET_DIR"

# Function to clone a repository
clone_repo() {
    local repo_url=$1
    local target_dir=$2
    git clone "$repo_url" "$target_dir"
}

# Loop through the list of repositories and clone each one
for REPO in "${REPOS[@]}"; do
    REPO_NAME=$(basename "$REPO" .git)
    TARGET_PATH="${TARGET_DIR}/${REPO_NAME}"

    if [ -d "$TARGET_PATH" ]; then
        echo "Repository ${REPO_NAME} already exists at ${TARGET_PATH}, skipping."
    else
        echo "Cloning ${REPO_NAME} into ${TARGET_PATH}..."
        clone_repo "$REPO" "$TARGET_PATH"
    fi
done

echo "All repositories have been processed."
