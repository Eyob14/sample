#!/bin/bash

echo "Choose an option:"
echo "1. Revert to previous version"
echo "2. Revert to any version"
read -p "Enter your choice (1 or 2): " choice

if [ $choice -eq 1 ]; then

    # Find the current version using the current commit
    current_commit=$(git rev-parse HEAD)

    # Find the commit hash of the previous commit
    prev_commit_hash=$(git rev-parse HEAD^)

    # Get the version associated with the specified commit hash
    # prev_tag=$(git describe --tags --abbrev=0 $prev_commit_hash)

    # Iterate from current commit to user-specified commit and delete tags
    git rev-list --topo-order --ancestry-path "$prev_commit_hash".."$current_commit" | while read commit; do
        tag=$(git tag --points-at "$commit")
        if [ -n "$tag" ]; then
            git tag -d "$tag"
            git push --delete origin "$tag"
        fi
    done

    # Reset to user-specified commit
    git reset --hard "$prev_commit_hash"
    git push -f origin staging

elif [ $choice -eq 2 ]; then
    # Accept commit hash from user
    read -p "Enter the commit hash you want to revert back to: " commit_hash

    # Get current commit hash
    current_commit=$(git rev-parse HEAD)

    # Iterate from current commit to user-specified commit and delete tags
    git rev-list --topo-order --ancestry-path "$commit_hash".."$current_commit" | while read commit; do
        tag=$(git tag --points-at "$commit")
        if [ -n "$tag" ]; then
            git tag -d "$tag"
            git push --delete origin "$tag"
        fi
    done

    # Reset to user-specified commit
    git reset --hard "$commit_hash"
    git push -f origin staging

else
    echo "Invalid choice. Exiting script."
    exit 1
fi

echo "Done!"
