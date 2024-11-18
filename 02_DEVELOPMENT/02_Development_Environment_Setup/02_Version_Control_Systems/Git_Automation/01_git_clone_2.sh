#!/bin/bash

# Description: Use this script to clone all user repositories from any of the supported platforms listed below by simply passing the user's profile URL.

# Check if a URL is provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <repository URL>"
    exit 1
fi

# Variables
URL="$1"
USERNAME=""
PER_PAGE=100
BASE_URL=""

# Determine the platform based on the URL
if [[ "$URL" =~ ^https://github\.com/([^/]+) ]]; then
    PLATFORM="github"
    USERNAME="${BASH_REMATCH[1]}"
    BASE_URL="https://api.github.com/users/$USERNAME/repos?per_page=$PER_PAGE"
elif [[ "$URL" =~ ^https://gitlab\.com/([^/]+) ]]; then
    PLATFORM="gitlab"
    USERNAME="${BASH_REMATCH[1]}"
    BASE_URL="https://gitlab.com/api/v4/users/$USERNAME/projects?per_page=$PER_PAGE"
elif [[ "$URL" =~ ^https://codeberg\.org/([^/]+) ]]; then
    PLATFORM="codeberg"
    USERNAME="${BASH_REMATCH[1]}"
    BASE_URL="https://codeberg.org/api/v1/users/$USERNAME/repos?per_page=$PER_PAGE"
elif [[ "$URL" =~ ^https://bitbucket\.org/([^/]+) ]]; then
    PLATFORM="bitbucket"
    USERNAME="${BASH_REMATCH[1]}"
    BASE_URL="https://api.bitbucket.org/2.0/repositories/$USERNAME?pagelen=$PER_PAGE"
elif [[ "$URL" =~ ^https://gitea\.com/([^/]+) ]]; then
    PLATFORM="gitea"
    USERNAME="${BASH_REMATCH[1]}"
    BASE_URL="https://gitea.com/api/v1/users/$USERNAME/repos?limit=$PER_PAGE"
else
    echo "Unsupported platform or invalid URL"
    exit 1
fi

# Fetch repositories based on the detected platform
if [[ "$PLATFORM" == "bitbucket" ]]; then
    REPOS=$(curl -s "$BASE_URL" | jq -r '.values[].links.clone[] | select(.name=="https") | .href')
else
    REPOS=$(curl -s "$BASE_URL" | jq -r '.[].clone_url')
fi

# Clone each repository
for repo in $REPOS; do
    git clone "$repo"
done
