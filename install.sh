#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="${1:-.}"

if [ ! -d "$TARGET_DIR" ]; then
  echo "Error: target directory does not exist: $TARGET_DIR"
  exit 1
fi

if [ ! -f "$TARGET_DIR/index.html" ]; then
  echo "Warning: index.html was not found in $TARGET_DIR"
  echo "This kit is intended for static websites."
fi

mkdir -p "$TARGET_DIR/.github/workflows"

cp "$(dirname "$0")/templates/deploy.yml" "$TARGET_DIR/.github/workflows/deploy.yml"

echo "Installed Lolipop deployment workflow:"
echo "$TARGET_DIR/.github/workflows/deploy.yml"
echo
echo "Next: add these GitHub Repository Secrets:"
echo "  FTP_SERVER"
echo "  FTP_USERNAME"
echo "  FTP_PASSWORD"
echo "  FTP_SERVER_DIR"
