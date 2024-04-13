#!/usr/bin/env bash

# Define the path to the modules directory
MODULES_DIR="modules"

# Iterate over each folder inside the modules directory
for folder in "$MODULES_DIR"/*/; do
    folder=${folder%/}
    version_file="$folder/version.yaml"

    # Check if the version.yaml file exists in the current folder
    if [ -f "$version_file" ]; then
        # Extract the version using awk
        version=$(awk '/^version:/ {print $2}' "$version_file" | tr -d '"')

        # Print the version along with the folder name
        echo "Version in $folder: $version"
    else
        echo "Error: version.yaml not found in $folder"
    fi
done
