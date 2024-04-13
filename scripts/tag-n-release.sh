#!/usr/bin/env bash

# Define the path to the modules directory
MODULES_DIR="modules"

declare current_version
declare main_version

function get_current_version () {
    version_file=$1
    current_version=$(awk '/^version:/ {print $2}' "$version_file" | tr -d '"') 
}

function get_main_version () {
    version_file=$1

    # # Fetch the latest changes from the master branch
    # git fetch origin main

    # Check if the fetch was successful
    if [[ ! "$(git fetch origin main)" ]]; then
        echo "Error: Failed to fetch changes from master branch."
        exit 1
    fi

    # Checkout the master branch
    git checkout main

    main_version=$(awk '/^version:/ {print $2}' "$version_file" | tr -d '"') 

    # Return to the original branch
    git checkout -

}

# Iterate over each folder inside the modules directory
for folder in "$MODULES_DIR"/*/; do
    folder=${folder%/}
    version_file="$folder/version.yaml"

    # Check if the version.yaml file exists in the current folder
    if [ -f "$version_file" ]; then
        # Extract the version using awk
        # version=$(awk '/^version:/ {print $2}' "$version_file" | tr -d '"')
        get_current_version "$version_file"

        get_main_version "$version_file"

        echo "$current_version"
        echo "$main_version"


    #     # Print the version along with the folder name
    #     echo "Version in $folder: $current_version"
    # else
    #     echo "Error: version.yaml not found in $folder"
    fi
done
