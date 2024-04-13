#!/usr/bin/env bash

# # Define the URL of the version.yaml file in the main branch
# MAIN_BRANCH_VERSION_FILE="https://raw.githubusercontent.com/pgaijin66/terraform-versioned/main/modules/rds/version.yaml"

# # Define the path to the version.yaml file in the current branch
# CURRENT_BRANCH_VERSION_FILE="modules/rds/version.yaml"

# # Function to fetch content from URL
# fetch_version_file_content() {
#     curl -s "$1"
# }

# # Fetch version.yaml content from the main branch
# main_branch_content=$(fetch_version_file_content "$MAIN_BRANCH_VERSION_FILE")

# # Fetch version.yaml content from the current branch
# current_branch_content=$(<"$CURRENT_BRANCH_VERSION_FILE")

# # Extract versions
# main_version=$(echo "$main_branch_content" | awk '/^version:/ {print $2}' | tr -d '"')
# current_version=$(echo "$current_branch_content" | awk '/^version:/ {print $2}' | tr -d '"')

# # Get folder name
# folder_name=$(dirname "$CURRENT_BRANCH_VERSION_FILE")
# DIRECTORY="modules"
# FOLDER_TO_KEEP="$folder_name"

# # Compare versions
# if [ "$main_version" != "$current_version" ]; then
#     # git checkout -b intermediate-branch
#     # tag_name="$current_version"
#     # git tag "$tag_name" && git push origin "$tag_name"
#     for folder in $folders; do
#         folder_name=$(basename "$folder") 
#         folder_to_keep=$(basename "$FOLDER_TO_KEEP")
#         if [ "$folder_name" != "$folder_to_keep" ]; then
#             tag_name="$current_version"
#             # rm -rf "$folder"
#             echo "will delete  $folder"
#         fi
#     done

#     # git add .
#     # git commit -m "Publishing module: $folder_name from $main_version to $current_version"
#     # git tag "$tag_name" && git push origin "$tag_name"
#     # git checkout -
#     # git branch -d intermediate-branch
# fi

# Define the directory to start the search from
START_DIR="."

# Find all version.yaml files
version_files=$(find "$START_DIR" -type f -name "version.yaml")
folders=$(find "$START_DIR" -mindepth 1 -maxdepth 3 -type d)

# # Define the URL of the version.yaml file in the main branch

function get_main_branch_version(){
    path_to_version_file=$1
    MAIN_BRANCH_VERSION_FILE="https://raw.githubusercontent.com/pgaijin66/terraform-versioned/main"
    echo "$MAIN_BRANCH_VERSION_FILE/$path_to_version_file"
    curl -s "$MAIN_BRANCH_VERSION_FILE/$path_to_version_file"

}
# MAIN_BRANCH_VERSION_FILE="https://raw.githubusercontent.com/pgaijin66/terraform-versioned/main/modules/rds/version.yaml"

# # Define the path to the version.yaml file in the current branch
# CURRENT_BRANCH_VERSION_FILE="modules/rds/version.yaml"

# # Function to fetch content from URL
# fetch_version_file_content() {
#     curl -s "$1"
# }

# # Fetch version.yaml content from the main branch
# main_branch_content=$(fetch_version_file_content "$MAIN_BRANCH_VERSION_FILE")

# Print the paths of all version.yaml files
git checkout -b intermediate-branch

for file in $version_files; do
    file="${file#./}"
    echo $file

    rds=$(awk '/^rds:/ {print $2}' "$file" | tr -d '"')
    provisioned=$(awk '/^provisioned:/ {print $2}' "$file" | tr -d '"')


    fp=$(dirname "$file")

    current_branch_content=$(<"$file")

    current_version=$(echo "$current_branch_content" | awk '/^version:/ {print $2}' | tr -d '"')
    main_branch_version=$(get_main_branch_version "$file" | awk '/^version:/ {print $2}' | tr -d '"')

    echo $current_version
    echo $main_branch_version

    folder_path=$(dirname "$(dirname "$(dirname "$file")")")


    if [ "$main_branch_version" != "$current_version" ]; then
        # git checkout -b intermediate-branch
        # tag_name="$current_version"
        # git tag "$tag_name" && git push origin "$tag_name"
        FOLDER_TO_KEEP="./$fp"
        for folder in $folders; do
            folder_name=$(basename "$folder") 
            echo $folder
            folder_to_keep=$(basename "$FOLDER_TO_KEEP")
            if [ "$folder_name" != "$folder_to_keep" ]; then
                tag_name="$current_version"
                # rm -rf "$folder"
                echo "will delete  $folder"
            fi
        done
        echo "./$fp"
        echo "Folder path: $folder_path"

        echo "will delete  ./$fp"



    fi
done

git add .
git commit -m "Publishing module: $folder_name from $main_version to $current_version"
git tag "$tag_name" && git push origin "$tag_name"
git checkout -
git branch -d intermediate-branch