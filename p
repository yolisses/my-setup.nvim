#!/usr/bin/env bash
#
# git-push.sh — stage all changes, commit with a message, and push.
#
# Usage:
#   ./git-push.sh "your commit message"
#
# If no message is given as an argument, the script will prompt for one.

set -euo pipefail

# Make sure we're inside a git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Error: this directory is not a git repository." >&2
    exit 1
fi

# Get commit message from argument, or prompt for it
if [ "$#" -ge 1 ]; then
    COMMIT_MSG="$*"
else
    read -rp "Enter commit message: " COMMIT_MSG
    if [ -z "$COMMIT_MSG" ]; then
        echo "Error: commit message cannot be empty." >&2
        exit 1
    fi
fi

echo "Staging all changes..."
git add -A

# Check if there's anything to commit
if git diff --cached --quiet; then
    echo "Nothing to commit — working tree is clean (relative to last commit)."
    exit 0
fi

echo "Committing..."
git commit -m "$COMMIT_MSG"

echo "Pushing..."
git push

echo "Done."
