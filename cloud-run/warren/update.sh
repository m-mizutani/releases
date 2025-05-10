#!/bin/bash

# Get tag from argument (if not provided, use the latest commit ID from the external repository)
if [ $# -eq 1 ]; then
    TAG=$1
else
    # Get the latest commit ID from the external repository
    TAG=$(git ls-remote https://github.com/secmon-lab/warren.git main | cut -f1)
fi

# Update the FROM line in Dockerfile
sed -i '' "s|FROM ghcr.io/secmon-lab/warren:.*|FROM ghcr.io/secmon-lab/warren:${TAG}|" Dockerfile

# Commit the changes
git add Dockerfile
git commit -m "chore: update base image to ${TAG}"

# Push the changes
git push origin main
