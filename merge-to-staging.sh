#!/bin/bash

# Find the latest version number
LAST_VERSION=$(git tag | sort -V | tail -n 1)

if [ -z "$LAST_VERSION" ]; then
    # No previous version found, start at version 1.0
    VERSION="1.0"
else
    # Extract major and minor version numbers
    MAJOR=$(echo "$LAST_VERSION" | cut -d. -f1)
    MINOR=$(echo "$LAST_VERSION" | cut -d. -f2)

    # Increment minor version number
    MINOR=$((MINOR + 1))

    # Combine major and minor version numbers
    VERSION="$MAJOR.$MINOR"
fi

echo "Creating version $VERSION"

# Prompt user to enter commit message
echo "Enter a commit message for the squashed commits: "
read COMMIT_MESSAGE

# Update staging branch and merge dev branch with squash commits
git pull origin staging
git merge --squash dev
git commit -m "$COMMIT_MESSAGE"

# Create tag with the new version number
git tag -a "$VERSION" -m "Version $VERSION"

# Push changes to staging branch and tag to staging
git push origin staging
git push origin staging "$VERSION"
