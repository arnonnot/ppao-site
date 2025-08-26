#!/usr/bin/env bash
set -euo pipefail

# ===== CONFIGURE THESE TWO VALUES =====
GITHUB_USER="${GITHUB_USER:-}"         # e.g. yourusername
REPO_NAME="${REPO_NAME:-ppao-site}"    # change if you want a different repo name
# =====================================

if [[ -z "$GITHUB_USER" ]]; then
  echo "Please set GITHUB_USER environment variable, e.g. export GITHUB_USER=yourusername"
  exit 1
fi

# Check for required tools
command -v gh >/dev/null 2>&1 || { echo "GitHub CLI (gh) is required. See https://cli.github.com/"; exit 1; }
command -v git >/dev/null 2>&1 || { echo "git is required."; exit 1; }

# Authenticate if needed
gh auth status || gh auth login

# Create repo (private by default; change to public if you prefer)
gh repo create "$GITHUB_USER/$REPO_NAME" --public --source=. --remote=origin --push

# Ensure default branch is main
git branch -M main
git push -u origin main

# Enable Pages via GitHub Actions (workflow already included)
echo "Waiting for initial workflow run... (you can also check the Actions tab)"
echo "Once complete, your site should be at: https://$GITHUB_USER.github.io/"
echo "Main page:   https://$GITHUB_USER.github.io/pages/"
echo "HR project:  https://$GITHUB_USER.github.io/pages/hr/khrxngkar-thdsxb/"
