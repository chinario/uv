#!/usr/bin/env bash
# Script to sync with upstream repository and preserve custom modifications

set -e

# Configuration
UPSTREAM_REMOTE="upstream"
UPSTREAM_BRANCH="main"

echo "=== Syncing with upstream repository ==="

# Ensure upstream remote exists
if ! git remote get-url $UPSTREAM_REMOTE &>/dev/null; then
  echo "❌ Upstream remote not found. Adding..."
  git remote add $UPSTREAM_REMOTE https://github.com/astral-sh/uv.git
  echo "✅ Upstream remote added"
fi

# Fetch the latest changes from upstream
echo "📥 Fetching latest changes from upstream..."
git fetch $UPSTREAM_REMOTE

# Get the current branch
current_branch=$(git rev-parse --abbrev-ref HEAD)

echo "🔄 Syncing branch: $current_branch"

# Check if there are local changes
if ! git diff --quiet; then
  echo "⚠️  Local changes detected, stashing..."
  git stash push -m "sync-upstream-$(date +%s)"
  stashed=true
else
  stashed=false
fi

# Sync with upstream using merge strategy
echo "🔀 Merging upstream changes..."
if git pull $UPSTREAM_REMOTE $UPSTREAM_BRANCH --no-edit --no-rebase 2>/dev/null; then
  echo "✅ Merge successful"
else
  echo "⚠️  Merge conflict detected"
  
  # Try to auto-resolve by keeping upstream for most files
  # but keeping our custom workflows
  git diff --name-only --diff-filter=U | while read file; do
    case "$file" in
      .github/workflows/sync-upstream.yml | .github/workflows/build-binaries-only.yml)
        echo "  ⏸️  Keeping our version: $file"
        git checkout --ours "$file"
        ;;
      *)
        echo "  📦 Using upstream version: $file"
        git checkout --theirs "$file"
        ;;
    esac
  done
  
  git add -A
  git commit -m "chore: sync with upstream (auto-resolved conflicts)" --no-edit || true
  echo "✅ Conflicts auto-resolved"
fi

# Restore stashed changes
if [ "$stashed" = true ]; then
  echo "📦 Restoring stashed changes..."
  if git stash pop; then
    echo "✅ Stashed changes restored"
  else
    echo "⚠️  Could not automatically apply stashed changes"
    echo "   Use 'git stash list' to see available stashes"
    echo "   Use 'git stash pop' to manually apply"
  fi
fi

echo ""
echo "=== Sync complete ==="
echo "📊 Recent commits:"
git log --oneline -5
echo ""
echo "📋 Current status:"
git status --short