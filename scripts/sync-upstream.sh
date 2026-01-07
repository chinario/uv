#!/usr/bin/env bash
# Script to sync with upstream repository

set -e

echo "Syncing with upstream repository..."

# Fetch the latest changes from upstream
git fetch upstream

# Get the current branch
current_branch=$(git rev-parse --abbrev-ref HEAD)

echo "Syncing current branch: $current_branch"
# Sync the current branch with upstream
git pull upstream $current_branch --no-edit

echo "Successfully synced with upstream!"