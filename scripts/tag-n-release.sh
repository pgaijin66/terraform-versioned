#!/usr/bin/env bash

# Define the URL of the version.yaml file in the main branch
MAIN_BRANCH_VERSION_FILE="https://raw.githubusercontent.com/pgaijin66/terraform-versioned/main/modules/rds/version.yaml"

# Define the path to the version.yaml file in the current branch
CURRENT_BRANCH_VERSION_FILE="modules/rds/version.yaml"

# Function to fetch content from URL
fetch_version_file_content() {
    curl -s "$1"
}

# Fetch version.yaml content from the main branch
main_branch_content=$(fetch_version_file_content "$MAIN_BRANCH_VERSION_FILE")

# Fetch version.yaml content from the current branch
current_branch_content=$(<"$CURRENT_BRANCH_VERSION_FILE")

# Extract versions
main_version=$(echo "$main_branch_content" | awk '/^version:/ {print $2}' | tr -d '"')
current_version=$(echo "$current_branch_content" | awk '/^version:/ {print $2}' | tr -d '"')

# Get folder name
folder_name=$(dirname "$CURRENT_BRANCH_VERSION_FILE")
DIRECTORY="modules"
folders=$(find "$DIRECTORY" -mindepth 1 -maxdepth 1 -type d)
FOLDER_TO_KEEP="$folder_name"

# Compare versions
if [ "$main_version" != "$current_version" ]; then
    echo "Version has changed in folder $folder_name from $main_version to $current_version"
    # tag_name="$current_version"
    # git tag "$tag_name" && git push origin "$tag_name"
    for folder in $folders; do
        folder_name=$(basename "$folder") 
        folder_to_keep=$(basename "$FOLDER_TO_KEEP")
        if [ "$folder_name" != "$folder_to_keep" ]; then
            tag_name="$current_version"
            git checkout -b intermediate-branch
            git add .
            rm -rf "$folder"
            git commit -m "Publishing module: $folder_name"
            git tag "$tag_name" && git push origin "$tag_name"
            git checkout -
        fi
    done
else
    echo "Version is unchanged in folder $folder_name ($main_version)"
fi
